import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Education } from './entities/education.entity';
import { EducationTag } from './entities/education-tag.entity';
import { CreateEducationDto } from './dto/create-education.dto';
import { UpdateEducationDto } from './dto/update-education.dto';

@Injectable()
export class EducationService {
  constructor(
    @InjectRepository(Education) private repo: Repository<Education>,
    @InjectRepository(EducationTag) private tagRepo: Repository<EducationTag>,
  ) {}

  findAll() {
    return this.repo.find({ relations: { projects: true, tags: true }, order: { order: 'ASC' } });
  }

  async findOne(id: string) {
    const entity = await this.repo.findOne({ where: { id }, relations: { projects: true, tags: true } });
    if (!entity) throw new NotFoundException('Education not found');
    return entity;
  }

  async create(dto: CreateEducationDto) {
    const { tags, ...rest } = dto as any;
    const entity = this.repo.create(rest) as unknown as Education;
    if (tags?.length) {
      entity.tags = tags.map((value: string) => this.tagRepo.create({ value }));
    }
    return this.repo.save(entity);
  }

  async update(id: string, dto: UpdateEducationDto) {
    const entity = await this.findOne(id);
    const { tags, ...rest } = dto as any;
    Object.assign(entity, rest);
    if (tags !== undefined) {
      await this.tagRepo.delete({ educationId: id });
      entity.tags = tags.map((value: string) => this.tagRepo.create({ value, educationId: id }));
    }
    return this.repo.save(entity);
  }

  async remove(id: string) {
    const entity = await this.findOne(id);
    return this.repo.remove(entity);
  }
}
