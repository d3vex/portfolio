import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from './modules/auth/auth.module';
import { ProfileModule } from './modules/profile/profile.module';
import { ContactModule } from './modules/contact/contact.module';
import { SkillModule } from './modules/skill/skill.module';
import { LanguageModule } from './modules/language/language.module';
import { PassionModule } from './modules/passion/passion.module';
import { ExperienceModule } from './modules/experience/experience.module';
import { ProjectModule } from './modules/project/project.module';
import { EducationModule } from './modules/education/education.module';
import { CvModule } from './modules/cv/cv.module';
import { TimelineModule } from './modules/timeline/timeline.module';
import { ImagesModule } from './modules/images/images.module';
import { CategoryModule } from './modules/category/category.module';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'better-sqlite3',
      database: 'data/cvmanager.sqlite',
      entities: [__dirname + '/**/*.entity{.ts,.js}'],
      synchronize: true,
    }),
    AuthModule,
    ProfileModule,
    ContactModule,
    SkillModule,
    LanguageModule,
    PassionModule,
    ExperienceModule,
    ProjectModule,
    EducationModule,
    CvModule,
    TimelineModule,
    ImagesModule,
    CategoryModule,
  ],
})
export class AppModule {}
