import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CvController } from './cv.controller';
import { CvService } from './cv.service';
import { Cv } from './entities/cv.entity';
import { CvSkill } from './entities/cv-skill.entity';
import { CvProject } from './entities/cv-project.entity';
import { CvPassion } from './entities/cv-passion.entity';
import { CvProjectPoint } from './entities/cv-project-point.entity';
import { Skill } from '../skill/entities/skill.entity';
import { Project } from '../project/entities/project.entity';
import { Experience } from '../experience/entities/experience.entity';
import { Education } from '../education/entities/education.entity';
import { Language } from '../language/entities/language.entity';
import { Passion } from '../passion/entities/passion.entity';
import { Contact } from '../contact/entities/contact.entity';
import { Category } from '../category/entities/category.entity';
import { ProjectPoint } from '../project/entities/project-point.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Cv, CvSkill, CvProject, CvPassion, CvProjectPoint, Skill, Project, Experience, Education, Language, Passion, Contact, Category, ProjectPoint])],
  controllers: [CvController],
  providers: [CvService],
  exports: [CvService],
})
export class CvModule {}
