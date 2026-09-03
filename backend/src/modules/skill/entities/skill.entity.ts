import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, OneToMany } from 'typeorm';
import { Category } from '../../category/entities/category.entity';
import { SkillKeyword } from './skill-keyword.entity';

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

  @ManyToOne(() => Category)
  @JoinColumn({ name: 'categoryId' })
  category: Category;

  @Column({ type: 'enum', enum: ['hard', 'soft'] })
  cvCategory: 'hard' | 'soft';

  @Column({ type: 'text', nullable: true })
  description: string;

  @OneToMany(() => SkillKeyword, (keyword) => keyword.skill, { cascade: true, orphanedRowAction: 'delete' })
  keywords: SkillKeyword[];

  @Column({ type: 'int', default: 0 })
  level: number;

  @Column({ type: 'int', default: 0 })
  order: number;
}
