import { IsString, IsOptional, IsArray, IsBoolean } from 'class-validator';

export class CreateCvDto {
  @IsString()
  name: string;

  @IsOptional()
  @IsString()
  candidateName?: string;

  @IsOptional()
  @IsString()
  specialization?: string;

  @IsOptional()
  @IsString()
  titleOverride?: string;

  @IsOptional()
  @IsString()
  aboutText?: string;

  @IsOptional()
  @IsArray()
  skillIds?: string[];

  @IsOptional()
  @IsArray()
  languageIds?: string[];

  @IsOptional()
  @IsArray()
  passionIds?: string[];

  @IsOptional()
  @IsArray()
  experienceIds?: string[];

  @IsOptional()
  @IsArray()
  projectIds?: string[];

  @IsOptional()
  @IsArray()
  educationIds?: string[];

  @IsOptional()
  @IsArray()
  contactIds?: string[];

  @IsOptional()
  @IsArray()
  cvProjectPointIds?: string[];

  @IsOptional()
  @IsString()
  pictureId?: string;

  @IsOptional()
  @IsString()
  availability?: string;

  @IsOptional()
  @IsBoolean()
  isDefault?: boolean;

  @IsOptional()
  @IsString()
  style?: string;
}
