import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity('languages')
export class Language {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  name: string;

  @Column()
  level: string;

  @Column({ type: 'int', default: 0 })
  order: number;
}
