import { IsOptional, IsString } from 'class-validator';

export class ExportCvDto {
  @IsOptional()
  @IsString()
  style?: string;

  @IsOptional()
  options?: Record<string, unknown>;
}
