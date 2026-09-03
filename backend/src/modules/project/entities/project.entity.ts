import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne, JoinColumn, ManyToMany, JoinTable, OneToMany } from 'typeorm';
import { Category } from '../../category/entities/category.entity';
import { Education } from '../../education/entities/education.entity';
import { Image } from '../../images/entities/image.entity';
import { Link } from './link.entity';
import { ProjectTimelineEntry } from './project-timeline-entry.entity';
import { ProjectPoint } from './project-point.entity';
import { ProjectTechnology } from './project-technology.entity';

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
  startDate: string;

  @Column({ nullable: true })
  endDate: string;

  @Column({ type: 'text', nullable: true })
  description: string;

  @Column({ type: 'text', nullable: true })
  longDescription: string;

  @OneToMany(() => ProjectTechnology, (tech) => tech.project, { cascade: true, orphanedRowAction: 'delete' })
  technologies: ProjectTechnology[];

  @ManyToMany(() => Category)
  @JoinTable({ name: 'project_categories' })
  categories: Category[];

  @Column({ type: 'enum', enum: ProjectStatus, default: ProjectStatus.IN_PROGRESS })
  status: ProjectStatus;

  @Column({ type: 'boolean', default: false })
  featured: boolean;

  @Column({ nullable: true })
  imageUrl: string;

  @Column({ nullable: true })
  imageId: string;

  @ManyToOne(() => Image)
  @JoinColumn({ name: 'imageId' })
  image: Image;

  @OneToMany(() => Link, link => link.project, { cascade: true, orphanedRowAction: 'delete' })
  links: Link[];

  @OneToMany(() => ProjectTimelineEntry, entry => entry.project, { cascade: true, orphanedRowAction: 'delete' })
  timelineEntries: ProjectTimelineEntry[];

  @OneToMany(() => ProjectPoint, point => point.project, { cascade: true, orphanedRowAction: 'delete' })
  projectPoints: ProjectPoint[];

  @Column({ nullable: true })
  educationId: string;

  @ManyToOne(() => Education)
  @JoinColumn({ name: 'educationId' })
  education: Education;

  @Column({ type: 'int', default: 0 })
  order: number;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
