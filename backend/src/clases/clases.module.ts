import { Module } from '@nestjs/common';
import { PrismaService } from 'prisma/prisma.service';
import { AuthModule } from 'src/auth/auth.module';
import { ClasesController } from './clases.controller';
import { ClasesService } from './clases.service';
import { FirebaseModule } from 'src/firebase/firebase.module';

@Module({
  controllers: [ClasesController],
  providers: [ClasesService, PrismaService],
  imports: [AuthModule, FirebaseModule],
})
export class ClasesModule {}
