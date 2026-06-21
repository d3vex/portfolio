import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Project } from '../../project/entities/project.entity';
import { Experience } from '../../experience/entities/experience.entity';

@Entity('links')
export class Link {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  label: string;

  @Column()
  url: string;

  @Column({ nullable: true })
  icon: string;

  @Column({ nullable: true })
  type: string;

  @Column({ type: 'int', default: 0 })
  order: number;

  @Column({ nullable: true })
  projectId: string;

  @ManyToOne(() => Project, project => project.links)
  @JoinColumn({ name: 'projectId' })
  project: Project;

  @Column({ nullable: true })
  experienceId: string;

  @ManyToOne(() => Experience, experience => experience.links)
  @JoinColumn({ name: 'experienceId' })
  experience: Experience;
}
