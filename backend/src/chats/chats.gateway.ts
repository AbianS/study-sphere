import {
  OnGatewayConnection,
  OnGatewayDisconnect,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { ChatsService } from './chats.service';
import { Server, Socket } from 'socket.io';
import { JwtService } from '@nestjs/jwt';
import { JwtPayload } from 'src/auth/interfaces/jwt-payload.interface';
import { MessageDto } from './dtos/message.dto';
import { WrittingDTO } from './dtos/writting.dto';

@WebSocketGateway({ cors: true, namespace: 'chats' })
export class ChatsGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer() wss: Server;

  constructor(
    private readonly chatsService: ChatsService,
    private readonly jwtService: JwtService,
  ) {}

  async handleConnection(client: Socket) {
    console.log('CLIENTE CONECTADO');
    const token = client.handshake.headers.authentication as string;

    let payload: JwtPayload;

    try {
      payload = this.jwtService.verify(token);

      client.join(payload.id);
    } catch (error) {
      client.disconnect();
      return;
    }
  }

  handleDisconnect(client: Socket) {
    console.log('CLIENTE DESCONECTADO');
    this.chatsService.removeClient(client.id);
  }

  @SubscribeMessage('mensaje-personal')
  async onMessageFromClient(client: Socket, payload: MessageDto) {
    const message = await this.chatsService.createMessage(payload);
    this.wss.to(payload.to).emit('mensaje-personal', {
      from: payload.from,
      to: payload.to,
      message: payload.message,
      date: message.created_at,
    });
  }

  @SubscribeMessage('writting')
  async onWrittingChat(client: Socket, payload: WrittingDTO) {
    // console.log(to);

    this.wss.to(payload.to).emit('writting', { to: payload.to });
  }
}
