import { IsString, IsOptional, IsArray, IsNumber } from 'class-validator';

export class CreateExperienceDto {
  @IsString()
  title: string;

  @IsString()
  company: string;

  @IsOptional()
  @IsString()
  companyUrl?: string;

  @IsOptional()
  @IsString()
  location?: string;

  @IsOptional()
  @IsString()
  startDate?: string;

  @IsOptional()
  @IsString()
  endDate?: string;

  @IsOptional()
  @IsArray()
  descriptions?: { text: string; skillIds?: string[] }[];

  @IsOptional()
  @IsArray()
  skillIds?: string[];

  @IsOptional()
  @IsArray()
  links?: { label: string; url: string; icon?: string; type?: string }[];

  @IsOptional()
  @IsString()
  imageId?: string;

  @IsOptional()
  @IsNumber()
  order?: number;
}
