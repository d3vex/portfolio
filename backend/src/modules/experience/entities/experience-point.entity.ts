import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, OneToMany } from 'typeorm';
import { Experience } from './experience.entity';
import { ExperiencePointSkill } from './experience-point-skill.entity';

@Entity('experience_points')
export class ExperiencePoint {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'text' })
  text: string;

  @Column({ type: 'int', default: 0 })
  order: number;

  @OneToMany(() => ExperiencePointSkill, (link) => link.point, { cascade: true, orphanedRowAction: 'delete' })
  skillLinks: ExperiencePointSkill[];

  @Column()
  experienceId: string;

  @ManyToOne(() => Experience, exp => exp.experiencePoints)
  @JoinColumn({ name: 'experienceId' })
  experience: Experience;
}
