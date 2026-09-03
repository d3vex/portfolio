import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne, JoinColumn, OneToMany } from 'typeorm';
import { Image } from '../../images/entities/image.entity';
import { Link } from '../../project/entities/link.entity';
import { ExperiencePoint } from './experience-point.entity';
import { ExperienceTag } from './experience-tag.entity';

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

  @OneToMany(() => ExperienceTag, (tag) => tag.experience, { cascade: true, orphanedRowAction: 'delete' })
  tags: ExperienceTag[];

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
