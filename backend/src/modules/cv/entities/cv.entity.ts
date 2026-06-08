import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

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

  @Column({ type: 'simple-json', nullable: true })
  skillIds: string[];

  @Column({ type: 'simple-json', nullable: true })
  languageIds: string[];

  @Column({ type: 'simple-json', nullable: true })
  passionIds: string[];

  @Column({ type: 'simple-json', nullable: true })
  experienceIds: string[];

  @Column({ type: 'simple-json', nullable: true })
  projectIds: string[];

  @Column({ type: 'simple-json', nullable: true })
  educationIds: string[];

  @Column({ nullable: true })
  pictureId: string;

  @Column({ nullable: true })
  availability: string;

  @Column({ default: false })
  isDefault: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
