import {
  Body,
  Controller,
  FileTypeValidator,
  Get,
  MaxFileSizeValidator,
  Param,
  ParseFilePipe,
  ParseUUIDPipe,
  Patch,
  Post,
  Res,
  UploadedFile,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiResponse, ApiTags } from '@nestjs/swagger';
import { Response } from 'express';
import { AuthService } from './auth.service';
import { GetUser } from './decorators/get-user.decorator';
import { UserDTO } from './dto/classes/UserDTO';
import { CheckRestorePasswordDataIn } from './dto/dto/check-restore-password';
import { ConfirmRestorePasswordDataIn } from './dto/dto/confirm-restore-password.dto';
import { LoginUserDataIn, LoginUserDataOut } from './dto/dto/login-user.dto';
import {
  RegisterUserDataIn,
  RegisterUserDataOut,
} from './dto/dto/register-user.dto';
import { RestorePasswordDataIn } from './dto/dto/restore-password';
import { UpdateUserDTO } from './dto/dto/update-user.dto';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('restore-password')
  async restorePasword(@Body() email: RestorePasswordDataIn) {
    return this.authService.restorePassword(email);
  }

  @Post('check-restore-password')
  async checkRestorePassword(@Body() checkRestore: CheckRestorePasswordDataIn) {
    return this.authService.checRestorePassword(checkRestore);
  }

  @Post('confirm-restore-password')
  async confirmRestorePassword(
    @Body() confirmRestorePassword: ConfirmRestorePasswordDataIn,
  ) {
    return this.authService.confirmRestorePassword(confirmRestorePassword);
  }

  @Post('register')
  async registerUser(
    @Body() registerUserDataIn: RegisterUserDataIn,
  ): Promise<RegisterUserDataOut> {
    return await this.authService.register(registerUserDataIn);
  }

  @ApiResponse({
    status: 200,
    type: LoginUserDataOut,
  })
  @Post('login')
  async login(
    @Body() loginUserDataIn: LoginUserDataIn,
  ): Promise<LoginUserDataOut> {
    return await this.authService.login(loginUserDataIn);
  }

  @Post('notification/:token')
  @UseGuards(AuthGuard())
  addNotificationToken(
    @GetUser() user: UserDTO,
    @Param('token') token: string,
  ) {
    this.authService.addNotificationToken(user, token);
  }

  @Get('private')
  @UseGuards(AuthGuard())
  testingPrivateRoute(@GetUser() user: UserDTO) {
    return {
      ok: true,
      message: 'hola',
      user,
    };
  }

  @Get('check-status')
  @UseGuards(AuthGuard())
  checkAuthStatus(@GetUser() user: UserDTO) {
    return this.authService.checkAuthStatus(user);
  }

  @Get('avatar/:imageName')
  findAvatarImage(@Res() res: Response, @Param('imageName') imageName: string) {
    const path = this.authService.getStaticProductImage(imageName);
    res.sendFile(path);
  }

  @Post('avatar')
  @UseGuards(AuthGuard())
  @UseInterceptors(FileInterceptor('avatar'))
  uploadAvatarImage(
    @GetUser() user: UserDTO,
    @UploadedFile(
      new ParseFilePipe({
        validators: [
          new FileTypeValidator({ fileType: /image\/(jpeg|jpg|png|gif|bmp)/ }),
          new MaxFileSizeValidator({ maxSize: 100 * 1024 * 1024 }), // 100 MB
        ],
      }),
    )
    file: Express.Multer.File,
  ) {
    return this.authService.updateUserAvatar(user, file);
  }

  @Patch('update')
  @UseGuards(AuthGuard())
  @UseInterceptors(FileInterceptor('file'))
  updateUser(
    @GetUser() user: UserDTO,
    @Body() updateUserDTO: UpdateUserDTO,
    @UploadedFile() file: Express.Multer.File,
  ) {
    return this.authService.updateUser(user, updateUserDTO, file);
  }

  @Get(':id')
  getById(@Param('id', ParseUUIDPipe) id: string): Promise<UserDTO> {
    return this.authService.getUserById(id);
  }
}
