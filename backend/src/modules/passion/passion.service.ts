import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Passion } from './entities/passion.entity';
import { CreatePassionDto } from './dto/create-passion.dto';
import { UpdatePassionDto } from './dto/update-passion.dto';

@Injectable()
export class PassionService {
  constructor(@InjectRepository(Passion) private repo: Repository<Passion>) {}

  findAll() { return this.repo.find({ order: { order: 'ASC' } }); }

  async findOne(id: string) {
    const entity = await this.repo.findOne({ where: { id } });
    if (!entity) throw new NotFoundException('Passion not found');
    return entity;
  }

  create(dto: CreatePassionDto) { return this.repo.save(this.repo.create(dto)); }

  async update(id: string, dto: UpdatePassionDto) {
    const entity = await this.findOne(id);
    Object.assign(entity, dto);
    return this.repo.save(entity);
  }

  async remove(id: string) {
    const entity = await this.findOne(id);
    return this.repo.remove(entity);
  }
}
