import { Controller, Get, Post, Body, Param, Patch, Delete } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { CvService } from './cv.service';
import { CreateCvDto } from './dto/create-cv.dto';
import { UpdateCvDto } from './dto/update-cv.dto';
import { Public } from '../../common/decorators/public.decorator';

@ApiTags('CV')
@Controller('api/cv')
export class CvController {
  constructor(private service: CvService) {}

  @Public()
  @Get()
  @ApiOperation({ summary: 'Get all CVs' })
  findAll() { return this.service.findAll(); }

  @Public()
  @Get('stats')
  @ApiOperation({ summary: 'Get dashboard statistics' })
  getStats() { return this.service.getDashboardStats(); }

  @Public()
  @Get(':id')
  @ApiOperation({ summary: 'Get CV by id' })
  findOne(@Param('id') id: string) { return this.service.findOne(id); }

  @Public()
  @Post(':id/clone')
  @ApiOperation({ summary: 'Clone a CV' })
  clone(@Param('id') id: string) { return this.service.clone(id); }

  @Post()
  @ApiOperation({ summary: 'Create new CV' })
  create(@Body() dto: CreateCvDto) { return this.service.create(dto); }

  @Patch(':id')
  @ApiOperation({ summary: 'Update CV' })
  update(@Param('id') id: string, @Body() dto: UpdateCvDto) { return this.service.update(id, dto); }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete CV' })
  remove(@Param('id') id: string) { return this.service.remove(id); }
}
