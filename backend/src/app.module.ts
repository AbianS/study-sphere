import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { ChatsModule } from './chats/chats.module';
import { ClasesModule } from './clases/clases.module';
import { FirebaseModule } from './firebase/firebase.module';
import { MailModule } from './mail/mail.module';
import { TodosModule } from './todos/todos.module';

@Module({
  imports: [
    AuthModule,
    ConfigModule.forRoot(),
    ClasesModule,
    ChatsModule,
    TodosModule,
    FirebaseModule,
    FirebaseModule,
    MailModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
