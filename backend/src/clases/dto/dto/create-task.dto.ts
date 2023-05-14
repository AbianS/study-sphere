import { ApiProperty } from '@nestjs/swagger';
import { IsDateString, IsOptional, IsString } from 'class-validator';

export class CreateTaskDataIn {
  @ApiProperty()
  @IsString()
  title: string;

  @ApiProperty()
  @IsString()
  classId: string;

  @ApiProperty()
  @IsString()
  topicId: string;

  @ApiProperty()
  @IsOptional()
  @IsString()
  description?: string;

  @ApiProperty()
  @IsOptional()
  @IsDateString()
  dueDate?: Date;

  @ApiProperty()
  @IsOptional()
  @IsString()
  score?: string;
}
