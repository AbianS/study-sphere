import {
  Controller,
  Get,
  Param,
  ParseUUIDPipe,
  UseGuards,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { GetUser } from 'src/auth/decorators/get-user.decorator';
import { UserDTO } from 'src/auth/dto/classes/UserDTO';
import { ChatsService } from './chats.service';

@Controller('chats')
export class ChatsController {
  constructor(private readonly chatsService: ChatsService) {}

  @Get('/:id')
  @UseGuards(AuthGuard())
  prueba(@Param('id') id: string, @GetUser() user: UserDTO) {
    return this.chatsService.getMessageHistorial(user, id);
  }

  @Get('user/:id')
  getById(@Param('id', ParseUUIDPipe) id: string) {
    return this.chatsService.getUserById(id);
  }
}
