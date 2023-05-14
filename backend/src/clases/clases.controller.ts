import {
  Body,
  Controller,
  Get,
  Param,
  Post,
  Res,
  UploadedFiles,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { GetUser } from 'src/auth/decorators/get-user.decorator';
import { UserDTO } from 'src/auth/dto/classes/UserDTO';
import { ClasesService } from './clases.service';
import { CreateClaseDataIn } from './dto/dto/create-clase.dto';
import { CreateCommentDataIn } from './dto/dto/create-comment.dto';
import { JoinClaseDataIn } from './dto/dto/join-clase.dto';
import { ApiTags } from '@nestjs/swagger';
import { CreateTopicDataIn } from './dto/dto/create-topic';
import { CreateTaskDataIn } from './dto/dto/create-task.dto';
import { CreateMaterialDataIn } from './dto/dto/create-material.dto';
import { CreateQuestionDataIn } from './dto/dto/create-question.dto';
import { CreateAttendanceDataIn } from './dto/dto/create-attendane';
import { SolveTaskDataIn } from './dto/dto/solve-task';
import { Response } from 'express';
import { FilesInterceptor } from '@nestjs/platform-express';
import { CorrectTaskDTO } from './dto/dto/correct-task.dto';
import { CreateAnnotationDataIn } from './dto/dto/create-annotation';

@ApiTags('Clases')
@Controller('clases')
export class ClasesController {
  constructor(private readonly clasesService: ClasesService) {}

  // Create class
  @Post('create')
  @UseGuards(AuthGuard())
  createClass(
    @GetUser() user: UserDTO,
    @Body() createClaseDataIn: CreateClaseDataIn,
  ) {
    return this.clasesService.createClass(user, createClaseDataIn);
  }

  // Join class
  @Post('join')
  @UseGuards(AuthGuard())
  joinClass(
    @GetUser() user: UserDTO,
    @Body() joinClassDataIn: JoinClaseDataIn,
  ) {
    return this.clasesService.joinClass(user, joinClassDataIn);
  }

  // Get All class by user
  @Get()
  @UseGuards(AuthGuard())
  getUserClass(@GetUser() user: UserDTO) {
    return this.clasesService.getUserClass(user);
  }

  // get all students who are peers of a user
  @Get('chats')
  @UseGuards(AuthGuard())
  getChats(@GetUser() user: UserDTO) {
    return this.clasesService.getChats(user);
  }

  // get class by ID
  @Get(':id')
  @UseGuards(AuthGuard())
  findOne(@Param('id') id: string, @GetUser() user: UserDTO) {
    return this.clasesService.getClassById(id, user);
  }

  // Create comment
  @Post('comment')
  @UseInterceptors(FilesInterceptor('files'))
  @UseGuards(AuthGuard())
  createComment(
    @GetUser() user: UserDTO,
    @Body() createCommentDataIn: CreateCommentDataIn,
    @UploadedFiles() files: Array<Express.Multer.File>,
  ) {
    return this.clasesService.createComment(createCommentDataIn, user, files);
  }

  // Create a Topic
  @Post('topic')
  @UseGuards(AuthGuard())
  createTopic(
    @GetUser() user: UserDTO,
    @Body() createTopicDataIn: CreateTopicDataIn,
  ) {
    return this.clasesService.createTopic(createTopicDataIn, user);
  }

  // create a Task
  @Post('task')
  @UseGuards(AuthGuard())
  @UseInterceptors(FilesInterceptor('files'))
  createTask(
    @GetUser() user: UserDTO,
    @Body() createTaskDataIn: CreateTaskDataIn,
    @UploadedFiles() files: Array<Express.Multer.File>,
  ) {
    return this.clasesService.createTask(user, createTaskDataIn, files);
  }

  // GET ALL TOPICS
  @Get('topics/:classId')
  @UseGuards(AuthGuard())
  getAllTopics(@Param('classId') classId: string) {
    return this.clasesService.getAllTopics(classId);
  }

  // get taskUser by classId
  @Get('taskUser/:classId')
  @UseGuards(AuthGuard())
  getTaskUser(@Param('classId') taskId: string) {
    return this.clasesService.getTaskUser(taskId);
  }

  @Post('task/correct')
  @UseGuards(AuthGuard())
  correctTask(@Body() correctTaskDTO: CorrectTaskDTO) {
    return this.clasesService.correctTask(correctTaskDTO);
  }

  // solve a Task
  @Post('task/:id')
  @UseGuards(AuthGuard())
  @UseInterceptors(FilesInterceptor('files'))
  solveTask(
    @Param('id') id: string,
    @UploadedFiles() files: Array<Express.Multer.File>,
    @GetUser() user: UserDTO,
    @Body() solveTaskDataIn: SolveTaskDataIn,
  ) {
    return this.clasesService.solveTask(id, user, solveTaskDataIn, files);
  }

  @Get('task/:id')
  @UseGuards(AuthGuard())
  findTask(@Param('id') id: string, @GetUser() user: UserDTO) {
    return this.clasesService.getTaskById(id, user);
  }

  // create a material
  @Post('material')
  @UseGuards(AuthGuard())
  @UseInterceptors(FilesInterceptor('files'))
  createMaterial(
    @GetUser() user: UserDTO,
    @Body() createMaterialDataIn: CreateMaterialDataIn,
    @UploadedFiles() files: Array<Express.Multer.File>,
  ) {
    return this.clasesService.createMaterial(user, createMaterialDataIn, files);
  }

  // create a question
  @Post('question')
  @UseGuards(AuthGuard())
  createQuestion(
    @GetUser() user: UserDTO,
    @Body() createQuestionDataIn: CreateQuestionDataIn,
  ) {
    return this.clasesService.createQuetion(user, createQuestionDataIn);
  }

  // create attendance class
  @Post('attendance/:id')
  @UseGuards(AuthGuard())
  createAttendance(
    @GetUser() user: UserDTO,
    @Param('id') id: string,
    @Body() createAttendanceDataIn: CreateAttendanceDataIn[],
  ) {
    return this.clasesService.createAttendance(
      user,
      id,
      createAttendanceDataIn,
    );
  }

  @Post('annotation')
  @UseGuards(AuthGuard())
  createAnnotation(
    @GetUser() user: UserDTO,
    @Body() createAnnotationDataIn: CreateAnnotationDataIn,
  ) {
    return this.clasesService.createAnnotation(user, createAnnotationDataIn);
  }
}
