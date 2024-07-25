import { Entity, Column, PrimaryGeneratedColumn, ManyToOne, CreateDateColumn } from 'typeorm';
import { User } from './user.entity';

@Entity()
export class RefreshToken {
  @PrimaryGeneratedColumn()
  id: number;
  @Column()
  token: string;
  @CreateDateColumn()
  createdAt: Date;
  @ManyToOne(() => User)
  user: User;
  @Column()
  expiresAt: Date;
}