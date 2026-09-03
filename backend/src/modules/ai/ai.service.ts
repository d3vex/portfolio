import {
  Injectable,
  Logger,
  ServiceUnavailableException,
  BadRequestException,
  BadGatewayException,
  OnModuleInit,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { z } from 'zod';
import * as crypto from 'crypto';
import { Agent, fetch } from 'undici';
import { UserRole, User } from '../auth/entities/user.entity';
import { Skill } from '../skill/entities/skill.entity';
import { Category } from '../category/entities/category.entity';
import { Experience } from '../experience/entities/experience.entity';
import { ExperiencePoint } from '../experience/entities/experience-point.entity';
import { ExperiencePointSkill } from '../experience/entities/experience-point-skill.entity';
import { Project } from '../project/entities/project.entity';
import { ProjectPoint } from '../project/entities/project-point.entity';
import { ProjectPointSkill } from '../project/entities/project-point-skill.entity';
import { Education } from '../education/entities/education.entity';
import { Language } from '../language/entities/language.entity';
import { Passion } from '../passion/entities/passion.entity';
import { Profile } from '../profile/entities/profile.entity';
import { Image } from '../images/entities/image.entity';
import { GenerateCvDto } from './dto/generate-cv.dto';
import { ApplySuggestionsDto } from './dto/apply-suggestions.dto';
import { ApplySkillItemDto, ApplyBulletItemDto } from './dto/apply-suggestions.dto';
import {
  GenerateCvOptions,
  GenerateCvResult,
  OllamaStatus,
  OllamaChatMessage,
  CvSelectionRaw,
  CvWritingRaw,
  SELECTION_JSON_SCHEMA,
  WRITING_JSON_SCHEMA,
  AppliedSkillResult,
  AppliedBulletResult,
} from './types';
import {
  buildSelectionSystemPrompt,
  buildSelectionUserPrompt,
  buildWritingSystemPrompt,
  buildWritingUserPrompt,
} from './prompts';

const OLLAMA_STATUS_TIMEOUT_MS = 10_000;
const OLLAMA_CHAT_TIMEOUT_MS = Number(
  process.env.OLLAMA_TIMEOUT_MS ?? 900_000,
);
const MAX_PROJECT_BULLETS_PER_PROJECT = 2;

const GENERATE_CV_OPTIONS_DEFAULTS: GenerateCvOptions = {
  style: 'auto',
  aboutLength: 'medium',
  maxExperiences: 5,
  maxProjects: 5,
  includeSoftSkills: true,
  includeLanguages: true,
  tone: 'professional',
  allowSkillSuggestions: true,
  allowBulletSuggestions: true,
};

@Injectable()
export class AiService implements OnModuleInit {
  private readonly logger = new Logger(AiService.name);
  private readonly ollamaBaseUrl =
    process.env.OLLAMA_BASE_URL ?? 'http://localhost:11434';
  private readonly ollamaModel = process.env.OLLAMA_MODEL ?? 'qwen2.5:7b';
  // undici's default bodyTimeout (300s) aborts long generations mid-stream with
  // "fetch failed"; disable it and rely on the explicit AbortSignal.timeout below.
  private readonly ollamaAgent = new Agent({ bodyTimeout: 0 });
  private readonly aiAgentUsername = process.env.AI_AGENT_USERNAME ?? 'ai-agent';
  private readonly aiAgentPassword =
    process.env.AI_AGENT_PASSWORD ?? 'change-me-ai-agent';

  constructor(
    @InjectRepository(Profile) private readonly profileRepo: Repository<Profile>,
    @InjectRepository(Skill) private readonly skillRepo: Repository<Skill>,
    @InjectRepository(Category) private readonly categoryRepo: Repository<Category>,
    @InjectRepository(Experience) private readonly experienceRepo: Repository<Experience>,
    @InjectRepository(ExperiencePoint) private readonly experiencePointRepo: Repository<ExperiencePoint>,
    @InjectRepository(Project) private readonly projectRepo: Repository<Project>,
    @InjectRepository(ProjectPoint) private readonly projectPointRepo: Repository<ProjectPoint>,
    @InjectRepository(ProjectPointSkill) private readonly projectPointSkillRepo: Repository<ProjectPointSkill>,
    @InjectRepository(ExperiencePointSkill) private readonly experiencePointSkillRepo: Repository<ExperiencePointSkill>,
    @InjectRepository(Education) private readonly educationRepo: Repository<Education>,
    @InjectRepository(Language) private readonly languageRepo: Repository<Language>,
    @InjectRepository(Passion) private readonly passionRepo: Repository<Passion>,
    @InjectRepository(Image) private readonly imageRepo: Repository<Image>,
    @InjectRepository(User) private readonly userRepo: Repository<User>,
  ) {}

  async onModuleInit(): Promise<void> {
    await this.ensureAiAgent();
  }

  private async ensureAiAgent(): Promise<void> {
    const existing = await this.userRepo.findOne({
      where: { username: this.aiAgentUsername },
    });
    if (existing) {
      this.logger.log(`AI agent user '${this.aiAgentUsername}' already exists`);
      return;
    }
    const hashedPassword = crypto
      .createHash('sha256')
      .update(this.aiAgentPassword)
      .digest('hex');
    const aiUser = this.userRepo.create({
      username: this.aiAgentUsername,
      password: hashedPassword,
      role: UserRole.AI,
    });
    await this.userRepo.save(aiUser);
    this.logger.log(`Created AI agent user '${this.aiAgentUsername}' with role AI`);
  }

  async getStatus(): Promise<OllamaStatus> {
    try {
      const res = await fetch(`${this.ollamaBaseUrl}/api/tags`, {
        signal: AbortSignal.timeout(OLLAMA_STATUS_TIMEOUT_MS),
      });
      if (!res.ok) {
        return {
          available: false,
          model: this.ollamaModel,
          baseUrl: this.ollamaBaseUrl,
          models: [],
          error: `Ollama responded with status ${res.status}`,
        };
      }
      const data = (await res.json()) as { models?: Array<{ name?: string }> };
      const models = (data.models ?? []).map((m) => m.name ?? '');
      return {
        available: models.length > 0,
        model: this.ollamaModel,
        baseUrl: this.ollamaBaseUrl,
        models,
        error: null,
      };
    } catch (err) {
      return {
        available: false,
        model: this.ollamaModel,
        baseUrl: this.ollamaBaseUrl,
        models: [],
        error: err instanceof Error ? err.message : String(err),
      };
    }
  }

  async generateCv(dto: GenerateCvDto): Promise<GenerateCvResult> {
    if (!dto.jobDescription.trim()) {
      throw new BadRequestException('jobDescription is required');
    }

    const status = await this.getStatus();
    if (!status.available) {
      throw new ServiceUnavailableException(
        `Ollama is not available: ${status.error ?? 'unknown error'}`,
      );
    }

    const options = {
      ...GENERATE_CV_OPTIONS_DEFAULTS,
      ...(dto.options ?? {}),
    } as GenerateCvOptions;

    const startedAt = Date.now();
    try {
      const selection = await this.generateSelection(options, dto.jobDescription);
      const writing = await this.generateWriting(options, dto.jobDescription, selection);
      const result = await this.mergeResult(selection, writing);
      this.logger.log(
        `CV generated in ${Math.round((Date.now() - startedAt) / 1000)}s (2 phases) ` +
          `(${result.cv.skillIds.length} skills, ${result.cv.experienceIds.length} experiences, ` +
          `${result.cv.projectIds.length} projects)`,
      );
      return result;
    } catch (err) {
      if (
        err instanceof ServiceUnavailableException ||
        err instanceof BadGatewayException ||
        err instanceof BadRequestException
      ) {
        throw err;
      }
      const message = err instanceof Error ? err.message : String(err);
      throw new BadGatewayException(`Failed to generate CV: ${message}`);
    }
  }

  private async generateSelection(
    options: GenerateCvOptions,
    jobDescription: string,
  ): Promise<CvSelectionRaw> {
    const images = await this.imageRepo.find({ order: { createdAt: 'DESC' } });
    const context = await this.buildContextData(undefined, images);
    const messages: OllamaChatMessage[] = [
      {
        role: 'system',
        content: [buildSelectionSystemPrompt(options), context].join('\n\n'),
      },
      { role: 'user', content: buildSelectionUserPrompt(jobDescription) },
    ];
    const selection = await this.generateJson(
      messages,
      SELECTION_JSON_SCHEMA,
      this.buildSelectionSchema(),
      'selection',
      false,
    );
    selection.pictureId = this.resolvePictureId(selection.pictureId, images);
    return selection;
  }

  private resolvePictureId(pictureId: string, images: Image[]): string {
    if (pictureId && images.some((img) => img.id === pictureId)) {
      return pictureId;
    }
    const fallback = images.find((img) => img.mimeType.startsWith('image/jpeg')) ?? images[0];
    if (fallback) {
      this.logger.warn(
        `LLM pictureId '${pictureId || '(empty)'}' is not an available image; ` +
          `falling back to image ${fallback.id}`,
      );
      return fallback.id;
    }
    this.logger.warn('No image available for the CV picture');
    return '';
  }

  private async generateWriting(
    options: GenerateCvOptions,
    jobDescription: string,
    selection: CvSelectionRaw,
  ): Promise<CvWritingRaw> {
    const context = await this.buildContextData({
      skillIds: selection.skillIds,
      experienceIds: selection.experienceIds,
      projectIds: selection.projectIds,
    });
    const system = [
      buildWritingSystemPrompt(options),
      '# SELECTION SUMMARY',
      this.buildSelectionSummary(selection),
      '',
      '# SELECTED ENTITIES DATA (only the entities selected above; use ONLY these ids)',
      context,
    ].join('\n\n');
    const messages: OllamaChatMessage[] = [
      { role: 'system', content: system },
      { role: 'user', content: buildWritingUserPrompt(jobDescription) },
    ];
    return this.generateJson(
      messages,
      WRITING_JSON_SCHEMA,
      this.buildWritingSchema(),
      'writing',
      false,
    );
  }

  private buildSelectionSummary(selection: CvSelectionRaw): string {
    return [
      `name: ${selection.name}`,
      `style: ${selection.style}`,
      `pictureId: ${selection.pictureId}`,
      `skills: ${selection.skillIds.join(', ')}`,
      `experiences: ${selection.experienceIds.join(', ')}`,
      `projects: ${selection.projectIds.join(', ')}`,
      `projectBullets: ${selection.projectBullets
        .map((b) => `${b.projectId}[${b.indices.join(',')}]`)
        .join(' ')}`,
      `education: ${selection.educationIds.join(', ')}`,
      `languages: ${selection.languageIds.join(', ')}`,
      `passions: ${selection.passionIds.join(', ')}`,
    ].join('\n');
  }

  private async generateJson<T>(
    messages: OllamaChatMessage[],
    format: unknown,
    schema: z.ZodType<T>,
    phase: string,
    isRetry: boolean,
  ): Promise<T> {
    const resp = await this.ollamaChat(messages, format);
    const content = (resp.message?.content ?? '').trim();
    if (!content) {
      throw new BadGatewayException('Ollama returned an empty response');
    }

    const parsed = this.parseJsonResponse(content);
    const validation = schema.safeParse(parsed);
    if (validation.success) {
      return validation.data;
    }

    if (isRetry) {
      throw new BadGatewayException(
        `LLM ${phase} response invalid after retry: ${validation.error.message}`,
      );
    }

    this.logger.warn(
      `Initial LLM ${phase} JSON failed validation (${validation.error.message}); retrying once`,
    );
    messages.push({ role: 'assistant', content });
    messages.push({
      role: 'user',
      content: [
        'Your previous response did not match the required JSON structure.',
        'Validation error:',
        validation.error.message,
        'Return ONLY the corrected JSON object with the exact same schema.',
      ].join('\n'),
    });
    return this.generateJson(messages, format, schema, phase, true);
  }

  private buildSelectionSchema() {
    return z.object({
      name: z.string(),
      candidateName: z.string(),
      specialization: z.string(),
      style: z.enum(['classic', 'ats', 'two-column-blue']),
      pictureId: z.string(),
      skillIds: z.array(z.string()),
      experienceIds: z.array(z.string()),
      projectIds: z.array(z.string()),
      projectBullets: z.array(
        z.object({
          projectId: z.string(),
          indices: z.array(z.number().int()),
        }),
      ),
      educationIds: z.array(z.string()),
      languageIds: z.array(z.string()),
      passionIds: z.array(z.string()),
    });
  }

  private buildWritingSchema() {
    return z.object({
      titleOverride: z.string(),
      aboutText: z.string(),
      availability: z.string(),
      suggestions: z.object({
        skills: z.array(
          z.object({
            id: z.string(),
            name: z.string(),
            description: z.string(),
            cvCategory: z.enum(['hard', 'soft']),
            categoryName: z.string(),
            level: z.number().int().min(1).max(10),
            rationale: z.string(),
          }),
        ),
        bullets: z.array(
          z.object({
            id: z.string(),
            entityType: z.enum(['project', 'experience']),
            entityId: z.string(),
            text: z.string(),
            skillIds: z.array(z.string()),
            rationale: z.string(),
          }),
        ),
      }),
      justification: z.string(),
    });
  }

  private async mergeResult(selection: CvSelectionRaw, writing: CvWritingRaw): Promise<GenerateCvResult> {
    const projectBullets: Record<string, number[]> = {};
    for (const entry of selection.projectBullets) {
      const seen = new Set(projectBullets[entry.projectId] ?? []);
      for (const idx of entry.indices) {
        if (!Number.isInteger(idx) || idx < 0 || seen.has(idx) || seen.size >= MAX_PROJECT_BULLETS_PER_PROJECT) continue;
        seen.add(idx);
      }
      projectBullets[entry.projectId] = [...seen].sort((a, b) => a - b);
    }
    const cvProjectPointIds = await this.resolveBulletsToPointIds(projectBullets, selection.projectIds);
    return {
      cv: {
        name: selection.name,
        candidateName: selection.candidateName || null,
        specialization: selection.specialization,
        titleOverride: writing.titleOverride,
        aboutText: writing.aboutText,
        availability: writing.availability || null,
        style: selection.style,
        pictureId: selection.pictureId || null,
        skillIds: selection.skillIds,
        experienceIds: selection.experienceIds,
        projectIds: selection.projectIds,
        cvProjectPointIds,
        educationIds: selection.educationIds,
        languageIds: selection.languageIds,
        passionIds: selection.passionIds,
      },
      suggestions: {
        ...writing.suggestions,
        skills: writing.suggestions.skills.map((s) => ({
          ...s,
          level: Math.max(1, Math.min(5, s.level)),
        })),
      },
      justification: writing.justification,
    };
  }

  private async resolveBulletsToPointIds(
    projectBullets: Record<string, number[]>,
    projectIds: string[],
  ): Promise<string[]> {
    if (!projectIds.length) return [];
    const projects = await this.projectRepo.find({
      where: { id: In(projectIds) },
      relations: { projectPoints: true },
    });
    const projectById = new Map(projects.map((p) => [p.id, p]));
    const pointIds: string[] = [];
    for (const [projectId, indices] of Object.entries(projectBullets)) {
      const project = projectById.get(projectId);
      if (!project) continue;
      const sorted = [...(project.projectPoints ?? [])].sort((a, b) => a.order - b.order);
      for (const idx of indices) {
        const point = sorted[idx];
        if (point) pointIds.push(point.id);
      }
    }
    return pointIds;
  }

  private async ollamaChat(
    messages: OllamaChatMessage[],
    format: unknown = null,
  ): Promise<{ message?: { content?: string } }> {
    const controller = new AbortController();
    let timedOut = false;
    let stoppedEarly = false;
    const timeout = setTimeout(() => {
      timedOut = true;
      controller.abort();
    }, OLLAMA_CHAT_TIMEOUT_MS);

    const res = await fetch(`${this.ollamaBaseUrl}/api/chat`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      signal: controller.signal,
      dispatcher: this.ollamaAgent,
      body: JSON.stringify({
        model: this.ollamaModel,
        messages,
        // Stream and stop as soon as the root JSON object closes: with stream:false
        // the model keeps generating well past the closing brace (2117+ tokens seen),
        // wasting minutes and risking the 600s timeout.
        stream: true,
        format,
        options: {
          temperature: 0.2,
          num_ctx: 8192,
          num_predict: 4096,
        },
      }),
    });

    if (!res.ok) {
      clearTimeout(timeout);
      let detail = '';
      try {
        detail = (await res.text()).slice(0, 300);
      } catch {
        detail = 'unknown error';
      }
      throw new ServiceUnavailableException(
        `Ollama API error (${res.status}): ${detail}`,
      );
    }

    let content = '';
    let buffer = '';
    const decoder = new TextDecoder();
    try {
      for await (const chunk of res.body ?? []) {
        buffer += decoder.decode(chunk, { stream: true });
        let nl: number;
        while ((nl = buffer.indexOf('\n')) >= 0) {
          const line = buffer.slice(0, nl).trim();
          buffer = buffer.slice(nl + 1);
          if (!line) continue;
          let data: { message?: { content?: string }; done?: boolean };
          try {
            data = JSON.parse(line);
          } catch {
            continue;
          }
          if (typeof data.message?.content === 'string') {
            content += data.message.content;
          }
          if (data.done) {
            return { message: { content } };
          }
        }
        if (format && content.trim()) {
          try {
            JSON.parse(content);
            stoppedEarly = true;
            // Aborting the connection makes llama-server cancel the task upstream.
            controller.abort();
            return { message: { content } };
          } catch {
            // Root JSON not closed yet; keep consuming chunks.
          }
        }
      }
    } catch (err) {
      if (timedOut) {
        throw new ServiceUnavailableException(
          `Ollama request timed out after ${OLLAMA_CHAT_TIMEOUT_MS}ms`,
        );
      }
      if (!stoppedEarly) {
        throw err;
      }
    } finally {
      clearTimeout(timeout);
    }
    return { message: { content } };
  }

  private async buildContextData(
    filter?: {
      skillIds?: string[];
      experienceIds?: string[];
      projectIds?: string[];
    },
    images?: Image[],
  ): Promise<string> {
    const [profileRows, skills, categories, experiences, projects, educationRows, languages, passions] =
      await Promise.all([
        this.profileRepo.find(),
        this.skillRepo.find({ order: { order: 'ASC' } }),
        this.categoryRepo.find(),
        this.experienceRepo.find({
          relations: { experiencePoints: { skillLinks: { skill: true } } },
          order: { order: 'ASC' },
        }),
        this.projectRepo.find({
          relations: { projectPoints: { skillLinks: { skill: true } }, technologies: true },
          order: { order: 'ASC' },
        }),
        this.educationRepo.find({ order: { order: 'ASC' } }),
        this.languageRepo.find({ order: { order: 'ASC' } }),
        this.passionRepo.find({ order: { order: 'ASC' } }),
      ]);

    const catName = new Map(categories.map((c) => [c.id, c.label || c.name]));
    const selectedSkills = filter?.skillIds
      ? skills.filter((s) => filter.skillIds?.includes(s.id))
      : skills;
    const selectedExperiences = filter?.experienceIds
      ? experiences.filter((e) => filter.experienceIds?.includes(e.id))
      : experiences;
    const selectedProjects = filter?.projectIds
      ? projects.filter((p) => filter.projectIds?.includes(p.id))
      : projects;

    const lines: string[] = [];

    for (const p of profileRows) {
      const name = [p.firstName, p.lastName].filter(Boolean).join(' ');
      lines.push(
        `PROFILE: ${name || '(no name)'}` +
          (p.initials ? ` | initials: ${p.initials}` : '') +
          (p.specialization ? ` | specialization: ${p.specialization}` : '') +
          (p.availability ? ` | availability: ${p.availability}` : ''),
      );
      if (p.about) {
        lines.push(`  about: ${p.about}`);
      }
    }

    lines.push('SKILLS (id | name | type | category | level/5):');
    for (const s of selectedSkills) {
      lines.push(
        `- ${s.id} | ${s.name} | ${s.cvCategory} | ${catName.get(s.categoryId) ?? ''} | ${s.level}`,
      );
    }
    if (!selectedSkills.length) {
      lines.push('- (none)');
    }

    lines.push('EXPERIENCES (id | title | company | dates):');
    for (const e of selectedExperiences) {
      lines.push(
        `- ${e.id} | ${e.title} | ${e.company ?? ''} | ${e.startDate ?? ''} -> ${e.endDate ?? ''}` +
          (e.location ? ` | ${e.location}` : ''),
      );
      if (filter?.experienceIds) {
        const pts = [...(e.experiencePoints ?? [])].sort((a, b) => a.order - b.order);
        if (pts.length) {
          for (const pt of pts) {
            const pSkills = (pt.skillLinks ?? [])
              .map((l) => l.skill?.name)
              .filter(Boolean)
              .join(', ');
            lines.push(
              `    point: ${pt.text}` +
                (pSkills ? ` [skills: ${pSkills}]` : ''),
            );
          }
        } else if (e.description) {
          lines.push(`    point: ${e.description}`);
        }
      }
    }
    if (!selectedExperiences.length) {
      lines.push('- (none)');
    }

    lines.push('PROJECTS (id | title | status | dates | technologies | points):');
    for (const p of selectedProjects) {
      lines.push(
        `- ${p.id} | ${p.title}` +
          (p.subtitle ? ` — ${p.subtitle}` : '') +
          (p.status ? ` | ${p.status}` : '') +
          ` | ${p.startDate ?? ''} -> ${p.endDate ?? ''}` +
          (p.featured ? ' | FEATURED' : ''),
      );
      if (p.technologies?.length) {
        lines.push(
          `    technologies: ${p.technologies.map((t) => t.name).join(', ')}`,
        );
      }
      const pts = [...(p.projectPoints ?? [])].sort((a, b) => a.order - b.order);
      for (const [i, pt] of pts.entries()) {
        const pSkills = (pt.skillLinks ?? [])
          .map((l) => l.skill?.name)
          .filter(Boolean)
          .join(', ');
        lines.push(
          `    point index ${i}: ${pt.text}` +
            (pSkills ? ` [skills: ${pSkills}]` : ''),
        );
      }
    }
    if (!selectedProjects.length) {
      lines.push('- (none)');
    }

    lines.push('EDUCATION (id | title | school | dates | description):');
    for (const e of educationRows) {
      lines.push(
        `- ${e.id} | ${e.title} | ${e.school ?? ''} | ${e.startDate ?? ''} -> ${e.endDate ?? ''}` +
          (e.description ? ` | ${e.description}` : ''),
      );
    }

    lines.push('LANGUAGES (id | name | level):');
    for (const l of languages) {
      lines.push(`- ${l.id} | ${l.name} | ${l.level ?? ''}`);
    }

    lines.push('PASSIONS (id | name | description):');
    for (const p of passions) {
      lines.push(`- ${p.id} | ${p.name} | ${p.description ?? ''}`);
    }

    if (images?.length) {
      lines.push('AVAILABLE IMAGES (id | file | type) — pick ONE id for the CV header picture:');
      for (const img of images) {
        lines.push(
          `- ${img.id} | ${img.originalName ?? '(no name)'} | ${img.mimeType}`,
        );
      }
    }

    return lines.join('\n');
  }

  private parseJsonResponse(text: string): unknown {
    const cleaned = text
      .replace(/```(?:json)?/gi, '')
      .replace(/```/g, '')
      .trim();
    try {
      return JSON.parse(cleaned);
    } catch {
      const start = cleaned.indexOf('{');
      const end = cleaned.lastIndexOf('}');
      if (start !== -1 && end !== -1 && end > start) {
        return JSON.parse(cleaned.slice(start, end + 1));
      }
      throw new BadGatewayException(
        'Impossible d\'extraire du JSON valide de la réponse LLM / Could not extract valid JSON from LLM response',
      );
    }
  }

  async applySuggestions(dto: ApplySuggestionsDto): Promise<{
    skills: AppliedSkillResult[];
    bullets: AppliedBulletResult[];
  }> {
    const skills: AppliedSkillResult[] = [];
    for (const item of dto.skills ?? []) {
      skills.push(await this.applySkill(item));
    }
    const bullets: AppliedBulletResult[] = [];
    for (const item of dto.bullets ?? []) {
      bullets.push(await this.applyBullet(item));
    }
    return { skills, bullets };
  }

  private async applySkill(item: ApplySkillItemDto): Promise<AppliedSkillResult> {
    const suggestionId = item.suggestionId ?? null;

    const existing = await this.skillRepo.findOne({
      where: { name: item.name },
    });
    if (existing) {
      return {
        suggestionId,
        name: existing.name,
        id: existing.id,
        categoryId: existing.categoryId,
      };
    }

    const categoryName = item.categoryName?.trim();
    let category: Category | null = null;
    if (categoryName) {
      category = await this.categoryRepo.findOne({
        where: { name: categoryName },
      });
      if (!category) {
        category = this.categoryRepo.create({ name: categoryName, label: categoryName });
        category = await this.categoryRepo.save(category);
      }
    }

    const maxOrder = await this.skillRepo
      .createQueryBuilder('skill')
      .select('COALESCE(MAX(skill.order), -1)', 'max')
      .getRawOne<{ max: number }>();

    const skill = this.skillRepo.create({
      name: item.name,
      description: item.description ?? null,
      cvCategory: item.cvCategory as 'hard' | 'soft',
      categoryId: category?.id ?? null,
      level: item.level,
      order: (maxOrder?.max ?? -1) + 1,
    });
    await this.skillRepo.save(skill);

    return {
      suggestionId,
      name: skill.name,
      id: skill.id,
      categoryId: skill.categoryId,
    };
  }

  private async applyBullet(item: ApplyBulletItemDto): Promise<AppliedBulletResult> {
    const suggestionId = item.suggestionId ?? null;

    if (item.entityType === 'project') {
      const maxOrder = await this.projectPointRepo
        .createQueryBuilder('point')
        .select('COALESCE(MAX(point.order), -1)', 'max')
        .getRawOne<{ max: number }>();
      const point = this.projectPointRepo.create({
        text: item.text,
        order: (maxOrder?.max ?? -1) + 1,
        projectId: item.entityId,
      });
      await this.projectPointRepo.save(point);
      for (const skillId of item.skillIds ?? []) {
        await this.projectPointSkillRepo.save(
          this.projectPointSkillRepo.create({ pointId: point.id, skillId }),
        );
      }

      const project = await this.projectRepo.findOne({
        where: { id: item.entityId },
        relations: { projectPoints: true },
      });
      const sorted = [...(project?.projectPoints ?? [])].sort(
        (a, b) => a.order - b.order,
      );
      const index = sorted.findIndex((p) => p.id === point.id);
      return {
        suggestionId,
        entityType: item.entityType,
        entityId: item.entityId,
        pointId: point.id,
        order: point.order,
        index,
      };
    }

    const maxOrder = await this.experiencePointRepo
      .createQueryBuilder('point')
      .select('COALESCE(MAX(point.order), -1)', 'max')
      .getRawOne<{ max: number }>();
    const point = this.experiencePointRepo.create({
      text: item.text,
      order: (maxOrder?.max ?? -1) + 1,
      experienceId: item.entityId,
    });
    await this.experiencePointRepo.save(point);
    for (const skillId of item.skillIds ?? []) {
      await this.experiencePointSkillRepo.save(
        this.experiencePointSkillRepo.create({ pointId: point.id, skillId }),
      );
    }

    const experience = await this.experienceRepo.findOne({
      where: { id: item.entityId },
      relations: { experiencePoints: true },
    });
    const sorted = [...(experience?.experiencePoints ?? [])].sort(
      (a, b) => a.order - b.order,
    );
    const index = sorted.findIndex((p) => p.id === point.id);
    return {
      suggestionId,
      entityType: item.entityType,
      entityId: item.entityId,
      pointId: point.id,
      order: point.order,
      index,
    };
  }
}
