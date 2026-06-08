import { IsString, IsOptional, IsNumber } from 'class-validator';

export class CreateLanguageDto {
  @IsString()
  name: string;

  @IsString()
  level: string;

  @IsOptional()
  @IsNumber()
  order?: number;
}
