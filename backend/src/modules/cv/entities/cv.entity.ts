import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToMany, JoinTable, ManyToOne, JoinColumn, OneToMany } from 'typeorm';
import { Language } from '../../language/entities/language.entity';
import { Experience } from '../../experience/entities/experience.entity';
import { Education } from '../../education/entities/education.entity';
import { Image } from '../../images/entities/image.entity';
import { Contact } from '../../contact/entities/contact.entity';
import { CvSkill } from './cv-skill.entity';
import { CvProject } from './cv-project.entity';
import { CvPassion } from './cv-passion.entity';

@Entity('cvs')
export class Cv {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  name: string;

  @Column({ nullable: true })
  candidateName: string;

  @Column({ nullable: true })
  specialization: string;

  @Column({ nullable: true })
  titleOverride: string;

  @Column({ type: 'text', nullable: true })
  aboutText: string;

  @OneToMany(() => CvSkill, (link) => link.cv, { cascade: true })
  skillLinks: CvSkill[];

  @ManyToMany(() => Language)
  @JoinTable({ name: 'cv_languages' })
  languages: Language[];

  @OneToMany(() => CvPassion, (link) => link.cv, { cascade: true })
  passionLinks: CvPassion[];

  @ManyToMany(() => Experience)
  @JoinTable({ name: 'cv_experiences' })
  experiences: Experience[];

  @OneToMany(() => CvProject, (link) => link.cv, { cascade: true })
  projectLinks: CvProject[];

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

  @Column({ type: 'varchar', length: 64, default: 'classic' })
  style: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
