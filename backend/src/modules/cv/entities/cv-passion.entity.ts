import { Entity, PrimaryColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Cv } from './cv.entity';
import { Passion } from '../../passion/entities/passion.entity';

@Entity('cv_passions')
export class CvPassion {
  @PrimaryColumn({ type: 'uuid' })
  cvId: string;

  @PrimaryColumn({ type: 'uuid' })
  passionId: string;

  @Column({ type: 'int', default: 0 })
  order: number;

  @ManyToOne(() => Cv, (cv) => cv.passionLinks, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'cvId' })
  cv: Cv;

  @ManyToOne(() => Passion, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'passionId' })
  passion: Passion;
}
