import {
  IsString,
  IsNotEmpty,
  IsOptional,
  IsArray,
  ValidateNested,
  IsIn,
  IsInt,
  Min,
  Max,
} from 'class-validator';
import { Type } from 'class-transformer';

export class ApplySkillItemDto {
  @IsString()
  @IsNotEmpty()
  name!: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsString()
  @IsIn(['hard', 'soft'])
  cvCategory!: string;

  @IsString()
  @IsNotEmpty()
  categoryName!: string;

  @IsInt()
  @Min(0)
  @Max(10)
  level!: number;

  @IsOptional()
  @IsString()
  suggestionId?: string;
}

export class ApplyBulletItemDto {
  @IsString()
  @IsIn(['project', 'experience'])
  entityType!: string;

  @IsString()
  @IsNotEmpty()
  entityId!: string;

  @IsString()
  @IsNotEmpty()
  text!: string;

  @IsArray()
  @IsString({ each: true })
  skillIds!: string[];

  @IsOptional()
  @IsString()
  suggestionId?: string;
}

export class ApplySuggestionsDto {
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => ApplySkillItemDto)
  skills?: ApplySkillItemDto[];

  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => ApplyBulletItemDto)
  bullets?: ApplyBulletItemDto[];
}
