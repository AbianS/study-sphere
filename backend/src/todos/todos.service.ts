import { Injectable } from '@nestjs/common';
import { PrismaService } from 'prisma/prisma.service';
import { UserDTO } from 'src/auth/dto/classes/UserDTO';
import { CreateTodoDTO } from './dtos/create-todo.dto';

@Injectable()
export class TodosService {
  constructor(private readonly prisma: PrismaService) {}

  async getAllTodosById(user: UserDTO) {

    const todos = await this.prisma.todo.findMany({
      where: { userId: user.id },
      select: {
        id: true,
        title: true,
        execute_day: true,
        event_day: true,
        notification_time: true,
        completed: true,
      },
    });

    return todos;
  }

  async createTodo(user: UserDTO, createTodoDTO: CreateTodoDTO) {
    await this.prisma.todo.create({
      data: {
        title: createTodoDTO.title,
        execute_day: new Date(createTodoDTO.execute_day),
        notification_time: new Date(createTodoDTO.notification_time),
        event_day: new Date(createTodoDTO.event_day),
        userId: user.id,
      },
    });

    return;
  }

  async deleteTodo(user: UserDTO, id: string) {
    await this.prisma.todo.delete({
      where: { id: id },
    });

    return;
  }
}
