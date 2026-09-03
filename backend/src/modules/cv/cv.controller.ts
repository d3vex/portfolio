import { Controller, Get, Post, Body, Param, Patch, Delete } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { CvService, CurrentUserLike } from './cv.service';
import { CreateCvDto } from './dto/create-cv.dto';
import { UpdateCvDto } from './dto/update-cv.dto';
import { CurrentUserOptionnal } from '../../common/decorators/current-user.decorator';

@ApiTags('CV')
@Controller('api/cv')
export class CvController {
  constructor(private service: CvService) {}

  @Get()
  @ApiOperation({ summary: 'Get all CVs' })
  findAll() { return this.service.findAll(); }

  @Get('stats')
  @ApiOperation({ summary: 'Get dashboard statistics' })
  getStats() { return this.service.getDashboardStats(); }

  @Get(':id')
  @ApiOperation({ summary: 'Get CV by id' })
  findOne(@Param('id') id: string) { return this.service.findOne(id); }

  @Post(':id/clone')
  @ApiOperation({ summary: 'Clone a CV' })
  clone(@Param('id') id: string) { return this.service.clone(id); }

  @Post()
  @ApiOperation({ summary: 'Create new CV' })
  create(@Body() dto: CreateCvDto, @CurrentUserOptionnal() user?: CurrentUserLike) { return this.service.create(dto, user); }

  @Patch(':id')
  @ApiOperation({ summary: 'Update CV' })
  update(@Param('id') id: string, @Body() dto: UpdateCvDto) { return this.service.update(id, dto); }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete CV' })
  remove(@Param('id') id: string, @CurrentUserOptionnal() user?: CurrentUserLike) { return this.service.remove(id, user?.role); }
}
