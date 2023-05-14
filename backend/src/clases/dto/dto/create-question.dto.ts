import { ApiProperty } from '@nestjs/swagger';
import {
  IsDate,
  IsInt,
  IsOptional,
  IsPositive,
  IsString,
} from 'class-validator';

export class CreateQuestionDataIn {
  @ApiProperty()
  @IsString()
  question: string;

  @ApiProperty()
  @IsOptional()
  @IsInt()
  @IsPositive()
  score?: number;

  @ApiProperty()
  @IsString()
  topicId: string;

  @ApiProperty()
  @IsOptional()
  @IsDate()
  dueDate?: Date;

  @ApiProperty()
  @IsString()
  claseId: string;
}
