import { Entity, PrimaryColumn, ManyToOne, JoinColumn } from 'typeorm';
import { Cv } from './cv.entity';
import { ProjectPoint } from '../../project/entities/project-point.entity';

@Entity('cv_project_points')
export class CvProjectPoint {
  @PrimaryColumn({ type: 'uuid' })
  cvId: string;

  @PrimaryColumn({ type: 'uuid' })
  projectPointId: string;

  @ManyToOne(() => Cv, (cv) => cv.projectPointLinks, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'cvId' })
  cv: Cv;

  @ManyToOne(() => ProjectPoint, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'projectPointId' })
  projectPoint: ProjectPoint;
}
