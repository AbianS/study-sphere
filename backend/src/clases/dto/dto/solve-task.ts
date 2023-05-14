import { ApiProperty } from '@nestjs/swagger';
import { IsOptional, IsString } from 'class-validator';

export class SolveTaskDataIn {
  @ApiProperty()
  @IsOptional()
  @IsString()
  answer: string;
}
