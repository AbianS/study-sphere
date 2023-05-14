import { MailerService } from '@nestjs-modules/mailer';
import { BadRequestException, Injectable } from '@nestjs/common';
import { PrismaService } from 'prisma/prisma.service';

@Injectable()
export class MailService {
  constructor(
    private readonly mailerService: MailerService,
    private prisma: PrismaService,
  ) {}

  async sendMail(email: string): Promise<void> {
    const user = await this.prisma.user.findUnique({
      where: { email: email },
    });

    if (!user) {
      throw new BadRequestException(`User with email: ${email} not found`);
    }

    const number = this.generateRandomString();

    const resetPassword = await this.prisma.resetPassowrd.findUnique({
      where: { userId: user.id },
    });

    if (resetPassword) {
      await this.prisma.resetPassowrd.update({
        where: { userId: user.id },
        data: {
          code: number,
        },
      });
    }

    if (!resetPassword) {
      await this.prisma.resetPassowrd.create({
        data: {
          userId: user.id,
          code: number,
        },
      });
    }

    this.mailerService.sendMail({
      to: email,
      from: 'studyspheres@gmail.com',
      subject: 'Restablecer Contraseña',
      text: `Ingrese el siguiente codigo en la aplicación para poder restablecer su contraseña: ${number}`,
    });
  }

  generateRandomString(): string {
    const characters =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    let result = '';
    for (let i = 0; i < 6; i++) {
      result += characters.charAt(
        Math.floor(Math.random() * characters.length),
      );
    }
    return result;
  }
}
