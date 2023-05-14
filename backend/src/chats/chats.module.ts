import { Module } from '@nestjs/common';
import { AuthModule } from 'src/auth/auth.module';
import { ChatsGateway } from './chats.gateway';
import { ChatsService } from './chats.service';
import { PrismaService } from 'prisma/prisma.service';
import { ChatsController } from './chats.controller';
import { FirebaseModule } from 'src/firebase/firebase.module';

@Module({
  providers: [ChatsGateway, ChatsService, PrismaService],
  imports: [AuthModule, FirebaseModule],
  controllers: [ChatsController],
})
export class ChatsModule {}
