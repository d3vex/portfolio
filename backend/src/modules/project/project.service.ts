import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { Project } from './entities/project.entity';
import { Category } from '../category/entities/category.entity';
import { Skill } from '../skill/entities/skill.entity';
import { Link } from './entities/link.entity';
import { ProjectTimelineEntry } from './entities/project-timeline-entry.entity';
import { ProjectPoint } from './entities/project-point.entity';
import { ProjectTechnology } from './entities/project-technology.entity';
import { ProjectPointSkill } from './entities/project-point-skill.entity';
import { CreateProjectDto } from './dto/create-project.dto';
import { UpdateProjectDto } from './dto/update-project.dto';

interface PointInput {
  text: string;
  skillIds?: string[];
}

@Injectable()
export class ProjectService {
  constructor(
    @InjectRepository(Project) private repo: Repository<Project>,
    @InjectRepository(Category) private categoryRepo: Repository<Category>,
    @InjectRepository(Skill) private skillRepo: Repository<Skill>,
    @InjectRepository(Link) private linkRepo: Repository<Link>,
    @InjectRepository(ProjectTimelineEntry) private timelineRepo: Repository<ProjectTimelineEntry>,
    @InjectRepository(ProjectPoint) private projectPointRepo: Repository<ProjectPoint>,
    @InjectRepository(ProjectTechnology) private technologyRepo: Repository<ProjectTechnology>,
    @InjectRepository(ProjectPointSkill) private pointSkillRepo: Repository<ProjectPointSkill>,
  ) {}

  async findAll() {
    const projects = await this.repo.find({
      relations: {
        categories: true,
        education: true,
        image: true,
        links: true,
        timelineEntries: true,
        technologies: true,
        projectPoints: { skillLinks: { skill: true } },
      },
      order: { order: 'ASC' },
    });
    for (const p of projects) {
      p.timelineEntries?.sort((a, b) => b.date.localeCompare(a.date));
      p.projectPoints?.sort((a, b) => a.order - b.order);
    }
    return projects;
  }

  async findOne(id: string) {
    const entity = await this.repo.findOne({
      where: { id },
      relations: {
        categories: true,
        education: true,
        image: true,
        links: true,
        timelineEntries: true,
        technologies: true,
        projectPoints: { skillLinks: { skill: true } },
      },
    });
    if (!entity) throw new NotFoundException('Project not found');
    entity.timelineEntries?.sort((a, b) => b.date.localeCompare(a.date));
    entity.projectPoints?.sort((a, b) => a.order - b.order);
    return entity;
  }

  async create(dto: CreateProjectDto) {
    const { categoryIds, links, timeline, projectPoints, technologies, ...rest } = dto as any;
    const entity = this.repo.create(rest as any) as unknown as Project;
    if (categoryIds?.length) {
      entity.categories = await this.categoryRepo.findBy({ id: In(categoryIds) });
    }
    if (technologies?.length) {
      entity.technologies = this.technologyRows(technologies);
    }
    if (links?.length) {
      entity.links = links.map((l: any) => this.linkRepo.create(l));
    }
    if (timeline?.length) {
      entity.timelineEntries = timeline.map((t: any) => this.timelineRepo.create(t));
    }
    if (projectPoints?.length) {
      entity.projectPoints = this.pointRows(projectPoints);
    }
    return this.repo.save(entity);
  }

  async update(id: string, dto: UpdateProjectDto) {
    const entity = await this.findOne(id);
    const { categoryIds, links, timeline, projectPoints, technologies, ...rest } = dto as any;
    Object.assign(entity, rest);
    if (categoryIds !== undefined) {
      entity.categories = categoryIds.length ? await this.categoryRepo.findBy({ id: In(categoryIds) }) : [];
    }
    if (technologies !== undefined) {
      await this.technologyRepo.delete({ projectId: id });
      entity.technologies = this.technologyRows(technologies).map((t) =>
        this.technologyRepo.create({ ...t, projectId: id }),
      );
    }
    if (links !== undefined) {
      await this.linkRepo.delete({ projectId: id });
      entity.links = links.map((l: any) => this.linkRepo.create({ ...l, projectId: id }));
    }
    if (timeline !== undefined) {
      await this.timelineRepo.delete({ projectId: id });
      entity.timelineEntries = timeline.map((t: any) => this.timelineRepo.create({ ...t, projectId: id }));
    }
    if (projectPoints !== undefined) {
      await this.replaceProjectPoints(id, projectPoints);
      entity.projectPoints = await this.loadProjectPoints(id);
    }
    return this.repo.save(entity);
  }

  async remove(id: string) {
    const entity = await this.findOne(id);
    return this.repo.remove(entity);
  }

  private technologyRows(technologies: { name: string; icon?: string }[]): ProjectTechnology[] {
    return technologies.map((t) => this.technologyRepo.create({ name: t.name, icon: t.icon ?? null }));
  }

  private pointRows(points: PointInput[]): ProjectPoint[] {
    return points.map((p, i) => {
      const point = this.projectPointRepo.create({ text: p.text, order: i });
      point.skillLinks = (p.skillIds ?? []).map((skillId) =>
        this.pointSkillRepo.create({ skillId }),
      );
      return point;
    });
  }

  private async replaceProjectPoints(projectId: string, points: PointInput[]) {
    const existing = await this.projectPointRepo.find({ where: { projectId } });
    await this.projectPointRepo.remove(existing);
    const created: ProjectPoint[] = [];
    for (let i = 0; i < points.length; i++) {
      const p = points[i];
      const point = this.projectPointRepo.create({ text: p.text, order: i, projectId });
      point.skillLinks = (p.skillIds ?? []).map((skillId) =>
        this.pointSkillRepo.create({ skillId }),
      );
      created.push(await this.projectPointRepo.save(point));
    }
  }

  private async loadProjectPoints(projectId: string): Promise<ProjectPoint[]> {
    return this.projectPointRepo.find({
      where: { projectId },
      relations: { skillLinks: { skill: true } },
      order: { order: 'ASC' },
    });
  }
}
