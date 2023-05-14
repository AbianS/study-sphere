import { ApiProperty } from '@nestjs/swagger';
import { IsBoolean, IsString } from 'class-validator';

export class CreateAttendanceDataIn {
  @ApiProperty()
  @IsString()
  studentId: string;

  @ApiProperty()
  @IsBoolean()
  attendance: boolean;
}
