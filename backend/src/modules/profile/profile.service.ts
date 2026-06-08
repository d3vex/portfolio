import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Profile } from './entities/profile.entity';
import { CreateProfileDto } from './dto/create-profile.dto';
import { UpdateProfileDto } from './dto/update-profile.dto';

@Injectable()
export class ProfileService {
  constructor(
    @InjectRepository(Profile)
    private repo: Repository<Profile>,
  ) {}

  findAll() {
    return this.repo.find();
  }

  async findOne(id: string) {
    const profile = await this.repo.findOne({ where: { id } });
    if (!profile) throw new NotFoundException('Profile not found');
    return profile;
  }

  create(dto: CreateProfileDto) {
    const profile = this.repo.create(dto);
    return this.repo.save(profile);
  }

  async update(id: string, dto: UpdateProfileDto) {
    const profile = await this.findOne(id);
    Object.assign(profile, dto);
    return this.repo.save(profile);
  }

  async remove(id: string) {
    const profile = await this.findOne(id);
    return this.repo.remove(profile);
  }
}
