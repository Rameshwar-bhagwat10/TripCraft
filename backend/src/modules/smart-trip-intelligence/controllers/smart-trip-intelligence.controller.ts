import { Controller, Get, Post, Param } from '@nestjs/common';
import { SmartTripIntelligenceService } from '../services/smart-trip-intelligence.service';

@Controller('trips')
export class SmartTripIntelligenceController {
  constructor(private readonly intelligenceService: SmartTripIntelligenceService) {}

  @Get(':tripId/intelligence')
  async getTripIntelligence(@Param('tripId') tripId: string) {
    return this.intelligenceService.getTripIntelligence(tripId);
  }

  @Post(':tripId/days/:dayId/weather-analysis')
  async analyzeWeatherImpact(
    @Param('tripId') tripId: string,
    @Param('dayId') dayId: string,
  ) {
    return this.intelligenceService.analyzeWeatherImpact(tripId, dayId);
  }

  @Post(':tripId/intelligence/refresh')
  async refreshIntelligence(@Param('tripId') tripId: string) {
    return this.intelligenceService.getTripIntelligence(tripId);
  }
}
