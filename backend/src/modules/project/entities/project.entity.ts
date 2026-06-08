import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

export enum ProjectStatus {
  COMPLETED = 'completed',
  TESTING = 'testing',
  IN_PROGRESS = 'in-progress',
  PLANNED = 'planned',
}

@Entity('projects')
export class Project {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  title: string;

  @Column({ nullable: true })
  subtitle: string;

  @Column({ nullable: true })
  url: string;

  @Column({ nullable: true })
  startDate: string;

  @Column({ nullable: true })
  endDate: string;

  @Column({ type: 'text', nullable: true })
  description: string;

  @Column({ type: 'text', nullable: true })
  longDescription: string;

  @Column({ type: 'simple-json', nullable: true })
  descriptions: { text: string; skillIds?: string[] }[];

  @Column({ type: 'simple-json', nullable: true })
  technologies: { name: string; icon?: string }[];

  @Column({ type: 'simple-json', nullable: true })
  categoryIds: string[];

  @Column({ type: 'simple-json', nullable: true })
  skillIds: string[];

  @Column({ type: 'simple-enum', enum: ProjectStatus, default: ProjectStatus.IN_PROGRESS })
  status: ProjectStatus;

  @Column({ default: false })
  featured: boolean;

  @Column({ nullable: true })
  imageUrl: string;

  @Column({ nullable: true })
  imageId: string;

  @Column({ nullable: true })
  liveUrl: string;

  @Column({ nullable: true })
  sourceUrl: string;

  @Column({ type: 'simple-json', nullable: true })
  links: { label: string; url: string; icon?: string; type?: string }[];

  @Column({ type: 'simple-json', nullable: true })
  timeline: { date: string; title: string; description: string; status: string; imageUrl?: string }[];

  @Column({ nullable: true })
  educationId: string;

  @Column({ default: 0 })
  order: number;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
