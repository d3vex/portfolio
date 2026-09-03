import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SkillController } from './skill.controller';
import { SkillService } from './skill.service';
import { Skill } from './entities/skill.entity';
import { SkillKeyword } from './entities/skill-keyword.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Skill, SkillKeyword])],
  controllers: [SkillController],
  providers: [SkillService],
  exports: [SkillService],
})
export class SkillModule {}
