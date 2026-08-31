import { IsNumber, IsOptional, IsString, Max, Min } from 'class-validator';
import { Type } from 'class-transformer';

export class ExportCvDto {
  @IsOptional()
  @IsString()
  style?: string;

  @IsOptional()
  @IsNumber()
  @Min(0.5)
  @Max(2)
  @Type(() => Number)
  zoom?: number;

  @IsOptional()
  options?: Record<string, unknown>;
}
