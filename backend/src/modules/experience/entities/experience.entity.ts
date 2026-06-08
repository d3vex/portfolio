import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

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

  @Column({ nullable: true })
  startDate: string;

  @Column({ nullable: true })
  endDate: string;

  @Column({ type: 'simple-json', nullable: true })
  descriptions: { text: string; skillIds?: string[] }[];

  @Column({ type: 'simple-json', nullable: true })
  skillIds: string[];

  @Column({ type: 'simple-json', nullable: true })
  links: { label: string; url: string; icon?: string; type?: string }[];

  @Column({ nullable: true })
  imageId: string;

  @Column({ default: 0 })
  order: number;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
