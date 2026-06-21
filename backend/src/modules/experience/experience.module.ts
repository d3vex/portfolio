import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ExperienceController } from './experience.controller';
import { ExperienceService } from './experience.service';
import { Experience } from './entities/experience.entity';
import { ExperiencePoint } from './entities/experience-point.entity';
import { Link } from '../project/entities/link.entity';
import { Skill } from '../skill/entities/skill.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Experience, ExperiencePoint, Link, Skill])],
  controllers: [ExperienceController],
  providers: [ExperienceService],
})
export class ExperienceModule {}
