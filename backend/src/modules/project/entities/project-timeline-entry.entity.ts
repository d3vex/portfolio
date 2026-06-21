import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Project } from '../../project/entities/project.entity';

@Entity('project_timeline_entries')
export class ProjectTimelineEntry {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  date: string;

  @Column()
  title: string;

  @Column({ nullable: true })
  description: string;

  @Column({ nullable: true })
  status: string;

  @Column({ nullable: true })
  imageUrl: string;

  @Column({ type: 'int', default: 0 })
  order: number;

  @Column()
  projectId: string;

  @ManyToOne(() => Project, project => project.timelineEntries)
  @JoinColumn({ name: 'projectId' })
  project: Project;
}
