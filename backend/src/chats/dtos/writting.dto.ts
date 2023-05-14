import { IsString } from 'class-validator';

export class WrittingDTO {
  @IsString()
  to: string;
}
