import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity('contacts')
export class Contact {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  label: string;

  @Column()
  value: string;

  @Column({ nullable: true })
  icon: string;

  @Column({ default: 'info' })
  type: string;

  @Column({ default: 0 })
  order: number;
}
