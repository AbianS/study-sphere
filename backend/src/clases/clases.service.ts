import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import * as htmlPdf from 'html-pdf-node';
import { PrismaService } from 'prisma/prisma.service';
import { UserDTO } from 'src/auth/dto/classes/UserDTO';
import { FirebaseService } from 'src/firebase/firebase.service';
import { CorrectTaskDTO } from './dto/dto/correct-task.dto';
import {
  AnnotationType,
  CreateAnnotationDataIn,
} from './dto/dto/create-annotation';
import { CreateAttendanceDataIn } from './dto/dto/create-attendane';
import {
  CreateClaseDataIn,
  CreateClassDataOut,
} from './dto/dto/create-clase.dto';
import { CreateCommentDataIn } from './dto/dto/create-comment.dto';
import { CreateMaterialDataIn } from './dto/dto/create-material.dto';
import { CreateQuestionDataIn } from './dto/dto/create-question.dto';
import { CreateTaskDataIn } from './dto/dto/create-task.dto';
import { CreateTopicDataIn } from './dto/dto/create-topic';
import { JoinClaseDataIn } from './dto/dto/join-clase.dto';
import { SolveTaskDataIn } from './dto/dto/solve-task';

import { Readable } from 'stream';

@Injectable()
export class ClasesService {
  constructor(
    private prisma: PrismaService,
    private readonly firebaseService: FirebaseService,
  ) {}

  // Create a class
  async createClass(
    user: UserDTO,
    createClaseDataIn: CreateClaseDataIn,
  ): Promise<CreateClassDataOut> {
    try {
      //TODO: validar si se repite el codigo volver a generar CODE --> 'P2002'

      const bg = await this.firebaseService.getRandomBgImage();

      const clase = await this.prisma.clase.create({
        data: {
          ...createClaseDataIn,
          id: this.generateCode(),
          bg: bg,
          teacher: {
            connect: { id: user.id },
          },
        },
      });
      
      delete clase.created_at;
      delete clase.updated_at;
      delete clase.deleted;

      return clase;
    } catch (error) {
      throw new InternalServerErrorException();
    }
  }

  async joinClass(user: UserDTO, joinClaseDataIn: JoinClaseDataIn) {
    const clase = await this.prisma.clase.findFirst({
      where: { id: joinClaseDataIn.classId },
    });

    if (!clase)
      throw new NotFoundException(
        `Class with id: ${joinClaseDataIn.classId} not found`,
      );

    if (clase.teacherId === user.id) {
      throw new BadRequestException('The teacher cant join');
    }

    try {
      await this.prisma.userClase.create({
        data: {
          user: { connect: { id: user.id } },
          clase: { connect: { id: joinClaseDataIn.classId } },
        },
      });
    } catch (error) {
      if (error.code === 'P2002') {
        throw new BadRequestException(`The user has already in this class`);
      }

      throw new InternalServerErrorException();
    }

    // join user in all task
    const tasks = await this.prisma.task.findMany({
      where: { claseId: clase.id },
    });

    for (const task of tasks) {
      await this.prisma.taskUser.create({
        data: {
          userId: user.id,
          taskId: task.id,
        },
      });
    }

    
    const updatedClass = await this.prisma.clase.findFirst({
      where: { id: joinClaseDataIn.classId },
      include: {
        teacher: {
          select: {
            id: true,
            name: true,
            email: true,
          },
        },
        students: {
          where: {
            NOT: {
              userId: user.id,
            },
          },
          select: {
            user: {
              select: {
                id: true,
                name: true,
                email: true,
              },
            },
          },
        },
      },
    });

    // studen list to email and name
    const studentsList = updatedClass.students.map((student) => ({
      name: student.user.name,
      email: student.user.email,
    }));

    return {
      id: updatedClass.id,
      title: updatedClass.title,
      description: updatedClass.description,
      teacher: updatedClass.teacher,
      students: studentsList,
    };
  }

