import { IsEmail } from 'class-validator';

export class RestorePasswordDataIn {
  @IsEmail()
  email: string;
}
