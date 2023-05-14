import { ApiProperty } from '@nestjs/swagger';
import { IsDateString, IsString } from 'class-validator';

export class CreateTodoDTO {
  @ApiProperty()
  @IsString()
  title: string;

  @ApiProperty()
  @IsDateString()
  execute_day: Date;

  @ApiProperty()
  @IsDateString()
  event_day: Date;

  @ApiProperty()
  @IsDateString()
  notification_time: Date;
}
