import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PassionController } from './passion.controller';
import { PassionService } from './passion.service';
import { Passion } from './entities/passion.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Passion])],
  controllers: [PassionController],
  providers: [PassionService],
})
export class PassionModule {}
