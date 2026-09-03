import { Entity, PrimaryColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Cv } from './cv.entity';
import { Skill } from '../../skill/entities/skill.entity';

@Entity('cv_skills')
export class CvSkill {
  @PrimaryColumn({ type: 'uuid' })
  cvId: string;

  @PrimaryColumn({ type: 'uuid' })
  skillId: string;

  @Column({ type: 'int', default: 0 })
  order: number;

  @ManyToOne(() => Cv, (cv) => cv.skillLinks, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'cvId' })
  cv: Cv;

  @ManyToOne(() => Skill, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'skillId' })
  skill: Skill;
}
