import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Post,
  UseGuards,
} from '@nestjs/common';
import { TodosService } from './todos.service';
import { AuthGuard } from '@nestjs/passport';
import { GetUser } from 'src/auth/decorators/get-user.decorator';
import { UserDTO } from 'src/auth/dto/classes/UserDTO';
import { CreateTodoDTO } from './dtos/create-todo.dto';

@Controller('todos')
export class TodosController {
  constructor(private readonly todosService: TodosService) {}

  @Get()
  @UseGuards(AuthGuard())
  getAllTaskById(@GetUser() user: UserDTO) {
    return this.todosService.getAllTodosById(user);
  }

  @Post()
  @UseGuards(AuthGuard())
  createTodo(@GetUser() user: UserDTO, @Body() createTodoDTO: CreateTodoDTO) {
    return this.todosService.createTodo(user, createTodoDTO);
  }

  @Delete(':id')
  @UseGuards(AuthGuard())
  deleteTodo(@GetUser() user: UserDTO, @Param('id') id: string) {
    return this.todosService.deleteTodo(user, id);
  }
}
