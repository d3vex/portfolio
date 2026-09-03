import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Experience } from './entities/experience.entity';
import { ExperiencePoint } from './entities/experience-point.entity';
import { ExperienceTag } from './entities/experience-tag.entity';
import { ExperiencePointSkill } from './entities/experience-point-skill.entity';
import { Link } from '../project/entities/link.entity';
import { Skill } from '../skill/entities/skill.entity';
import { CreateExperienceDto } from './dto/create-experience.dto';
import { UpdateExperienceDto } from './dto/update-experience.dto';

interface PointInput {
  text: string;
  skillIds?: string[];
}

@Injectable()
export class ExperienceService {
  constructor(
    @InjectRepository(Experience) private repo: Repository<Experience>,
    @InjectRepository(ExperiencePoint) private experiencePointRepo: Repository<ExperiencePoint>,
    @InjectRepository(ExperienceTag) private tagRepo: Repository<ExperienceTag>,
    @InjectRepository(ExperiencePointSkill) private pointSkillRepo: Repository<ExperiencePointSkill>,
    @InjectRepository(Link) private linkRepo: Repository<Link>,
    @InjectRepository(Skill) private skillRepo: Repository<Skill>,
  ) {}

  findAll() {
    return this.repo.find({
      relations: {
        image: true,
        links: true,
        tags: true,
        experiencePoints: { skillLinks: { skill: true } },
      },
      order: { order: 'ASC' },
    });
  }

  async findOne(id: string) {
    const entity = await this.repo.findOne({
      where: { id },
      relations: {
        image: true,
        links: true,
        tags: true,
        experiencePoints: { skillLinks: { skill: true } },
      },
    });
    if (!entity) throw new NotFoundException('Experience not found');
    entity.experiencePoints?.sort((a, b) => a.order - b.order);
    return entity;
  }

  async create(dto: CreateExperienceDto) {
    const { links, experiencePoints, tags, ...rest } = dto as any;
    const entity = this.repo.create(rest as any) as unknown as Experience;
    if (tags?.length) {
      entity.tags = tags.map((value: string) => this.tagRepo.create({ value }));
    }
    if (links?.length) {
      entity.links = links.map((l: any) => this.linkRepo.create(l));
    }
    if (experiencePoints?.length) {
      entity.experiencePoints = this.pointRows(experiencePoints);
    }
    return this.repo.save(entity);
  }

  async update(id: string, dto: UpdateExperienceDto) {
    const entity = await this.findOne(id);
    const { links, experiencePoints, tags, ...rest } = dto as any;
    Object.assign(entity, rest);
    if (tags !== undefined) {
      await this.tagRepo.delete({ experienceId: id });
      entity.tags = tags.map((value: string) => this.tagRepo.create({ value, experienceId: id }));
    }
    if (links !== undefined) {
      await this.linkRepo.delete({ experienceId: id });
      entity.links = links.map((l: any) => this.linkRepo.create({ ...l, experienceId: id }));
    }
    if (experiencePoints !== undefined) {
      await this.replaceExperiencePoints(id, experiencePoints);
      entity.experiencePoints = await this.loadExperiencePoints(id);
    }
    return this.repo.save(entity);
  }

  async remove(id: string) {
    const entity = await this.findOne(id);
    return this.repo.remove(entity);
  }

  private pointRows(points: PointInput[]): ExperiencePoint[] {
    return points.map((p, i) => {
      const point = this.experiencePointRepo.create({ text: p.text, order: i });
      point.skillLinks = (p.skillIds ?? []).map((skillId) =>
        this.pointSkillRepo.create({ skillId }),
      );
      return point;
    });
  }

  private async replaceExperiencePoints(experienceId: string, points: PointInput[]) {
    const existing = await this.experiencePointRepo.find({ where: { experienceId } });
    await this.experiencePointRepo.remove(existing);
    for (let i = 0; i < points.length; i++) {
      const p = points[i];
      const point = this.experiencePointRepo.create({ text: p.text, order: i, experienceId });
      point.skillLinks = (p.skillIds ?? []).map((skillId) =>
        this.pointSkillRepo.create({ skillId }),
      );
      await this.experiencePointRepo.save(point);
    }
  }

  private async loadExperiencePoints(experienceId: string): Promise<ExperiencePoint[]> {
    return this.experiencePointRepo.find({
      where: { experienceId },
      relations: { skillLinks: { skill: true } },
      order: { order: 'ASC' },
    });
  }
}
