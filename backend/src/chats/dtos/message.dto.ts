import { IsString } from 'class-validator';

export class MessageDto {
  @IsString()
  from: string;
  @IsString()
  to: string;
  @IsString()
  message: string;
}
