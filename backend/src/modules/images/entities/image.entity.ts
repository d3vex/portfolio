import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('images')
export class Image {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'blob' })
  data: Buffer;

  @Column()
  mimeType: string;

  @Column({ nullable: true })
  originalName: string;

  @Column({ type: 'int', default: 0 })
  size: number;

  @CreateDateColumn()
  createdAt: Date;
}
