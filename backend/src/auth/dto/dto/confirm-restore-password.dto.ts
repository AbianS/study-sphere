import { IsEmail, IsString } from 'class-validator';

export class ConfirmRestorePasswordDataIn {
  @IsEmail()
  email: string;

  @IsString()
  password: string;
}
