import { Controller, Get, Post, Body, Param, Patch, Delete } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { LanguageService } from './language.service';
import { CreateLanguageDto } from './dto/create-language.dto';
import { UpdateLanguageDto } from './dto/update-language.dto';
import { Public } from '../../common/decorators/public.decorator';

@ApiTags('Languages')
@Controller('api/languages')
export class LanguageController {
  constructor(private service: LanguageService) {}

  @Public()
  @Get()
  @ApiOperation({ summary: 'Get all languages' })
  findAll() { return this.service.findAll(); }

  @Public()
  @Get(':id')
  @ApiOperation({ summary: 'Get language by id' })
  findOne(@Param('id') id: string) { return this.service.findOne(id); }

  @Post()
  @ApiOperation({ summary: 'Create language' })
  create(@Body() dto: CreateLanguageDto) { return this.service.create(dto); }

  @Patch(':id')
  @ApiOperation({ summary: 'Update language' })
  update(@Param('id') id: string, @Body() dto: UpdateLanguageDto) { return this.service.update(id, dto); }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete language' })
  remove(@Param('id') id: string) { return this.service.remove(id); }
}