  async getUserClass(user: UserDTO) {
    const classes = await this.prisma.clase.findMany({
      where: {
        OR: [
          { students: { some: { userId: user.id } } },
          { teacherId: user.id },
        ],
        deleted: null,
      },
      select: {
        id: true,
        title: true,
        description: true,
        bg: true,
        students: { select: { user: { select: { name: true, email: true } } } },
        teacherId: true,
        teacher: { select: { name: true, email: true, surname: true } },
      },
    });

    return classes.map((clase) => {
      const result: any = {
        id: clase.id,
        title: clase.title,
        description: clase.description,
        students: clase.students.length,
        bg: clase.bg,
      };
      if (user.id !== clase.teacherId) {
        result.teacherName = `${clase.teacher.name} ${clase.teacher.surname} `;
      }
      return result;
    });
  }

  async getClassById(id: string, user: UserDTO) {
    const clase = await this.prisma.clase.findFirst({
      where: { id: id },
      include: {
        Topic: {
          orderBy: {
            created_at: 'desc',
          },
          select: {
            id: true,
            title: true,
            Material: {
              select: {
                id: true,
                title: true,
                description: true,
                files: true,
                annotations: {
                  select: {
                    id: true,
                    text: true,
                    created_at: true,
                    user: {
                      select: {
                        name: true,
                        avatar: true,
                      },
                    },
                  },
                },
                topicId: true,
                claseId: true,
                created_at: true,
              },
            },
            Question: {
              select: {
                id: true,
                question: true,
                score: true,
                topicId: true,
                annotations: {
                  select: {
                    id: true,
                    text: true,
                    created_at: true,
                    user: {
                      select: {
                        name: true,
                        avatar: true,
                      },
                    },
                  },
                },
                dueDate: true,
                created_at: true,
                QuestionUser: {
                  where: {
                    userId: user.id,
                  },
                  select: {
                    completed: true,
                  },
                },
              },
            },
            Task: {
              select: {
                id: true,
                title: true,
                description: true,
                dueDate: true,
                topicId: true,
                score: true,
                annotations: {
                  select: {
                    id: true,
                    text: true,
                    created_at: true,
                    user: {
                      select: {
                        name: true,
                        avatar: true,
                      },
                    },
                  },
                },
                claseId: true,
                files: true,
                created_at: true,
                TaskUser: {
                  where: {
                    userId: user.id,
                  },
                  select: {
                    files: true,
                    completed: true,
                  },
                },
              },
            },
          },
        },
        students: {
          select: {
            user: true,
          },
        },
        teacher: {
          select: {
            id: true,
            email: true,
            name: true,
            avatar: true,
          },
        },
        comments: {
          orderBy: {
            created_at: 'desc',
          },
          select: {
            id: true,
            text: true,
            created_at: true,
            updated_at: true,
            annotations: {
              select: {
                id: true,
                text: true,
                created_at: true,
                user: {
                  select: {
                    name: true,
                    avatar: true,
                  },
                },
              },
            },
            files: true,
            user: {
              select: {
                name: true,
                surname: true,
                avatar: true,
              },
            },
          },
        },
      },
    });

    if (!clase) throw new NotFoundException(`Class with id: ${id} not found`);

    const studentsList = clase.students
      .filter((student) => student.user.id !== user.id) // se filtran aquellos estudiantes cuyo id no sea el que hizo la request
      .map((student) => ({
        name: student.user.name,
        email: student.user.email,
        avatar: student.user.avatar,
      }));

    return {
      id: clase.id,
      title: clase.title,
      description: clase.description,
      students: studentsList,
      bg: clase.bg,
      teacher: {
        name: clase.teacher.name,
        mail: clase.teacher.email,
        avatar: clase.teacher.avatar,
      },
      topic: clase.Topic,
      comments: clase.comments,
      role: user.id === clase.teacherId ? 'teacher' : 'student',
    };
  }

