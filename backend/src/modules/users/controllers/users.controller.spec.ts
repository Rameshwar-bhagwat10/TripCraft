import { Test, TestingModule } from '@nestjs/testing';
import { UsersController } from './users.controller';
import { UsersService } from '../services/users.service';
import { ConfigService } from '@nestjs/config';

describe('UsersController', () => {
  let controller: UsersController;
  let service: UsersService;

  const mockUsersService = {
    getProfile: jest.fn(),
    updatePreferences: jest.fn(),
  };

  const mockConfigService = {
    get: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [UsersController],
      providers: [
        { provide: UsersService, useValue: mockUsersService },
        { provide: ConfigService, useValue: mockConfigService },
      ],
    }).compile();

    controller = module.get<UsersController>(UsersController);
    service = module.get<UsersService>(UsersService);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  it('getProfile should call service.getProfile', async () => {
    const user = { id: 'uuid-1', email: 'test@example.com' };
    mockUsersService.getProfile.mockResolvedValue({ id: 'uuid-1', email: 'test@example.com' });

    const result = await controller.getProfile(user);
    expect(result).toEqual({ id: 'uuid-1', email: 'test@example.com' });
    expect(service.getProfile).toHaveBeenCalledWith(user);
  });
});
