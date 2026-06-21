import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { Experience } from './entities/experience.entity';
import { ExperiencePoint } from './entities/experience-point.entity';
import { Skill } from '../skill/entities/skill.entity';
import { Link } from '../project/entities/link.entity';
import { CreateExperienceDto } from './dto/create-experience.dto';
import { UpdateExperienceDto } from './dto/update-experience.dto';

@Injectable()
export class ExperienceService {
  constructor(
    @InjectRepository(Experience) private repo: Repository<Experience>,
    @InjectRepository(ExperiencePoint) private experiencePointRepo: Repository<ExperiencePoint>,
    @InjectRepository(Skill) private skillRepo: Repository<Skill>,
    @InjectRepository(Link) private linkRepo: Repository<Link>,
  ) {}

  findAll() {
    return this.repo.find({ relations: { skills: true, image: true, links: true, experiencePoints: true }, order: { order: 'ASC' } });
  }

  async findOne(id: string) {
    const entity = await this.repo.findOne({ where: { id }, relations: { skills: true, image: true, links: true, experiencePoints: true } });
    if (!entity) throw new NotFoundException('Experience not found');
    entity.experiencePoints?.sort((a, b) => a.order - b.order);
    return entity;
  }

  async create(dto: CreateExperienceDto) {
    const { skillIds, links, experiencePoints, ...rest } = dto as any;
    const entity = this.repo.create(rest as any) as unknown as Experience;
    if (skillIds?.length) {
      entity.skills = await this.skillRepo.findBy({ id: In(skillIds) });
    }
    if (links?.length) {
      entity.links = links.map((l: any) => this.linkRepo.create(l));
    }
    if (experiencePoints?.length) {
      entity.experiencePoints = experiencePoints.map((p: any) => this.experiencePointRepo.create(p));
    }
    return this.repo.save(entity);
  }

  async update(id: string, dto: UpdateExperienceDto) {
    const entity = await this.findOne(id);
    const { skillIds, links, experiencePoints, ...rest } = dto as any;
    Object.assign(entity, rest);
    if (skillIds !== undefined) {
      entity.skills = skillIds.length ? await this.skillRepo.findBy({ id: In(skillIds) }) : [];
    }
    if (links !== undefined) {
      await this.linkRepo.delete({ experienceId: id });
      entity.links = links.map((l: any) => this.linkRepo.create({ ...l, experienceId: id }));
    }
    if (experiencePoints !== undefined) {
      await this.experiencePointRepo.delete({ experienceId: id });
      entity.experiencePoints = experiencePoints.map((p: any) => this.experiencePointRepo.create({ ...p, experienceId: id }));
    }
    return this.repo.save(entity);
  }

  async remove(id: string) {
    const entity = await this.findOne(id);
    return this.repo.remove(entity);
  }
}
