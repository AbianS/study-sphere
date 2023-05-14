import { IsNumber, IsString } from 'class-validator';

export class CorrectTaskDTO {
  @IsString()
  userId: string;
  @IsString()
  taskId: string;
  @IsNumber()
  grade: number;
}
