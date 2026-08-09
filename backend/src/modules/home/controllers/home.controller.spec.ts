import { Test, TestingModule } from "@nestjs/testing";
import { HomeController } from "./home.controller";
import { HomeService } from "../services/home.service";
import { ConfigService } from "@nestjs/config";

describe("HomeController", () => {
  let controller: HomeController;
  let service: HomeService;

  const mockHomeService = {
    getHomeData: jest.fn(),
  };

  const mockConfigService = {
    get: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [HomeController],
      providers: [
        { provide: HomeService, useValue: mockHomeService },
        { provide: ConfigService, useValue: mockConfigService },
      ],
    }).compile();

    controller = module.get<HomeController>(HomeController);
    service = module.get<HomeService>(HomeService);
  });

  it("should be defined", () => {
    expect(controller).toBeDefined();
  });

  it("getHomeData should return aggregated payload", async () => {
    const user = { id: "uuid-1", email: "test@example.com" };
    const mockPayload = { user, recommendations: [], upcomingTrip: null };
    mockHomeService.getHomeData.mockResolvedValue(mockPayload);

    const result = await controller.getHomeData(user);
    expect(result).toEqual(mockPayload);
    expect(service.getHomeData).toHaveBeenCalledWith(user);
  });
});
