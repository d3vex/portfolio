import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, OneToMany } from 'typeorm';
import { Project } from '../../project/entities/project.entity';
import { EducationTag } from './education-tag.entity';

@Entity('education')
export class Education {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  title: string;

  @Column({ nullable: true })
  school: string;

  @Column({ nullable: true })
  startDate: string;

  @Column({ nullable: true })
  endDate: string;

  @Column({ nullable: true })
  date: string;

  @Column({ type: 'text', nullable: true })
  description: string;

  @OneToMany(() => EducationTag, (tag) => tag.education, { cascade: true, orphanedRowAction: 'delete' })
  tags: EducationTag[];

  @OneToMany(() => Project, project => project.education)
  projects: Project[];

  @Column({ type: 'int', default: 0 })
  order: number;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  get icon(): string {
    return 'mdi:school';
  }
}
