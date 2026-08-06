import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Cv } from './cv.entity';
import { Project } from '../../project/entities/project.entity';

@Entity('cv_projects')
export class CvProject {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'uuid' })
  cvId: string;

  @Column({ type: 'uuid' })
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
