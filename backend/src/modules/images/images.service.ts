import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Image } from './entities/image.entity';

@Injectable()
export class ImagesService {
  constructor(
    @InjectRepository(Image)
    private repo: Repository<Image>,
  ) {}

  async create(data: Buffer, mimeType: string, originalName?: string): Promise<Image> {
    const image = this.repo.create({ data, mimeType, originalName, size: data.length });
    return this.repo.save(image);
  }

  async findAll(): Promise<Image[]> {
    return this.repo.createQueryBuilder('image')
      .select(['image.id', 'image.mimeType', 'image.originalName', 'image.size', 'image.createdAt'])
      .orderBy('image.createdAt', 'DESC')
      .getMany();
  }

  async findOne(id: string): Promise<Image> {
    const image = await this.repo.findOne({ where: { id } });
    if (!image) throw new NotFoundException('Image not found');
    return image;
  }

  async remove(id: string): Promise<void> {
    const image = await this.findOne(id);
    await this.repo.remove(image);
  }
}
