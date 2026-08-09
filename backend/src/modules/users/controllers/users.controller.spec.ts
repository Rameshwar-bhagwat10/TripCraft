import { Test, TestingModule } from "@nestjs/testing";
import { UsersController } from "./users.controller";
import { UsersService } from "../services/users.service";
import { ConfigService } from "@nestjs/config";

describe("UsersController", () => {
  let controller: UsersController;
  let service: UsersService;

  const mockUsersService = {
    getProfile: jest.fn(),
    updateProfile: jest.fn(),
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

  it("should be defined", () => {
    expect(controller).toBeDefined();
  });

  it("getProfile should call service.getProfile", async () => {
    const user = { id: "uuid-1", email: "test@example.com" };
    mockUsersService.getProfile.mockResolvedValue({
      id: "uuid-1",
      email: "test@example.com",
    });

    const result = await controller.getProfile(user);
    expect(result).toEqual({ id: "uuid-1", email: "test@example.com" });
    expect(service.getProfile).toHaveBeenCalledWith(user);
  });

  it("updateProfile should call service.updateProfile", async () => {
    const user = { id: "uuid-1", email: "test@example.com" };
    const dto = { fullName: "Jane Doe", language: "en", currency: "USD" };
    mockUsersService.updateProfile.mockResolvedValue({
      id: "uuid-1",
      fullName: "Jane Doe",
    });

    const result = await controller.updateProfile(user, dto);
    expect(result).toEqual({ id: "uuid-1", fullName: "Jane Doe" });
    expect(service.updateProfile).toHaveBeenCalledWith(user, dto);
  });

  it("updatePreferences should call service.updatePreferences", async () => {
    const user = { id: "uuid-1", email: "test@example.com" };
    const dto = {
      travelStyles: ["Adventure"],
      budgetLevel: "Luxury",
      reducedMotion: true,
    };
    mockUsersService.updatePreferences.mockResolvedValue({
      id: "uuid-1",
      onboardingCompleted: true,
    });

    const result = await controller.updatePreferences(user, dto);
    expect(result).toEqual({ id: "uuid-1", onboardingCompleted: true });
    expect(service.updatePreferences).toHaveBeenCalledWith(user, dto);
  });
});
