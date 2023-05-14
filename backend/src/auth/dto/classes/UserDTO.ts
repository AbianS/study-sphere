import { ApiProperty } from '@nestjs/swagger';
import { User } from '@prisma/client';

export class UserDTO implements User {
  @ApiProperty()
  id: string;
  @ApiProperty()
  name: string;
  @ApiProperty()
  surname: string;
  @ApiProperty()
  phone: string;
  @ApiProperty()
  email: string;
  @ApiProperty()
  password: string;
  @ApiProperty()
  created_at: Date;
  @ApiProperty()
  avatar: string;
  @ApiProperty()
  notifications_token: string[];
  @ApiProperty()
  updated_at: Date;
  @ApiProperty()
  deleted: Date;
}
