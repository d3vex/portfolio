import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity('passions')
export class Passion {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  name: string;

  @Column({ type: 'text', nullable: true })
  description: string;

  @Column({ nullable: true })
  icon: string;

  @Column({ default: 0 })
  order: number;
}