  async createComment(
    createCommentDataIn: CreateCommentDataIn,
    user: UserDTO,
    files: Array<Express.Multer.File>,
  ) {
    //TODO: Asegurarse que el usuario pertenece a esa clase
    const clase = await this.prisma.clase.findFirst({
      where: { id: createCommentDataIn.claseId },
    });

    if (!clase) {
      throw new NotFoundException(
        `Class with id: ${createCommentDataIn.claseId} not found`,
      );
    }

    let filesUrl: string[] = [];

    if (files && files.length > 0) {
      filesUrl = await this.firebaseService.uploadFile(files);
    }

    try {
      await this.prisma.comment.create({
        data: {
          claseId: createCommentDataIn.claseId,
          userId: user.id,
          text: createCommentDataIn.text,
          files: filesUrl,
        },
      });
    } catch (e) {}

    return {
      message: 'Comment created',
    };
  }

  async getTaskUser(taskId: string) {
    
    const taskUser = await this.prisma.taskUser.findMany({
      where: { taskId: taskId },
      select: {
        id: true,
        files: true,
        grade: true,
        task: {
          select: {
            id: true,
            score: true,
            title: true,
            description: true,
          },
        },
        completed: true,
        user: {
          select: {
            id: true,
            name: true,
            surname: true,
            email: true,
            avatar: true,
          },
        },
      },
    });

    return taskUser;
  }

  async createTopic(createTopicDataIn: CreateTopicDataIn, user: UserDTO) {
    const clase = await this.prisma.clase.findFirst({
      where: { id: createTopicDataIn.claseId },
    });

    if (!clase) throw new NotFoundException('class not exist');

    if (clase.teacherId !== user.id)
      throw new BadRequestException('No eres el profesor');

    await this.prisma.topic.create({
      data: {
        title: createTopicDataIn.title,
        claseId: createTopicDataIn.claseId,
      },
    });

    return;
  }

  async createTask(
    user: UserDTO,
    createTaskDataIn: CreateTaskDataIn,
    files: Express.Multer.File[],
  ) {
    const clase = await this.prisma.clase.findFirst({
      where: {
        id: createTaskDataIn.classId,
      },
      include: {
        students: {
          select: {
            userId: true,
          },
        },
      },
    });

    if (!clase) throw new NotFoundException('class not found');

    if (clase.teacherId !== user.id) {
      throw new BadRequestException("you aren't teacher");
    }

    let filesUrl: string[] = [];

    if (files && files.length > 0) {
      filesUrl = await this.firebaseService.uploadFile(files);
    }

    try {
      const task = await this.prisma.task.create({
        data: {
          title: createTaskDataIn.title,
          claseId: createTaskDataIn.classId,
          description: createTaskDataIn.description,
          topicId: createTaskDataIn.topicId,
          score: Number.parseInt(createTaskDataIn.score),
          dueDate: new Date(createTaskDataIn.dueDate),
          files: filesUrl,
        },
      });

      for (const student of clase.students) {
        await this.prisma.taskUser.create({
          data: {
            userId: student.userId,
            taskId: task.id,
          },
        });
      }
    } catch (error) {
      console.log(error);

      if (error.code === 'P2003') {
        throw new NotFoundException('Topic Id not found');
      }
    }
  }

  async correctTask(correctTaskDTO: CorrectTaskDTO) {
    await this.prisma.taskUser.update({
      where: {
        userId_taskId: {
          taskId: correctTaskDTO.taskId,
          userId: correctTaskDTO.userId,
        },
      },
      data: {
        grade: correctTaskDTO.grade,
      },
    });

    return;
  }

  async getAllTopics(classId: string) {
    const topics = await this.prisma.clase.findUnique({
      where: { id: classId },
      select: {
        Topic: {
          select: {
            id: true,
            title: true,
          },
        },
      },
    });

    return topics.Topic;
  }

