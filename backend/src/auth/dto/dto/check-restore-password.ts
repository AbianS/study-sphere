import { IsEmail, IsString } from 'class-validator';

export class CheckRestorePasswordDataIn {
  @IsEmail()
  email: string;

  @IsString()
  code: string;
}
