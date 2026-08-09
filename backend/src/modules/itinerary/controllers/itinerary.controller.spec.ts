import { Test, TestingModule } from "@nestjs/testing";
import { ItineraryController } from "./itinerary.controller";
import { ItineraryService } from "../services/itinerary.service";
import { ConfigService } from "@nestjs/config";

describe("ItineraryController", () => {
  let controller: ItineraryController;
  let service: ItineraryService;

  const mockItineraryService = {
    getItinerary: jest.fn(),
    createItineraryItem: jest.fn(),
    updateItineraryItem: jest.fn(),
    deleteItineraryItem: jest.fn(),
    reorderItineraryItems: jest.fn(),
    moveItineraryItem: jest.fn(),
    updateTripDay: jest.fn(),
  };

  const mockConfigService = {
    get: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [ItineraryController],
      providers: [
        { provide: ItineraryService, useValue: mockItineraryService },
        { provide: ConfigService, useValue: mockConfigService },
      ],
    }).compile();

    controller = module.get<ItineraryController>(ItineraryController);
    service = module.get<ItineraryService>(ItineraryService);
  });

  it("should be defined", () => {
    expect(controller).toBeDefined();
  });

  it("getItinerary should return full trip days and items", async () => {
    const user = { id: "uuid-1", email: "test@example.com" };
    const mockResult = { tripId: "trip-1", days: [] };
    mockItineraryService.getItinerary.mockResolvedValue(mockResult);

    const result = await controller.getItinerary("trip-1", user);
    expect(result).toEqual(mockResult);
    expect(service.getItinerary).toHaveBeenCalledWith("trip-1", user);
  });
});
