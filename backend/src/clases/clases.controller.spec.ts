import { Test, TestingModule } from '@nestjs/testing';
import { ClasesController } from './clases.controller';
import { ClasesService } from './clases.service';

describe('ClasesController', () => {
  let controller: ClasesController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [ClasesController],
      providers: [ClasesService],
    }).compile();

    controller = module.get<ClasesController>(ClasesController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
