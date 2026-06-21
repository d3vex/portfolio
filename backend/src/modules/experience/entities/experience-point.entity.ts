import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Experience } from './experience.entity';

@Entity('experience_points')
export class ExperiencePoint {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'text' })
  text: string;

  @Column({ type: 'int', default: 0 })
  order: number;

  @Column({ type: 'json', nullable: true })
  skillIds: string[];

  @Column()
  experienceId: string;

  @ManyToOne(() => Experience, exp => exp.experiencePoints)
  @JoinColumn({ name: 'experienceId' })
  experience: Experience;
}
