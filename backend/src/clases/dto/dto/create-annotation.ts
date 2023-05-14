import { IsEnum, IsString } from 'class-validator';

export enum AnnotationType {
  COMMENT = 'COMMENT',
  TASK = 'TASK',
  MATERIAL = 'MATERIAL',
  QUESTION = 'QUESTION',
}

export class CreateAnnotationDataIn {
  @IsString()
  id: string;

  @IsEnum(AnnotationType)
  type: AnnotationType;

  @IsString()
  text: string;
}
