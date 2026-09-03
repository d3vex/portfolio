import { Entity, PrimaryColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Project } from './project.entity';

@Entity('project_technologies')
export class ProjectTechnology {
  @PrimaryColumn({ type: 'uuid' })
  projectId: string;

  @PrimaryColumn({ type: 'varchar' })
  name: string;

  @Column({ type: 'varchar', nullable: true })
  icon: string;

  @ManyToOne(() => Project, (project) => project.technologies, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'projectId' })
  project: Project;
}
