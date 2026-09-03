import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import Handlebars from 'handlebars';
import { CvService } from '../cv/cv.service';
import { Skill } from '../skill/entities/skill.entity';
import { Project } from '../project/entities/project.entity';
import { ProjectPoint } from '../project/entities/project-point.entity';
import { Profile } from '../profile/entities/profile.entity';
import { StylesService } from './styles/styles.service';

const GOOGLE_FONTS_LINK =
  '<link rel="preconnect" href="https://fonts.googleapis.com">' +
  '<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>' +
  '<link href="https://fonts.googleapis.com/css2?family=Archivo:wght@400;500;600;700;800&family=Space+Grotesk:wght@300;400;500;600;700&display=swap" rel="stylesheet">';

export interface RenderResult {
  html: string;
  displayName: string;
  styleId: string;
}

export interface CvPayloadPoint {
  text: string;
  skillIds: string[];
  skillRef: string;
}

export interface CvPayloadExperience {
  role: string;
  company: string;
  companyUrl: string | null;
  companyHost: string;
  location: string | null;
  startDate: string | null;
  endDate: string | null;
  startLabel: string;
  endLabel: string;
  startMachine: string;
  endMachine: string;
  summary: string | null;
  points: CvPayloadPoint[];
  order: number;
}

export interface CvPayloadProject {
  name: string;
  subtitle: string | null;
  description: string | null;
  longDescription: string | null;
  startDate: string | null;
  endDate: string | null;
  startLabel: string;
  endLabel: string;
  startMachine: string;
  endMachine: string;
  link: string | null;
  liveUrl: string | null;
  sourceUrl: string | null;
  points: CvPayloadPoint[];
  order: number;
}

export interface CvPayloadEducation {
  title: string;
  school: string | null;
  startDate: string | null;
  endDate: string | null;
  startLabel: string;
  endLabel: string;
  startMachine: string;
  endMachine: string;
  description: string | null;
}

export interface CvPayloadSkill {
  id: string;
  name: string;
  icon: string | null;
  iconHref: string | null;
  description: string | null;
  level: number;
  cvCategory: 'hard' | 'soft';
}

export interface CvPayloadContact {
  id: string;
  label: string;
  value: string;
  displayValue: string;
  linkHref: string | null;
  iconHref: string | null;
  slot: 'email' | 'phone' | 'city' | 'link' | 'other';
}

export interface CvPayloadPassion {
  id: string;
  name: string;
  description: string | null;
  icon: string | null;
  iconHref: string | null;
}

export interface CvRenderPayload {
  cv: {
    id: string;
    name: string;
    candidateName: string | null;
    specialization: string | null;
    titleOverride: string | null;
    titleText: string;
    aboutText: string | null;
    aboutHtml: string;
    availability: string | null;
    isDefault: boolean;
    style: string | null;
    pictureUrl: string | null;
    pictureStyle: string | null;
    displayName: string;
    initials: string;
  };
  profile: Profile | null;
  contacts: CvPayloadContact[];
  links: { text: string; linkHref: string | null }[];
  skills: { hard: CvPayloadSkill[]; soft: CvPayloadSkill[] };
  languages: { name: string; level: string }[];
  passions: CvPayloadPassion[];
  experiences: CvPayloadExperience[];
  projects: CvPayloadProject[];
  education: CvPayloadEducation[];
}

