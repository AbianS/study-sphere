import { Module } from '@nestjs/common';
import { MailService } from './mail.service';
import { MailController } from './mail.controller';
import { MailerModule } from '@nestjs-modules/mailer';
import { PrismaService } from 'prisma/prisma.service';

@Module({
  controllers: [MailController],
  providers: [MailService, PrismaService],
  imports: [
    MailerModule.forRoot({
      transport: {
        host: 'smtp.gmail.com',
        auth: {
          user: 'studyspheres@gmail.com',
          pass: 'ktsmtrwmqlpoppet',
        },
      },
    }),
  ],
  exports: [MailService],
})
export class MailModule {}
