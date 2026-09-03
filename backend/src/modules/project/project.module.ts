import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProjectController } from './project.controller';
import { ProjectService } from './project.service';
import { Project } from './entities/project.entity';
import { Link } from './entities/link.entity';
import { ProjectTimelineEntry } from './entities/project-timeline-entry.entity';
import { ProjectPoint } from './entities/project-point.entity';
import { ProjectTechnology } from './entities/project-technology.entity';
import { ProjectPointSkill } from './entities/project-point-skill.entity';
import { Category } from '../category/entities/category.entity';
import { Skill } from '../skill/entities/skill.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Project, Link, ProjectTimelineEntry, ProjectPoint, ProjectTechnology, ProjectPointSkill, Category, Skill])],
  controllers: [ProjectController],
  providers: [ProjectService],
  exports: [ProjectService],
})
export class ProjectModule {}
