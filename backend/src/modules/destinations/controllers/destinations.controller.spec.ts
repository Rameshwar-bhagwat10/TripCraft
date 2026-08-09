import { Test, TestingModule } from "@nestjs/testing";
import { DestinationsController } from "./destinations.controller";
import { DestinationsService } from "../services/destinations.service";
import { ConfigService } from "@nestjs/config";

describe("DestinationsController", () => {
  let controller: DestinationsController;
  let service: DestinationsService;

  const mockDestinationsService = {
    getDestinations: jest.fn(),
    getFeaturedDestinations: jest.fn(),
    getRecommendedDestinations: jest.fn(),
    getTrendingDestinations: jest.fn(),
    getSavedDestinations: jest.fn(),
    getDestinationById: jest.fn(),
    saveDestination: jest.fn(),
    unsaveDestination: jest.fn(),
  };

  const mockConfigService = {
    get: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [DestinationsController],
      providers: [
        { provide: DestinationsService, useValue: mockDestinationsService },
        { provide: ConfigService, useValue: mockConfigService },
      ],
    }).compile();

    controller = module.get<DestinationsController>(DestinationsController);
    service = module.get<DestinationsService>(DestinationsService);
  });

  it("should be defined", () => {
    expect(controller).toBeDefined();
  });

  it("getDestinations should return list payload", async () => {
    const user = { id: "uuid-1", email: "test@example.com" };
    const mockResult = { items: [], total: 0, page: 1, limit: 20 };
    mockDestinationsService.getDestinations.mockResolvedValue(mockResult);

    const result = await controller.getDestinations({}, user);
    expect(result).toEqual(mockResult);
    expect(service.getDestinations).toHaveBeenCalledWith({}, user);
  });

  it("saveDestination should return saved state", async () => {
    const user = { id: "uuid-1", email: "test@example.com" };
    const mockResult = { saved: true, destinationId: "dest-goa" };
    mockDestinationsService.saveDestination.mockResolvedValue(mockResult);

    const result = await controller.saveDestination("dest-goa", user);
    expect(result).toEqual(mockResult);
    expect(service.saveDestination).toHaveBeenCalledWith("dest-goa", user);
  });
});