  async solveTask(
    taskId: string,
    user: UserDTO,
    solveTaskDataIn: SolveTaskDataIn,
    files: Array<Express.Multer.File>,
  ) {
    const task = await this.prisma.task.findFirst({
      where: { id: taskId },
    });

    if (!task) throw new NotFoundException('task not found');

    if (solveTaskDataIn.answer) {
      const pdf = await this.createPdf(solveTaskDataIn.answer, user);
      let pdfData = Buffer.alloc(0);

      pdf.on('data', (chunk) => {
        pdfData = Buffer.concat([pdfData, chunk]);
      });

      pdf.on('end', () => {
        const file: Express.Multer.File = {
          fieldname: 'pdfFile',
          originalname: 'documento.pdf',
          mimetype: 'application/pdf',
          buffer: pdfData,
          size: pdfData.length,
          encoding: '',
          stream: pdf,
          destination: '',
          filename: 'documento.pdf',
          path: '',
        };
        files.push(file);
      });
    }
    // const pdf = await this.createPdf(solveTaskDataIn.answer, user, task);

    const filesUrl = await this.firebaseService.uploadFile(files);

    await this.prisma.taskUser.update({
      where: {
        userId_taskId: {
          userId: user.id,
          taskId,
        },
      },
      data: {
        files: { push: filesUrl },
        completed: true,
      },
    });
  }

  async getTaskById(taskId: string, user: UserDTO) {
    const task = await this.prisma.task.findFirst({
      where: { id: taskId },
      select: {
        id: true,
        title: true,
        description: true,
        dueDate: true,
        topicId: true,
        score: true,
        files: true,
        annotations: {
          select: {
            id: true,
            text: true,
            created_at: true,
            user: {
              select: {
                name: true,
                avatar: true,
              },
            },
          },
        },
        claseId: true,
        created_at: true,
        TaskUser: {
          where: {
            userId: user.id,
          },
          select: {
            completed: true,
            files: true,
          },
        },
      },
    });

    if (!task) throw new NotFoundException('task not found');

    return task;
  }

  async createMaterial(
    user: UserDTO,
    createMaterialDataIn: CreateMaterialDataIn,
    files: Express.Multer.File[],
  ) {
    const clase = await this.prisma.clase.findFirst({
      where: {
        id: createMaterialDataIn.claseId,
      },
    });

    if (!clase) throw new NotFoundException('class not found');

    if (clase.teacherId !== user.id) {
      throw new BadRequestException("you aren't teacher");
    }

    let filesUrl: string[] = [];

    if (files && files.length > 0) {
      filesUrl = await this.firebaseService.uploadFile(files);
    }

    try {
      await this.prisma.material.create({
        data: {
          title: createMaterialDataIn.title,
          description: createMaterialDataIn.description,
          files: filesUrl,
          claseId: createMaterialDataIn.claseId,
          topicId: createMaterialDataIn.topicId,
        },
      });
    } catch (error) {
      if (error.code === 'P2003') {
        throw new NotFoundException('Topic Id not found');
      }
    }
  }

  async createQuetion(
    user: UserDTO,
    createQuestionDataIn: CreateQuestionDataIn,
  ) {
    const clase = await this.prisma.clase.findFirst({
      where: {
        id: createQuestionDataIn.claseId,
      },
      include: {
        students: {
          select: {
            userId: true,
          },
        },
      },
    });

    if (!clase) throw new NotFoundException('class not found');

    if (clase.teacherId !== user.id) {
      throw new BadRequestException("you aren't teacher");
    }

    try {
      const question = await this.prisma.question.create({
        data: {
          question: createQuestionDataIn.question,
          claseId: createQuestionDataIn.claseId,
          score: createQuestionDataIn.score,
          topicId: createQuestionDataIn.topicId,
        },
      });

      for (const student of clase.students) {
        await this.prisma.questionUser.create({
          data: {
            userId: student.userId,
            questionId: question.id,
          },
        });
      }
    } catch (error) {
      if (error.code === 'P2003') {
        throw new NotFoundException('Topic Id not found');
      }
    }
  }

