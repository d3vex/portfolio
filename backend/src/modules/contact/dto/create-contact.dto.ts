import { IsString, IsOptional, IsNumber } from 'class-validator';

export class CreateContactDto {
  @IsString()
  label: string;

  @IsString()
  value: string;

  @IsOptional()
  @IsString()
  icon?: string;

  @IsOptional()
  @IsString()
  type?: string;

  @IsOptional()
  @IsNumber()
  order?: number;
}
