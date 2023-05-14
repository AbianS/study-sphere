import { ApiProperty } from '@nestjs/swagger';
import { IsString } from 'class-validator';

export class CreateClaseDataIn {
  @ApiProperty()
  @IsString()
  title: string;

  @ApiProperty()
  @IsString()
  description: string;
}

export class CreateClassDataOut {
  @ApiProperty()
  title: string;
  @ApiProperty()
  description: string;
  @ApiProperty()
  teacherId: string;
}
