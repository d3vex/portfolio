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
import { CvRenderModule } from './modules/cv-render/cv-render.module';
import { TimelineModule } from './modules/timeline/timeline.module';
import { ImagesModule } from './modules/images/images.module';
import { CategoryModule } from './modules/category/category.module';
import { AiModule } from './modules/ai/ai.module';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'mariadb',
      host: process.env.DB_HOST || 'localhost',
      port: parseInt(process.env.DB_PORT || '3306', 10),
      username: process.env.DB_USER || 'root',
      password: process.env.DB_PASS || '',
      database: process.env.DB_NAME || 'cvmanager',
      entities: [__dirname + '/**/*.entity{.ts,.js}'],
      synchronize: true,
      extra: {
        maxAllowedPacket: 256 * 1024 * 1024,
      },
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
    // Must be imported BEFORE CvModule: CvRenderController registers the static
    // `GET /api/cv/styles` route and would otherwise be shadowed by
    // CvController's `GET /api/cv/:id` param route (Express matches in
    // registration order).
    CvRenderModule,
    CvModule,
    TimelineModule,
    ImagesModule,
    CategoryModule,
    AiModule,
  ],
})
export class AppModule {}
