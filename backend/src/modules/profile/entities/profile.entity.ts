import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity('profiles')
export class Profile {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  firstName: string;

  @Column()
  lastName: string;

  @Column({ nullable: true })
  initials: string;

  @Column({ nullable: true })
  photoUrl: string;

  @Column({ default: '' })
  availability: string;

  @Column({ type: 'text', default: '' })
  about: string;

  @Column({ nullable: true })
  specialization: string;
}
