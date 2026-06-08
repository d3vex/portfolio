import { Controller, Get, Post, Body, Param, Patch, Delete } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { PassionService } from './passion.service';
import { CreatePassionDto } from './dto/create-passion.dto';
import { UpdatePassionDto } from './dto/update-passion.dto';
import { Public } from '../../common/decorators/public.decorator';

@ApiTags('Passions')
@Controller('api/passions')
export class PassionController {
  constructor(private service: PassionService) {}

  @Public()
  @Get()
  @ApiOperation({ summary: 'Get all passions' })
  findAll() { return this.service.findAll(); }

  @Public()
  @Get(':id')
  @ApiOperation({ summary: 'Get passion by id' })
  findOne(@Param('id') id: string) { return this.service.findOne(id); }

  @Post()
  @ApiOperation({ summary: 'Create passion' })
  create(@Body() dto: CreatePassionDto) { return this.service.create(dto); }

  @Patch(':id')
  @ApiOperation({ summary: 'Update passion' })
  update(@Param('id') id: string, @Body() dto: UpdatePassionDto) { return this.service.update(id, dto); }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete passion' })
  remove(@Param('id') id: string) { return this.service.remove(id); }
}
