import { Controller, Get, Post, Body, Param, Patch, Delete } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { SkillService } from './skill.service';
import { CreateSkillDto } from './dto/create-skill.dto';
import { UpdateSkillDto } from './dto/update-skill.dto';
import { Public } from '../../common/decorators/public.decorator';

@ApiTags('Skills')
@Controller('api/skills')
export class SkillController {
  constructor(private service: SkillService) {}

  @Public()
  @Get()
  @ApiOperation({ summary: 'Get all skills' })
  findAll() { return this.service.findAll(); }

  @Public()
  @Get(':id')
  @ApiOperation({ summary: 'Get skill by id' })
  findOne(@Param('id') id: string) { return this.service.findOne(id); }

  @Post()
  @ApiOperation({ summary: 'Create skill' })
  create(@Body() dto: CreateSkillDto) { return this.service.create(dto); }

  @Patch(':id')
  @ApiOperation({ summary: 'Update skill' })
  update(@Param('id') id: string, @Body() dto: UpdateSkillDto) { return this.service.update(id, dto); }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete skill' })
  remove(@Param('id') id: string) { return this.service.remove(id); }
}
