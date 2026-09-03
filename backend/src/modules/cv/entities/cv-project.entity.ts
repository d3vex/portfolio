import { Entity, PrimaryColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Cv } from './cv.entity';
import { Project } from '../../project/entities/project.entity';

@Entity('cv_projects')
export class CvProject {
  @PrimaryColumn({ type: 'uuid' })
  cvId: string;

  @PrimaryColumn({ type: 'uuid' })
  projectId: string;

  @Column({ type: 'int', default: 0 })
  order: number;

  @ManyToOne(() => Cv, (cv) => cv.projectLinks, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'cvId' })
  cv: Cv;

  @ManyToOne(() => Project, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'projectId' })
  project: Project;
}
