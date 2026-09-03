import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, OneToMany } from 'typeorm';
import { Project } from './project.entity';
import { ProjectPointSkill } from './project-point-skill.entity';

@Entity('project_points')
export class ProjectPoint {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'text' })
  text: string;

  @Column({ type: 'int', default: 0 })
  order: number;

  @OneToMany(() => ProjectPointSkill, (link) => link.point, { cascade: true, orphanedRowAction: 'delete' })
  skillLinks: ProjectPointSkill[];

  @Column()
  projectId: string;

  @ManyToOne(() => Project, project => project.projectPoints)
  @JoinColumn({ name: 'projectId' })
  project: Project;
}
