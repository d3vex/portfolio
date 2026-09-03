import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Skill } from './entities/skill.entity';
import { SkillKeyword } from './entities/skill-keyword.entity';
import { CreateSkillDto } from './dto/create-skill.dto';
import { UpdateSkillDto } from './dto/update-skill.dto';

@Injectable()
export class SkillService {
  constructor(
    @InjectRepository(Skill) private repo: Repository<Skill>,
    @InjectRepository(SkillKeyword) private keywordRepo: Repository<SkillKeyword>,
  ) {}

  findAll() {
    return this.repo.find({ relations: { category: true, keywords: true }, order: { order: 'ASC' } });
  }

  async findOne(id: string) {
    const entity = await this.repo.findOne({ where: { id }, relations: { category: true, keywords: true } });
    if (!entity) throw new NotFoundException('Skill not found');
    return entity;
  }

  async create(dto: CreateSkillDto) {
    const { keywords, ...rest } = dto;
    const entity = this.repo.create(rest) as unknown as Skill;
    if (keywords?.length) {
      entity.keywords = keywords.map((value) => this.keywordRepo.create({ value }));
    }
    return this.repo.save(entity);
  }

  async update(id: string, dto: UpdateSkillDto) {
    const entity = await this.findOne(id);
    const { keywords, ...rest } = dto;
    Object.assign(entity, rest);
    if (keywords !== undefined) {
      await this.keywordRepo.delete({ skillId: id });
      entity.keywords = keywords.map((value) => this.keywordRepo.create({ value, skillId: id }));
    }
    return this.repo.save(entity);
  }

  async remove(id: string) {
    const entity = await this.findOne(id);
    return this.repo.remove(entity);
  }
}
