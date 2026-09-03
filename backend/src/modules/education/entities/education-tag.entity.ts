import { Entity, PrimaryColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Education } from './education.entity';

@Entity('education_tags')
export class EducationTag {
  @PrimaryColumn({ type: 'uuid' })
  educationId: string;

  @PrimaryColumn({ type: 'varchar' })
  value: string;

  @ManyToOne(() => Education, (education) => education.tags, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'educationId' })
  education: Education;
}
