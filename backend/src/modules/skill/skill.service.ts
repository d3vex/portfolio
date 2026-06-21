import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Skill } from './entities/skill.entity';
import { CreateSkillDto } from './dto/create-skill.dto';
import { UpdateSkillDto } from './dto/update-skill.dto';

@Injectable()
export class SkillService {
  constructor(@InjectRepository(Skill) private repo: Repository<Skill>) {}

  findAll() {
    return this.repo.find({ relations: { category: true }, order: { order: 'ASC' } });
  }

  async findOne(id: string) {
    const entity = await this.repo.findOne({ where: { id }, relations: { category: true } });
    if (!entity) throw new NotFoundException('Skill not found');
    return entity;
  }

  create(dto: CreateSkillDto) { return this.repo.save(this.repo.create(dto)); }

  async update(id: string, dto: UpdateSkillDto) {
    const entity = await this.findOne(id);
    Object.assign(entity, dto);
    return this.repo.save(entity);
  }

  async remove(id: string) {
    const entity = await this.findOne(id);
    return this.repo.remove(entity);
  }
}
