import { ParseBoolPipe } from '@nestjs/common';
import { Transform } from 'class-transformer';
import { IsString, IsOptional, IsNumber, IsBoolean } from 'class-validator';

function parseBoolean(input) {
  if(typeof input.value == "boolean") return input
  if(typeof input.value == "string") input.value = input.value == "true" ? true:false
  return input
}

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
  @IsBoolean()
  isPrivate?: boolean;

  @IsOptional()
  @IsNumber()
  order?: number;
}
