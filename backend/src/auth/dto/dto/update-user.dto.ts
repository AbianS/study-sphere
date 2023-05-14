import { IsOptional, IsString } from 'class-validator';

export class UpdateUserDTO {
  @IsOptional()
  @IsString()
  name: string;
  @IsOptional()
  @IsString()
  surname: string;
  @IsOptional()
  @IsString()
  phone: string;
}
