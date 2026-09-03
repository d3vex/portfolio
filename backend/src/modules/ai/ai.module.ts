import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AiController } from './ai.controller';
import { AiService } from './ai.service';

import { Profile } from '../profile/entities/profile.entity';
import { Skill } from '../skill/entities/skill.entity';
import { Category } from '../category/entities/category.entity';
import { Experience } from '../experience/entities/experience.entity';
import { ExperiencePoint } from '../experience/entities/experience-point.entity';
import { ExperiencePointSkill } from '../experience/entities/experience-point-skill.entity';
import { Project } from '../project/entities/project.entity';
import { ProjectPoint } from '../project/entities/project-point.entity';
import { ProjectPointSkill } from '../project/entities/project-point-skill.entity';
import { Education } from '../education/entities/education.entity';
import { Language } from '../language/entities/language.entity';
import { Passion } from '../passion/entities/passion.entity';
import { Contact } from '../contact/entities/contact.entity';
import { User } from '../auth/entities/user.entity';
import { Image } from '../images/entities/image.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Profile,
      Skill,
      Category,
      Experience,
      ExperiencePoint,
      ExperiencePointSkill,
      Project,
      ProjectPoint,
      ProjectPointSkill,
      Education,
      Language,
      Passion,
      Contact,
      User,
      Image,
    ]),
  ],
  controllers: [AiController],
  providers: [AiService],
  exports: [AiService],
})
export class AiModule {}