function escapeHtml(value: string): string {
  return value
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

Handlebars.registerHelper('eq', (a: unknown, b: unknown) => a === b);
Handlebars.registerHelper('or', (...args: unknown[]) => {
  args.pop();
  return args.some(Boolean);
});

function contactSlot(contact: {
  label?: string | null;
  icon?: string | null;
  type?: string | null;
  linkHref?: string | null;
}): CvPayloadContact['slot'] {
  const label = (contact.label || '').toLowerCase();
  const icon = (contact.icon || '').toLowerCase();
  if (/email|mail/.test(label) || icon.includes('email')) return 'email';
  if (/phone|téléphone|telephone/.test(label) || icon.includes('phone')) return 'phone';
  if (/city|ville|address|adresse|location|localisation/.test(label) || icon.includes('map-marker')) return 'city';
  if (contact.type === 'link' || Boolean(contact.linkHref)) return 'link';
  return 'other';
}

function iconHref(icon: string | null | undefined, color: string): string | null {
  if (!icon) return null;
  const separator = icon.indexOf(':');
  if (separator <= 0) return null;
  const prefix = icon.slice(0, separator);
  const name = icon.slice(separator + 1);
  return `https://api.iconify.design/${prefix}/${name}.svg?height=16&color=${encodeURIComponent(color)}`;
}

function formatDateLabel(date: string | null | undefined): string {
  if (!date) return '';
  const parsed = new Date(date);
  if (Number.isNaN(parsed.getTime())) return date;
  try {
    return new Intl.DateTimeFormat('fr-FR', { month: 'short', year: 'numeric' }).format(parsed);
  } catch {
    return date;
  }
}

function machineDate(date: string | null | undefined): string {
  if (!date) return '';
  if (/^\d{4}-\d{2}$/.test(date)) return date;
  const parsed = new Date(date);
  if (!Number.isNaN(parsed.getTime())) {
    const year = parsed.getFullYear();
    const month = String(parsed.getMonth() + 1).padStart(2, '0');
    return `${year}-${month}`;
  }
  return date;
}

function formatAboutHtml(text: string | null | undefined): string {
  if (!text) return '';
  return text
    .replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
    .replace(/\n/g, '<br>');
}

function hostnameOf(url: string): string {
  try {
    return new URL(url).hostname;
  } catch {
    return url;
  }
}

function normalizePoint(point: unknown, skillNameById: Map<string, string>): CvPayloadPoint {
  const isString = typeof point === 'string';
  const text = isString ? point : String((point as { text?: unknown })?.text ?? '');
  const rawIds = isString
    ? []
    : (point as { skillLinks?: unknown[]; skillIds?: unknown })?.skillLinks?.length
      ? ((point as { skillLinks: { skillId?: string }[] }).skillLinks).map((l) => l.skillId ?? '')
      : ((point as { skillIds?: unknown })?.skillIds ?? []);
  const skillIds = Array.isArray(rawIds)
    ? rawIds.filter((id): id is string => typeof id === 'string')
    : [];
  const skillRef = skillIds
    .map((id) => skillNameById.get(id))
    .filter((name): name is string => Boolean(name))
    .join(', ');
  return { text, skillIds, skillRef };
}

type OrderedCv = Awaited<ReturnType<CvService['findOne']>>;

@Injectable()
export class RenderService {
  constructor(
    @InjectRepository(Profile)
    private readonly profileRepo: Repository<Profile>,
    private readonly cvService: CvService,
    private readonly styles: StylesService,
  ) {}

  async renderHtml(
    id: string,
    styleId: string | undefined,
    baseUrl: string,
    zoom?: number,
  ): Promise<RenderResult> {
    const { payload, displayName } = await this.buildPayload(id, baseUrl, zoom);
    const style = this.styles.get(styleId);
    const template = this.styles.getTemplate(style.id);
    const css = this.styles.getCss(style.id);
    const body = Handlebars.compile(template)(payload);
    const fonts = style.id === 'ats' ? '' : GOOGLE_FONTS_LINK;
    const title = escapeHtml(displayName || 'CV');
    const html =
      '<!DOCTYPE html><html lang="fr"><head><meta charset="utf-8">' +
      '<meta name="viewport" content="width=device-width,initial-scale=1">' +
      `<title>${title}</title>${fonts}<style>${css}</style>` +
      `</head><body>${body}</body></html>`;
    return { html, displayName, styleId: style.id };
  }

  private async buildPayload(
    id: string,
    baseUrl: string,
    zoom?: number,
  ): Promise<{ payload: CvRenderPayload; displayName: string }> {
    const cv: OrderedCv = await this.cvService.findOne(id);
    const styleId = cv.style ?? null;

    const displayName = cv.candidateName || cv.name;
    const initials = displayName
      ? displayName
          .split(/\s+/)
          .map((part) => part[0] ?? '')
          .join('')
          .slice(0, 2)
          .toUpperCase()
      : 'LM';
    const titleText = cv.titleOverride || cv.specialization || 'Professional';

    const skills = cv.skills || [];
    const skillNameById = new Map<string, string>(
      skills.map((skill) => [skill.id, skill.name]),
    );

    const skillToPayload = (skill: Skill): CvPayloadSkill => ({
      id: skill.id,
      name: skill.name,
      icon: skill.icon ?? null,
      iconHref: iconHref(skill.icon, '#3B82F6'),
      description: skill.description ?? null,
      level: skill.level,
      cvCategory: skill.cvCategory,
    });

    const hard = skills.filter((s) => s.cvCategory === 'hard').map(skillToPayload);
    const soft = skills.filter((s) => s.cvCategory === 'soft').map(skillToPayload);

    const profile = await this.profileRepo.findOne({ where: {} }) ?? null;

    const contacts = (cv.contacts || []).map((contact): CvPayloadContact => {
      const value = contact.value || '';
      return {
        id: contact.id,
        label: contact.label,
        value,
        displayValue: value.replace(/^https?:\/\//, '').replace(/\/$/, ''),
        linkHref:
          contact.type === 'link'
            ? value.startsWith('http')
              ? value
              : `https://${value}`
            : null,
        iconHref: iconHref(contact.icon, '#E4E4E7'),
        slot: contactSlot(contact),
      };
    });

    const links = contacts
      .filter((contact) => contact.slot === 'link' || contact.slot === 'other')
      .map((contact) => {
        const label = contact.label.trim();
        const hasLabel = label.length > 0 && label !== contact.displayValue;
        return {
          // "Label: value" so the target URL is visible in printed/PDF output
          // (links are not clickable there); bare value when no distinct label.
          text: hasLabel ? `${label}: ${contact.displayValue}` : contact.displayValue,
          linkHref: contact.linkHref,
        };
      });

    // Sort by the entity `order` column to match the global list order the
    // builder previews (EducationService/ExperienceService.findAll order ASC).
    // Without this, the ManyToMany relation order (join table) can invert the
    // sections on the exported/printed CV compared to the on-screen preview.
    const experiences = (cv.experiences || [])
      .slice()
      .sort((a, b) => a.order - b.order)
      .map((exp): CvPayloadExperience => ({
      role: exp.title,
      company: exp.company,
      companyUrl: exp.companyUrl ?? null,
      companyHost: exp.companyUrl ? hostnameOf(exp.companyUrl) : '',
      location: exp.location ?? null,
      startDate: exp.startDate ?? null,
      endDate: exp.endDate ?? null,
      startLabel: formatDateLabel(exp.startDate),
      endLabel: formatDateLabel(exp.endDate),
      startMachine: machineDate(exp.startDate),
      endMachine: machineDate(exp.endDate),
      summary: exp.description ?? null,
      points: (exp.experiencePoints || [])
        .slice()
        .sort((a, b) => a.order - b.order)
        .map((point) => normalizePoint(point, skillNameById)),
      order: exp.order,
    }));

    const projects = (cv.projects || []).map((project): CvPayloadProject => {
      const mainLink = this.mainProjectLink(project);
      return {
      name: project.title,
      subtitle: project.subtitle ?? null,
      description: project.description ?? null,
      longDescription: this.cappedLongDescription(project),
      startDate: project.startDate ?? null,
      endDate: project.endDate ?? null,
      startLabel: formatDateLabel(project.startDate),
      endLabel: formatDateLabel(project.endDate),
      startMachine: machineDate(project.startDate),
      endMachine: machineDate(project.endDate),
      link: mainLink?.url ?? null,
        liveUrl: mainLink?.url ?? null,
        sourceUrl: mainLink?.url ?? null,
      points: this.projectPoints(project, cv.projectBullets).map((point) =>
        normalizePoint(point, skillNameById),
      ),
      order: project.order,
      };
    });

    const education = (cv.education || [])
      .slice()
      .sort((a, b) => a.order - b.order)
      .map((edu): CvPayloadEducation => {
      const start = edu.startDate || edu.date || null;
      return {
        title: edu.title,
        school: edu.school ?? null,
        startDate: start,
        endDate: edu.endDate ?? null,
        startLabel: formatDateLabel(start),
        endLabel: formatDateLabel(edu.endDate),
        startMachine: machineDate(start),
        endMachine: machineDate(edu.endDate),
        description: edu.description ?? null,
      };
    });

    const payload: CvRenderPayload = {
      cv: {
        id: cv.id,
        name: cv.name,
        candidateName: cv.candidateName ?? null,
        specialization: cv.specialization ?? null,
        titleOverride: cv.titleOverride ?? null,
        titleText,
        aboutText: cv.aboutText ?? null,
        aboutHtml: formatAboutHtml(cv.aboutText),
        availability: cv.availability ?? null,
        isDefault: cv.isDefault,
        style: styleId,
        pictureUrl: cv.pictureId ? `${baseUrl}/api/images/${cv.pictureId}` : null,
        pictureStyle:
          cv.pictureId && zoom && zoom !== 1
            ? `transform:scale(${zoom});`
            : null,
        displayName,
        initials,
      },
      profile,
      contacts,
      links,
      skills: { hard, soft },
      languages: (cv.languages || []).map((language) => ({
        name: language.name,
        level: language.level,
      })),
      passions: (cv.passions || []).map((passion): CvPayloadPassion => ({
        id: passion.id,
        name: passion.name,
        description: passion.description ?? null,
        icon: passion.icon ?? null,
        iconHref: iconHref(passion.icon, '#3B82F6'),
      })),
      experiences,
      projects,
      education,
    };

    return { payload, displayName };
  }

  private projectPoints(
    project: Project,
    bullets: Record<string, number[]> | null | undefined,
  ): ProjectPoint[] {
    const all = (project.projectPoints || [])
      .slice()
      .sort((a, b) => a.order - b.order);
    if (!bullets) return all;
    const selected = bullets[project.id];
    if (selected === undefined) return all;
    return all.filter((_, index) => selected.includes(index));
  }

  private cappedLongDescription(project: Project): string | null {
    const raw = (project.longDescription ?? project.description ?? '').trim();
    if (!raw) return null;
    if (raw.length <= 200) return raw;
    const cut = raw.slice(0, 200);
    const lastSpace = cut.lastIndexOf(' ');
    const boundary = lastSpace > 140 ? lastSpace : 200;
    return `${cut.slice(0, boundary).trimEnd()}…`;
  }

  private mainProjectLink(project: Project): { url: string; type?: string } | null {
    const all = (project.links || []).slice();
    if (!all.length) return null;
    const preferred = all.find(
      (l) => /demo|website|live/i.test(l.type ?? '') || /demo|website|live/i.test(l.label ?? ''),
    );
    return preferred ?? all[0];
  }
}
