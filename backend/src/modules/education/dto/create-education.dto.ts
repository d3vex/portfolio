import { IsString, IsOptional, IsNumber, IsArray } from 'class-validator';

export class CreateEducationDto {
  @IsString()
  title: string;

  @IsOptional()
  @IsString()
  school?: string;

  @IsOptional()
  @IsString()
  startDate?: string;

  @IsOptional()
  @IsString()
  endDate?: string;

  @IsOptional()
  @IsString()
  date?: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsArray()
  descriptions?: string[];

  @IsOptional()
  @IsArray()
  tags?: string[];

  @IsOptional()
  @IsNumber()
  order?: number;
}
