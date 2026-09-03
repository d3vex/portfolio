import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ExperienceController } from './experience.controller';
import { ExperienceService } from './experience.service';
import { Experience } from './entities/experience.entity';
import { ExperiencePoint } from './entities/experience-point.entity';
import { ExperienceTag } from './entities/experience-tag.entity';
import { ExperiencePointSkill } from './entities/experience-point-skill.entity';
import { Link } from '../project/entities/link.entity';
import { Skill } from '../skill/entities/skill.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Experience, ExperiencePoint, ExperienceTag, ExperiencePointSkill, Link, Skill])],
  controllers: [ExperienceController],
  providers: [ExperienceService],
  exports: [ExperienceService],
})
export class ExperienceModule {}
