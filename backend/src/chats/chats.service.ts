import { Injectable } from '@nestjs/common';
import { PrismaService } from 'prisma/prisma.service';
import { Socket } from 'socket.io';
import { UserDTO } from 'src/auth/dto/classes/UserDTO';
import { FirebaseService } from 'src/firebase/firebase.service';
import { PushNotificationDTO } from '../firebase/dto/push-notification.dto';
import { MessageDto } from './dtos/message.dto';
import { User } from '@prisma/client';

interface ConnectedClients {
  [id: string]: {
    socket: Socket;
    user: User;
  };
}

@Injectable()
export class ChatsService {
  constructor(
    private prisma: PrismaService,
    private readonly firebaseService: FirebaseService,
  ) {}

  private connectedClients: ConnectedClients = {};

  async registerClient(client: Socket, userId: string) {
    const user = await this.prisma.user.findUnique({ where: { id: userId } });

    if (!user) throw new Error('User not found');

    this.connectedClients[client.id] = {
      socket: client,
      user: user,
    };
  }

  removeClient(ClientId: string) {
    delete this.connectedClients[ClientId];
  }

  async createMessage(payload: MessageDto) {
    
    const message = await this.prisma.message.create({
      data: {
        senderId: payload.from,
        reciberId: payload.to,
        content: payload.message,
      },
    });

    const notification: PushNotificationDTO = {
      userId: payload.to,
      title: 'Mensaje',
      body: payload.message,
      type: 'chat',
      typeId: payload.from,
    };

    await this.firebaseService.sendNotification(notification);

    return message;
  }

  async getMessageHistorial(user: UserDTO, messengerId: string) {
    const chats = await this.prisma.message.findMany({
      where: {
        OR: [
          { senderId: user.id, reciberId: messengerId },
          { senderId: messengerId, reciberId: user.id },
        ],
      },
      orderBy: {
        created_at: 'desc',
      },
    });

    return chats;
  }

  async getUserById(userId: string) {
    const user = await this.prisma.user.findUnique({
      where: {
        id: userId,
      },
      select: {
        id: true,
        avatar: true,
        name: true,
        surname: true,
        email: true,
      },
    });

    return user;
  }
}
