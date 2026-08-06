import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Cv } from './cv.entity';
import { Skill } from '../../skill/entities/skill.entity';

@Entity('cv_skills')
export class CvSkill {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'uuid' })
  cvId: string;

  @Column({ type: 'uuid' })
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
