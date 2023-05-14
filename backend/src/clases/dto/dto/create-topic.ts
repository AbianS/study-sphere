import { ApiProperty } from '@nestjs/swagger';
import { IsString } from 'class-validator';

export class CreateTopicDataIn {
  @ApiProperty()
  @IsString()
  title: string;
  @ApiProperty()
  @IsString()
  claseId: string;
}
