import { Controller, Get, Post, Body, Param, Patch, Delete, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { ContactService } from './contact.service';
import { CreateContactDto } from './dto/create-contact.dto';
import { UpdateContactDto } from './dto/update-contact.dto';
import { Public } from '../../common/decorators/public.decorator';
import { OptionalAuthGuard } from '../../common/guards/optional-auth.guard';
import { CurrentUserOptionnal } from '../../common/decorators/current-user.decorator';
import { User } from '../auth/entities/user.entity';

@ApiTags('Contact')
@Controller('api/contact')
export class ContactController {
  constructor(private service: ContactService) {}

  @Public()
  @UseGuards(OptionalAuthGuard)
  @Get()
  @ApiOperation({ summary: 'Get all contacts' })
  findAll(@CurrentUserOptionnal() user: User | null) {
    return this.service.findAll(user != null);
  }

  @Public()
  @Get(':id')
  @ApiOperation({ summary: 'Get contact by id' })
  findOne(@Param('id') id: string) { return this.service.findOne(id); }

  @Post()
  @ApiOperation({ summary: 'Create contact' })
  create(@Body() dto: CreateContactDto) { return this.service.create(dto); }

  @Patch(':id')
  @ApiOperation({ summary: 'Update contact' })
  update(@Param('id') id: string, @Body() dto: UpdateContactDto) { return this.service.update(id, dto); }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete contact' })
  remove(@Param('id') id: string) { return this.service.remove(id); }
}
