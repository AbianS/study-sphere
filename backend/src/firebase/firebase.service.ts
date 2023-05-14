import { Injectable } from '@nestjs/common';

import * as admin from 'firebase-admin';
import { PrismaService } from 'prisma/prisma.service';
import * as serviceAccount from '../../study-sphere-google-service.json';
import { PushNotificationDTO } from './dto/push-notification.dto';
import { v4 as uuid } from 'uuid';
import { User } from '@prisma/client';

@Injectable()
export class FirebaseService {
  constructor(private prisma: PrismaService) {
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount as admin.ServiceAccount),
      storageBucket: 'gs://study-sphere-d9642.appspot.com/',
    });
  }

  async sendNotification(pushNotificationDTO: PushNotificationDTO) {
    const user = await this.prisma.user.findUnique({
      where: { id: pushNotificationDTO.userId },
    });

    let sender: User;
    if (pushNotificationDTO.type === 'chat') {
      sender = await this.prisma.user.findUnique({
        where: { id: pushNotificationDTO.typeId },
      });
    }

    const payload = {
      notification: {
        title:
          pushNotificationDTO.type === 'chat'
            ? sender.name
            : pushNotificationDTO.title,
        body: pushNotificationDTO.body,
      },
      data: {
        type: pushNotificationDTO.type,
        id: pushNotificationDTO.typeId,
      },
      tokens: user.notifications_token,
    };

    Promise.all([await admin.messaging().sendEachForMulticast(payload)]);
  }

  async uploadFile(
    files: Express.Multer.File | Array<Express.Multer.File>,
  ): Promise<Array<string>> {
    const bucket = admin.storage().bucket();

    // Si solo se recibe un archivo, se coloca en un arreglo para que se maneje de forma uniforme
    if (!Array.isArray(files)) {
      files = [files];
    }

    // Map para manejar la subida de todos los archivos simultáneamente
    const uploadPromises = files.map((file) => {
      const { originalname } = file;

      const fileName = `${uuid()}.${originalname.split('.').pop()}`;
      const fileUpload = bucket.file(fileName);

      const stream = fileUpload.createWriteStream({
        metadata: {
          contentType: file.mimetype,
        },
      });

      return new Promise<string>((resolve, reject) => {
        stream
          .on('finish', async () => {
            await fileUpload.makePublic();
            const publicUrl = `https://storage.googleapis.com/${bucket.name}/${fileName}`;
            resolve(publicUrl);
          })
          .on('error', reject)
          .end(file.buffer);
      });
    });

    // Esperar que se suban todos los archivos y devolver un arreglo con las URL públicas
    return Promise.all(uploadPromises);
  }

  async getFiles() {
    const bucket = admin.storage().bucket();
    const [files] = await bucket.getFiles();
    const structure = {};

    for (const file of files) {
      const subpath = file.name.replace(/\/$/, ''); // Remove trailing slash
      const parts = subpath.split('/');

      // Traverse the structure object and create sub-objects if needed
      let current = structure;
      for (const part of parts) {
        if (!current[part]) {
          current[part] = {};
        }
        current = current[part];
      }

      // If the path ends with a file name, add its URL to the final object
      if (!file.name.endsWith('/')) {
        const [url] = await file.getSignedUrl({
          action: 'read',
          expires: '03-17-2025',
        });
        current[parts[parts.length - 1]] = url;
      }
    }

    return { structure };
  }

  async getRandomBgImage() {
    const bucket = admin.storage().bucket();
    const [files] = await bucket.getFiles({
      prefix: 'bg-class/',
    });

    const randomIndex = Math.floor(Math.floor(Math.random() * files.length));
    const file = files[randomIndex];

    return `https://storage.googleapis.com/${bucket.name}/${file.name}`;
  }
}
