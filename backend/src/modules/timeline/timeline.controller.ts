import { Controller, Get } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { TimelineService } from './timeline.service';
import { Public } from '../../common/decorators/public.decorator';

@ApiTags('Timeline')
@Controller('api/timeline')
export class TimelineController {
  constructor(private service: TimelineService) {}

  @Public()
  @Get()
  @ApiOperation({ summary: 'Get combined timeline of education and experience' })
  findAll() { return this.service.getTimeline(); }
}
