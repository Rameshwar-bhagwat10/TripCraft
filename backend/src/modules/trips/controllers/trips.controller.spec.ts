import { Test, TestingModule } from "@nestjs/testing";
import { TripsController } from "./trips.controller";
import { TripsService } from "../services/trips.service";
import { ConfigService } from "@nestjs/config";

describe("TripsController", () => {
  let controller: TripsController;
  let service: TripsService;

  const mockTripsService = {
    createTrip: jest.fn(),
    getTrips: jest.fn(),
    getTripById: jest.fn(),
    updateTrip: jest.fn(),
    archiveTrip: jest.fn(),
    restoreTrip: jest.fn(),
    deleteTrip: jest.fn(),
  };

  const mockConfigService = {
    get: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [TripsController],
      providers: [
        { provide: TripsService, useValue: mockTripsService },
        { provide: ConfigService, useValue: mockConfigService },
      ],
    }).compile();

    controller = module.get<TripsController>(TripsController);
    service = module.get<TripsService>(TripsService);
  });

  it("should be defined", () => {
    expect(controller).toBeDefined();
  });

  it("getTrips should return paginated list", async () => {
    const user = { id: "uuid-1", email: "test@example.com" };
    const mockResult = { items: [], total: 0, page: 1, limit: 20 };
    mockTripsService.getTrips.mockResolvedValue(mockResult);

    const result = await controller.getTrips({}, user);
    expect(result).toEqual(mockResult);
    expect(service.getTrips).toHaveBeenCalledWith({}, user);
  });

  it("createTrip should return created trip", async () => {
    const user = { id: "uuid-1", email: "test@example.com" };
    const dto = {
      destinationId: "dest-goa",
      title: "Goa Escape",
      startDate: "2026-08-21",
      endDate: "2026-08-25",
    };
    const mockResult = { id: "trip-1", ...dto };
    mockTripsService.createTrip.mockResolvedValue(mockResult);

    const result = await controller.createTrip(dto, user);
    expect(result).toEqual(mockResult);
    expect(service.createTrip).toHaveBeenCalledWith(dto, user);
  });
});
