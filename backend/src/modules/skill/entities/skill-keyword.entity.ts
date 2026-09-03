import { Entity, PrimaryColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Skill } from './skill.entity';

@Entity('skill_keywords')
export class SkillKeyword {
  @PrimaryColumn({ type: 'uuid' })
  skillId: string;

  @PrimaryColumn({ type: 'varchar' })
  value: string;

  @ManyToOne(() => Skill, (skill) => skill.keywords, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'skillId' })
  skill: Skill;
}
