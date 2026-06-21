import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne, JoinColumn, ManyToMany, JoinTable, OneToMany } from 'typeorm';
import { Skill } from '../../skill/entities/skill.entity';
import { Image } from '../../images/entities/image.entity';
import { Link } from '../../project/entities/link.entity';
import { ExperiencePoint } from './experience-point.entity';

@Entity('experiences')
export class Experience {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  title: string;

  @Column()
  company: string;

  @Column({ nullable: true })
  companyUrl: string;

  @Column({ nullable: true })
  location: string;

  @Column({ type: 'text', nullable: true })
  description: string;

  @Column({ nullable: true })
  startDate: string;

  @Column({ nullable: true })
  endDate: string;

  @ManyToMany(() => Skill)
  @JoinTable({ name: 'experience_skills' })
  skills: Skill[];

  @Column({ type: 'json', nullable: true })
  tags: string[];

  @OneToMany(() => Link, link => link.experience, { cascade: true, orphanedRowAction: 'delete' })
  links: Link[];

  @OneToMany(() => ExperiencePoint, point => point.experience, { cascade: true, orphanedRowAction: 'delete' })
  experiencePoints: ExperiencePoint[];

  @Column({ nullable: true })
  imageId: string;

  @ManyToOne(() => Image)
  @JoinColumn({ name: 'imageId' })
  image: Image;

  @Column({ type: 'int', default: 0 })
  order: number;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
