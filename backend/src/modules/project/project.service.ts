import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { Project } from './entities/project.entity';
import { Category } from '../category/entities/category.entity';
import { Skill } from '../skill/entities/skill.entity';
import { Link } from './entities/link.entity';
import { ProjectTimelineEntry } from './entities/project-timeline-entry.entity';
import { ProjectPoint } from './entities/project-point.entity';
import { CreateProjectDto } from './dto/create-project.dto';
import { UpdateProjectDto } from './dto/update-project.dto';

@Injectable()
export class ProjectService {
  constructor(
    @InjectRepository(Project) private repo: Repository<Project>,
    @InjectRepository(Category) private categoryRepo: Repository<Category>,
    @InjectRepository(Skill) private skillRepo: Repository<Skill>,
    @InjectRepository(Link) private linkRepo: Repository<Link>,
    @InjectRepository(ProjectTimelineEntry) private timelineRepo: Repository<ProjectTimelineEntry>,
    @InjectRepository(ProjectPoint) private projectPointRepo: Repository<ProjectPoint>,
  ) {}

  async findAll() {
    const projects = await this.repo.find({
      relations: { categories: true, skills: true, education: true, image: true, links: true, timelineEntries: true, projectPoints: true },
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
      relations: { categories: true, skills: true, education: true, image: true, links: true, timelineEntries: true, projectPoints: true },
    });
    if (!entity) throw new NotFoundException('Project not found');
    entity.timelineEntries?.sort((a, b) => b.date.localeCompare(a.date));
    entity.projectPoints?.sort((a, b) => a.order - b.order);
    return entity;
  }

  async create(dto: CreateProjectDto) {
    const { skillIds, categoryIds, links, timeline, projectPoints, ...rest } = dto as any;
    const entity = this.repo.create(rest as any) as unknown as Project;
    if (categoryIds?.length) {
      entity.categories = await this.categoryRepo.findBy({ id: In(categoryIds) });
    }
    if (skillIds?.length) {
      entity.skills = await this.skillRepo.findBy({ id: In(skillIds) });
    }
    if (links?.length) {
      entity.links = links.map((l: any) => this.linkRepo.create(l));
    }
    if (timeline?.length) {
      entity.timelineEntries = timeline.map((t: any) => this.timelineRepo.create(t));
    }
    if (projectPoints?.length) {
      entity.projectPoints = projectPoints.map((p: any) => this.projectPointRepo.create(p));
    }
    return this.repo.save(entity);
  }

  async update(id: string, dto: UpdateProjectDto) {
    const entity = await this.findOne(id);
    const { skillIds, categoryIds, links, timeline, projectPoints, ...rest } = dto as any;
    Object.assign(entity, rest);
    if (categoryIds !== undefined) {
      entity.categories = categoryIds.length ? await this.categoryRepo.findBy({ id: In(categoryIds) }) : [];
    }
    if (skillIds !== undefined) {
      entity.skills = skillIds.length ? await this.skillRepo.findBy({ id: In(skillIds) }) : [];
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
      await this.projectPointRepo.delete({ projectId: id });
      entity.projectPoints = projectPoints.map((p: any) => this.projectPointRepo.create({ ...p, projectId: id }));
    }
    return this.repo.save(entity);
  }

  async remove(id: string) {
    const entity = await this.findOne(id);
    return this.repo.remove(entity);
  }
}
