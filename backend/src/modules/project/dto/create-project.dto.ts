import { IsString, IsOptional, IsArray, IsNumber, IsBoolean, IsEnum } from 'class-validator';
import { ProjectStatus } from '../entities/project.entity';

export class CreateProjectDto {
  @IsString()
  title: string;

  @IsOptional()
  @IsString()
  subtitle?: string;

  @IsOptional()
  @IsString()
  url?: string;

  @IsOptional()
  @IsString()
  startDate?: string;

  @IsOptional()
  @IsString()
  endDate?: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsString()
  longDescription?: string;

  @IsOptional()
  @IsArray()
  descriptions?: { text: string; skillIds?: string[] }[];

  @IsOptional()
  @IsArray()
  technologies?: { name: string; icon?: string }[];

  @IsOptional()
  @IsArray()
  categoryIds?: string[];

  @IsOptional()
  @IsArray()
  skillIds?: string[];

  @IsOptional()
  @IsEnum(ProjectStatus)
  status?: ProjectStatus;

  @IsOptional()
  @IsBoolean()
  featured?: boolean;

  @IsOptional()
  @IsString()
  imageUrl?: string;

  @IsOptional()
  @IsString()
  imageId?: string;

  @IsOptional()
  @IsString()
  liveUrl?: string;

  @IsOptional()
  @IsString()
  sourceUrl?: string;

  @IsOptional()
  @IsArray()
  links?: { label: string; url: string; icon?: string; type?: string }[];

  @IsOptional()
  @IsArray()
  timeline?: { date: string; title: string; description: string; status: string; imageUrl?: string }[];

  @IsOptional()
  @IsString()
  educationId?: string;

  @IsOptional()
  @IsNumber()
  order?: number;
}
