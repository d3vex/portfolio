import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TimelineController } from './timeline.controller';
import { TimelineService } from './timeline.service';
import { Experience } from '../experience/entities/experience.entity';
import { Education } from '../education/entities/education.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Experience, Education])],
  controllers: [TimelineController],
  providers: [TimelineService],
})
export class TimelineModule {}
