import { Entity, PrimaryColumn, ManyToOne, JoinColumn } from 'typeorm';
import { ExperiencePoint } from './experience-point.entity';
import { Skill } from '../../skill/entities/skill.entity';

@Entity('experience_point_skills')
export class ExperiencePointSkill {
  @PrimaryColumn({ type: 'uuid' })
  pointId: string;

  @PrimaryColumn({ type: 'uuid' })
  skillId: string;

  @ManyToOne(() => ExperiencePoint, (point) => point.skillLinks, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'pointId' })
  point: ExperiencePoint;

  @ManyToOne(() => Skill, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'skillId' })
  skill: Skill;
}