  async createAttendance(
    user: UserDTO,
    claseId: string,
    createAttendanceDataIn: CreateAttendanceDataIn[],
  ) {
    //TODO: faltan muchas validaciones
    const clase = await this.prisma.clase.findFirst({
      where: { id: claseId },
    });

    if (!clase) throw new NotFoundException('class not found');

    if (clase.teacherId !== user.id) {
      throw new BadRequestException("you aren't teacher");
    }

    const currentDate = new Date();

    for (const attendance of createAttendanceDataIn) {
      await this.prisma.attendance.create({
        data: {
          claseId: claseId,
          attendance: attendance.attendance,
          studentId: attendance.studentId,
          date: currentDate,
        },
      });
    }
  }

  private generateCode(): string {
    const characters =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    let code = '';

    while (code.length < 7) {
      const randomIndex = Math.floor(Math.random() * characters.length);
      const randomChar = characters.charAt(randomIndex);
      code += randomChar;
    }

    if (!/\d/.test(code)) {
      const randomIndex = Math.floor(Math.random() * 7);
      const randomNumber = Math.floor(Math.random() * 10);
      code =
        code.slice(0, randomIndex) + randomNumber + code.slice(randomIndex + 1);
    }

    return code;
  }

  async getChats(user: UserDTO) {
    const students = await this.prisma.userClase.findMany({
      where: {
        NOT: {
          userId: user.id,
        },
        clase: { students: { some: { userId: user.id } } },
      },
      select: {
        user: {
          select: {
            id: true,
            avatar: true,
            name: true,
            surname: true,
            email: true,
          },
        },
      },
    });
    return students.map((student) => student.user);
  }

  private async createPdf(html: string, user: UserDTO): Promise<Readable> {
    const pdfStream = new Readable();
    await new Promise((resolve, reject) => {
      const header = `<style>p{text-align: left !important; font-size: 10px !important}</style><p style="margin-left: 10px !important">${user.name} ${user.surname}</p>`;

      htmlPdf.generatePdf(
        { content: html },
        {
          format: 'A4',
          preferCSSPageSize: true,
          displayHeaderFooter: true,
          headerTemplate: header,
          footerTemplate:
            '<style>span{text-align: right !important; width:90% !important; font-size:10px !important;}</style><span><label class="pageNumber"></label> / <label class="totalPages"> </label> </span>',
          margin: {
            top: '60px',
            bottom: '50px',
            right: '20px',
            left: '20px',
          },
        },
        (error, result) => {
          if (error) {
            reject(error);
          } else {
            pdfStream.push(result);
            pdfStream.push(null);

            resolve(null);
          }
        },
      );
    });

    return pdfStream;
  }

  async createAnnotation(
    user: UserDTO,
    createAnnotationDataIn: CreateAnnotationDataIn,
  ) {
    try {
      const annotation = await this.prisma.annotation.create({
        data: { text: createAnnotationDataIn.text, userId: user.id },
      });

      switch (createAnnotationDataIn.type) {
        case AnnotationType.COMMENT:
          await this.prisma.comment.update({
            where: { id: createAnnotationDataIn.id },
            data: { annotations: { connect: { id: annotation.id } } },
          });
          return;
        case AnnotationType.MATERIAL:
          await this.prisma.material.update({
            where: { id: createAnnotationDataIn.id },
            data: { annotations: { connect: { id: annotation.id } } },
          });
          return;
        case AnnotationType.QUESTION:
          await this.prisma.question.update({
            where: { id: createAnnotationDataIn.id },
            data: { annotations: { connect: { id: annotation.id } } },
          });
          return;
        case AnnotationType.TASK:
          await this.prisma.task.update({
            where: { id: createAnnotationDataIn.id },
            data: { annotations: { connect: { id: annotation.id } } },
          });
          return;
      }
    } catch (error) {
      throw new InternalServerErrorException();
    }
  }
}
