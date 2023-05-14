import { Module } from '@nestjs/common';
import { TodosService } from './todos.service';
import { TodosController } from './todos.controller';
import { PrismaService } from 'prisma/prisma.service';
import { AuthModule } from 'src/auth/auth.module';

@Module({
  controllers: [TodosController],
  providers: [TodosService, PrismaService],
  imports: [AuthModule],
})
export class TodosModule {}
