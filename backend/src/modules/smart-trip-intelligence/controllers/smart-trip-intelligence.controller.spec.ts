import { Test, TestingModule } from '@nestjs/testing';
import { SmartTripIntelligenceController } from './smart-trip-intelligence.controller';
import { SmartTripIntelligenceService } from '../services/smart-trip-intelligence.service';
import { WeatherService } from '../../weather/services/weather.service';

describe('SmartTripIntelligenceController', () => {
  let controller: SmartTripIntelligenceController;
  let service: SmartTripIntelligenceService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [SmartTripIntelligenceController],
      providers: [SmartTripIntelligenceService, WeatherService],
    }).compile();

    controller = module.get<SmartTripIntelligenceController>(SmartTripIntelligenceController);
    service = module.get<SmartTripIntelligenceService>(SmartTripIntelligenceService);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  it('should return trip readiness status and smart insights', async () => {
    const result = await controller.getTripIntelligence('trip-goa-1');
    expect(result).toBeDefined();
    expect(result.tripId).toBe('trip-goa-1');
    expect(result.readiness).toBeDefined();
    expect(result.readiness.status).toBe('needs_review');
    expect(result.insights.length).toBeGreaterThan(0);
    expect(result.insights[0].type).toBe('weatherConflict');
  });

  it('should analyze weather impact for a trip day', async () => {
    const result = await controller.analyzeWeatherImpact('trip-goa-1', 'day-2');
    expect(result).toBeDefined();
    expect(result.weatherImpactLevel).toBe('warning');
  });
});
