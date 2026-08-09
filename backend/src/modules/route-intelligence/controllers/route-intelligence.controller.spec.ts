import { Test, TestingModule } from '@nestjs/testing';
import { RouteIntelligenceController } from './route-intelligence.controller';
import { RouteIntelligenceService } from '../services/route-intelligence.service';
import { ConfigService } from '@nestjs/config';

describe('RouteIntelligenceController', () => {
  let controller: RouteIntelligenceController;
  let service: RouteIntelligenceService;

  const mockRouteIntelligenceService = {
    analyzeRoute: jest.fn(),
    optimizeRoute: jest.fn(),
  };

  const mockConfigService = {
    get: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [RouteIntelligenceController],
      providers: [
        { provide: RouteIntelligenceService, useValue: mockRouteIntelligenceService },
        { provide: ConfigService, useValue: mockConfigService },
      ],
    }).compile();

    controller = module.get<RouteIntelligenceController>(RouteIntelligenceController);
    service = module.get<RouteIntelligenceService>(RouteIntelligenceService);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  it('analyzeRoute should return insights and segments', async () => {
    const mockResult = {
      tripId: 'trip-1',
      dayId: 'day-1',
      totalDistanceKm: 42.6,
      insights: [{ type: 'backtracking' }],
    };
    mockRouteIntelligenceService.analyzeRoute.mockResolvedValue(mockResult);

    const result = await controller.analyzeRoute('trip-1', 'day-1', { mode: 'driving' });
    expect(result).toEqual(mockResult);
    expect(service.analyzeRoute).toHaveBeenCalledWith('trip-1', 'day-1', { mode: 'driving' });
  });

  it('optimizeRoute should return candidate sequence and time savings', async () => {
    const mockResult = {
      timeSavingsMins: 24,
      canApply: true,
    };
    mockRouteIntelligenceService.optimizeRoute.mockResolvedValue(mockResult);

    const result = await controller.optimizeRoute('trip-1', 'day-1', { mode: 'driving' });
    expect(result).toEqual(mockResult);
    expect(service.optimizeRoute).toHaveBeenCalledWith('trip-1', 'day-1', { mode: 'driving' });
  });
});
