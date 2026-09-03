import { Entity, PrimaryColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Experience } from './experience.entity';

@Entity('experience_tags')
export class ExperienceTag {
  @PrimaryColumn({ type: 'uuid' })
  experienceId: string;

  @PrimaryColumn({ type: 'varchar' })
  value: string;

  @ManyToOne(() => Experience, (experience) => experience.tags, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'experienceId' })
  experience: Experience;
}
