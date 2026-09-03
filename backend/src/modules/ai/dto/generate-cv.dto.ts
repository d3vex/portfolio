import {
  IsString,
  IsNotEmpty,
  IsOptional,
  ValidateNested,
  IsIn,
  IsBoolean,
  IsInt,
  Min,
  Max,
} from 'class-validator';
import { Type } from 'class-transformer';

export class GenerateCvOptionsDto {
  @IsOptional()
  @IsIn(['auto', 'webdev', 'appdev', 'devops', 'itsupport'])
  specialization?: string;

  @IsOptional()
  @IsIn(['auto', 'classic', 'ats', 'two-column-blue'])
  style?: string;

  @IsOptional()
  @IsIn(['short', 'medium', 'long'])
  aboutLength?: string;

  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(10)
  maxExperiences?: number;

  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(10)
  maxProjects?: number;

  @IsOptional()
  @IsBoolean()
  includeSoftSkills?: boolean;

  @IsOptional()
  @IsBoolean()
  includeLanguages?: boolean;

  @IsOptional()
  @IsIn(['professional', 'enthusiastic', 'technical'])
  tone?: string;

  @IsOptional()
  @IsBoolean()
  allowSkillSuggestions?: boolean;

  @IsOptional()
  @IsBoolean()
  allowBulletSuggestions?: boolean;

  @IsOptional()
  @IsString()
  customInstructions?: string;
}

export class GenerateCvDto {
  @IsString()
  @IsNotEmpty()
  jobDescription!: string;

  @IsOptional()
  @ValidateNested()
  @Type(() => GenerateCvOptionsDto)
  options?: GenerateCvOptionsDto;
}
