import { Controller, Get, Post, Body, Param, Patch, Delete } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { ExperienceService } from './experience.service';
import { CreateExperienceDto } from './dto/create-experience.dto';
import { UpdateExperienceDto } from './dto/update-experience.dto';
import { Public } from '../../common/decorators/public.decorator';

@ApiTags('Experiences')
@Controller('api/experiences')
export class ExperienceController {
  constructor(private service: ExperienceService) {}

  @Public()
  @Get()
  @ApiOperation({ summary: 'Get all experiences' })
  findAll() { return this.service.findAll(); }

  @Public()
  @Get(':id')
  @ApiOperation({ summary: 'Get experience by id' })
  findOne(@Param('id') id: string) { return this.service.findOne(id); }

  @Post()
  @ApiOperation({ summary: 'Create experience' })
  create(@Body() dto: CreateExperienceDto) { return this.service.create(dto); }

  @Patch(':id')
  @ApiOperation({ summary: 'Update experience' })
  update(@Param('id') id: string, @Body() dto: UpdateExperienceDto) { return this.service.update(id, dto); }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete experience' })
  remove(@Param('id') id: string) { return this.service.remove(id); }
}
