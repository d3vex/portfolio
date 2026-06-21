import { IsString, IsOptional, IsNumber, IsArray, Min, Max } from 'class-validator';

export class CreateSkillDto {
  @IsString()
  name: string;

  @IsOptional()
  @IsString()
  icon?: string;

  @IsOptional()
  @IsString()
  categoryId?: string;

  @IsOptional()
  @IsString()
  cvCategory?: 'hard' | 'soft';

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsArray()
  keywords?: string[];

  @IsOptional()
  @IsNumber()
  @Min(0)
  @Max(100)
  level?: number;

  @IsOptional()
  @IsNumber()
  order?: number;
}
