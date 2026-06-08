import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity('skills')
export class Skill {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  name: string;

  @Column({ nullable: true })
  icon: string;

  @Column({ nullable: true })
  categoryId: string;

  @Column({ default: 'hard' })
  cvCategory: string;

  @Column({ type: 'text', nullable: true })
  description: string;

  @Column({ type: 'simple-json', nullable: true })
  keywords: string[];

  @Column({ default: 0 })
  level: number;

  @Column({ default: 0 })
  order: number;
}
