import { Controller, Get, Post, Body, Param, Patch, Delete } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { ProfileService } from './profile.service';
import { CreateProfileDto } from './dto/create-profile.dto';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { Public } from '../../common/decorators/public.decorator';

@ApiTags('Profile')
@Controller('api/profile')
export class ProfileController {
  constructor(private service: ProfileService) {}

  @Public()
  @Get()
  @ApiOperation({ summary: 'Get all profiles' })
  findAll() { return this.service.findAll(); }

  @Public()
  @Get(':id')
  @ApiOperation({ summary: 'Get profile by id' })
  findOne(@Param('id') id: string) { return this.service.findOne(id); }

  @Post()
  @ApiOperation({ summary: 'Create profile' })
  create(@Body() dto: CreateProfileDto) { return this.service.create(dto); }

  @Patch(':id')
  @ApiOperation({ summary: 'Update profile' })
  update(@Param('id') id: string, @Body() dto: UpdateProfileDto) { return this.service.update(id, dto); }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete profile' })
  remove(@Param('id') id: string) { return this.service.remove(id); }
}
