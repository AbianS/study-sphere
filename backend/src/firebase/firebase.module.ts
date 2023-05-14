import { Module } from '@nestjs/common';
import { FirebaseService } from './firebase.service';
import { PrismaService } from 'prisma/prisma.service';

@Module({
  controllers: [],
  providers: [FirebaseService, PrismaService],
  exports: [FirebaseService],
})
export class FirebaseModule {}
