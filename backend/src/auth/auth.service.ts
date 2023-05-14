import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
  NotFoundException,
  UnauthorizedException,
} from '@nestjs/common';

import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { PrismaService } from '../../prisma/prisma.service';
import { UserDTO } from './dto/classes/UserDTO';
import { LoginUserDataIn, LoginUserDataOut } from './dto/dto/login-user.dto';
import {
  RegisterUserDataIn,
  RegisterUserDataOut,
} from './dto/dto/register-user.dto';
import { JwtPayload } from './interfaces/jwt-payload.interface';

import { existsSync, unlinkSync } from 'fs';
import { join } from 'path';
import { FirebaseService } from 'src/firebase/firebase.service';
import { RestorePasswordDataIn } from './dto/dto/restore-password';
import { MailService } from 'src/mail/mail.service';
import { CheckRestorePasswordDataIn } from './dto/dto/check-restore-password';
import { ConfirmRestorePasswordDataIn } from './dto/dto/confirm-restore-password.dto';
import { UpdateUserDTO } from './dto/dto/update-user.dto';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private readonly jwtService: JwtService,
    private readonly firebaseService: FirebaseService,
    private readonly mailService: MailService,
  ) {}

  async register(
    registerUserDataIn: RegisterUserDataIn,
  ): Promise<RegisterUserDataOut> {
    try {
      const { password, ...userData } = registerUserDataIn;

      const user = await this.prisma.user.create({
        data: {
          ...userData,
          password: bcrypt.hashSync(password, 10),
        },
      });
      
      delete user.password;
      delete user.updated_at;
      delete user.created_at;
      delete user.deleted;
      return {
        ...user,
        token: this.getJwtToken({ id: user.id }),
      };
    } catch (error) {
      console.log(error);

      this.handleDbErrors(error);
    }
  }

  async restorePassword(restorePassword: RestorePasswordDataIn) {
    const user = await this.prisma.user.findUnique({
      where: { email: restorePassword.email },
    });

    if (!user) {
      throw new NotFoundException('The user whith this email not found');
    }

    return await this.mailService.sendMail(restorePassword.email);
  }

  async checRestorePassword(checkRestore: CheckRestorePasswordDataIn) {
    const user = await this.prisma.user.findUnique({
      where: {
        email: checkRestore.email,
      },
    });

    const resetPassword = await this.prisma.resetPassowrd.findUnique({
      where: { userId: user.id },
    });

    if (resetPassword.code !== checkRestore.code)
      throw new BadRequestException('code not match');

    return;
  }

  async confirmRestorePassword(
    confirmRestorePassword: ConfirmRestorePasswordDataIn,
  ) {
    await this.prisma.user.update({
      where: { email: confirmRestorePassword.email },
      data: { password: bcrypt.hashSync(confirmRestorePassword.password, 10) },
    });

    return;
  }

  async updateUser(
    user: UserDTO,
    updateUserDTO: UpdateUserDTO,
    file?: Express.Multer.File,
  ) {
    let fileUrl: string | undefined;
    if (file) {
      console.log('E');

      [fileUrl] = await this.firebaseService.uploadFile(file);
    }

    const userUpdate = await this.prisma.user.update({
      where: { id: user.id },
      data: {
        ...updateUserDTO,
        avatar: fileUrl,
      },
    });

    delete userUpdate.password;
    delete userUpdate.updated_at;
    delete userUpdate.created_at;
    delete userUpdate.deleted;
    return {
      ...userUpdate,
      token: this.getJwtToken({ id: user.id }),
    };
  }

  async login(loginUserDto: LoginUserDataIn): Promise<LoginUserDataOut> {
    const { password, email } = loginUserDto;
    const user = await this.prisma.user.findFirst({
      where: { email },
    });

    if (!user || !bcrypt.compareSync(password, user.password)) {
      throw new UnauthorizedException('Credentials not valid');
    }

    
    delete user.created_at;
    delete user.deleted;
    delete user.updated_at;
    delete user.password;

    return {
      ...user,
      token: this.getJwtToken({ id: user.id }),
    };
  }

  async checkAuthStatus(user: UserDTO) {
    return {
      ...user,
      token: this.getJwtToken({ id: user.id }),
    };
  }

  async getUserById(userId: string) {
    const user = await this.prisma.user.findUnique({
      where: {
        id: userId,
      },
    });

    if (!user) throw new UnauthorizedException('Token not valid');

    return user;
  }

  async updateUserAvatar(user: UserDTO, file: Express.Multer.File) {
    const url = await this.firebaseService.uploadFile(file);

    await this.prisma.user.update({
      where: { id: user.id },
      data: {
        avatar: url[0],
      },
    });
  }

  async addNotificationToken(user: UserDTO, token: string) {
    const findUser = await this.prisma.user.findUnique({
      where: { id: user.id },
    });

    if (!findUser.notifications_token.includes(token)) {
      
      await this.prisma.user.update({
        where: { id: user.id },
        data: { notifications_token: { push: token } },
      });
    }
  }

  getStaticProductImage(imageName: string) {
    const path = join(
      'G:/Nest/study_sphere_backend/static/user/profile',
      imageName,
    );

    if (!existsSync(path)) {
      throw new BadRequestException(`No product found with image ${imageName}`);
    }

    return path;
  }

  private deleteImage(imageName: string): void {
    // Version real
    // const path = join(__dirname, '../../static/user/profile', imageName);

    // desarrollo
    const path = `G:/Nest/study_sphere_backend/static/user/profile/${imageName}`;
    try {
      unlinkSync(path);
    } catch (error) {
      console.log(error);
    }
  }

  private getJwtToken(payload: JwtPayload) {
    const token = this.jwtService.sign(payload);
    return token;
  }

  private handleDbErrors(error: any): never {
    if (error.code === '23505') {
      throw new BadRequestException(error.detail);
    }

    throw new InternalServerErrorException();
  }
}
