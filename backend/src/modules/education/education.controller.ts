import { Controller, Get, Post, Body, Param, Patch, Delete } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { EducationService } from './education.service';
import { CreateEducationDto } from './dto/create-education.dto';
import { UpdateEducationDto } from './dto/update-education.dto';
import { Public } from '../../common/decorators/public.decorator';

@ApiTags('Education')
@Controller('api/education')
export class EducationController {
  constructor(private service: EducationService) {}

  @Public()
  @Get()
  @ApiOperation({ summary: 'Get all education entries' })
  findAll() { return this.service.findAll(); }

  @Public()
  @Get(':id')
  @ApiOperation({ summary: 'Get education by id' })
  findOne(@Param('id') id: string) { return this.service.findOne(id); }

  @Post()
  @ApiOperation({ summary: 'Create education' })
  create(@Body() dto: CreateEducationDto) { return this.service.create(dto); }

  @Patch(':id')
  @ApiOperation({ summary: 'Update education' })
  update(@Param('id') id: string, @Body() dto: UpdateEducationDto) { return this.service.update(id, dto); }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete education' })
  remove(@Param('id') id: string) { return this.service.remove(id); }
}
