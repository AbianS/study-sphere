import { ApiProperty } from '@nestjs/swagger';
import { IsString } from 'class-validator';

export class CreateCommentDataIn {
  @ApiProperty()
  @IsString()
  claseId: string;
  @ApiProperty()
  @IsString()
  text: string;
}
