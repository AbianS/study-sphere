import { ApiProperty } from '@nestjs/swagger';
import { IsString } from 'class-validator';

export class JoinClaseDataIn {
  @ApiProperty()
  @IsString()
  classId: string;
}
