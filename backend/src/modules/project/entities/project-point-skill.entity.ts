import { Entity, PrimaryColumn, ManyToOne, JoinColumn } from 'typeorm';
import { ProjectPoint } from './project-point.entity';
import { Skill } from '../../skill/entities/skill.entity';

@Entity('project_point_skills')
export class ProjectPointSkill {
  @PrimaryColumn({ type: 'uuid' })
  pointId: string;

  @PrimaryColumn({ type: 'uuid' })
  skillId: string;

  @ManyToOne(() => ProjectPoint, (point) => point.skillLinks, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'pointId' })
  point: ProjectPoint;

  @ManyToOne(() => Skill, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'skillId' })
  skill: Skill;
}
