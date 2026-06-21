import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Project } from './project.entity';

@Entity('project_points')
export class ProjectPoint {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'text' })
  text: string;

  @Column({ type: 'int', default: 0 })
  order: number;

  @Column({ type: 'json', nullable: true })
  skillIds: string[];

  @Column()
  projectId: string;

  @ManyToOne(() => Project, project => project.projectPoints)
  @JoinColumn({ name: 'projectId' })
  project: Project;
}
