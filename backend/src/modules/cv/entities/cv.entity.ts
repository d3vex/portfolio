import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToMany, JoinTable, ManyToOne, JoinColumn } from 'typeorm';
import { Skill } from '../../skill/entities/skill.entity';
import { Language } from '../../language/entities/language.entity';
import { Passion } from '../../passion/entities/passion.entity';
import { Experience } from '../../experience/entities/experience.entity';
import { Project } from '../../project/entities/project.entity';
import { Education } from '../../education/entities/education.entity';
import { Image } from '../../images/entities/image.entity';
import { Contact } from '../../contact/entities/contact.entity';

@Entity('cvs')
export class Cv {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  name: string;

  @Column({ nullable: true })
  specialization: string;

  @Column({ nullable: true })
  titleOverride: string;

  @Column({ type: 'text', nullable: true })
  aboutText: string;

  @ManyToMany(() => Skill)
  @JoinTable({ name: 'cv_skills' })
  skills: Skill[];

  @ManyToMany(() => Language)
  @JoinTable({ name: 'cv_languages' })
  languages: Language[];

  @ManyToMany(() => Passion)
  @JoinTable({ name: 'cv_passions' })
  passions: Passion[];

  @ManyToMany(() => Experience)
  @JoinTable({ name: 'cv_experiences' })
  experiences: Experience[];

  @ManyToMany(() => Project)
  @JoinTable({ name: 'cv_projects' })
  projects: Project[];

  @ManyToMany(() => Education)
  @JoinTable({ name: 'cv_education' })
  education: Education[];

  @ManyToMany(() => Contact)
  @JoinTable({ name: 'cv_contacts' })
  contacts: Contact[];

  @Column({ type: 'json', nullable: true })
  projectBullets: Record<string, number[]>;

  @Column({ nullable: true })
  pictureId: string;

  @ManyToOne(() => Image)
  @JoinColumn({ name: 'pictureId' })
  picture: Image;

  @Column({ nullable: true })
  availability: string;

  @Column({ type: 'boolean', default: false })
  isDefault: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
