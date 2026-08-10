import { Injectable, Logger } from '@nestjs/common';
import { WeatherService } from '../../weather/services/weather.service';
import { SmartTripIntelligenceService } from '../../smart-trip-intelligence/services/smart-trip-intelligence.service';
import { RouteIntelligenceService } from '../../route-intelligence/services/route-intelligence.service';
import { PlacesService } from '../../places/services/places.service';

export interface AiContextPayload {
  userId: string;
  tripId?: string;
  dayId?: string;
  activityId?: string;
  placeId?: string;
}

@Injectable()
export class AiContextManagerService {
  private readonly logger = new Logger(AiContextManagerService.name);

  constructor(
    private readonly weatherService: WeatherService,
    private readonly intelligenceService: SmartTripIntelligenceService,
    private readonly routeService: RouteIntelligenceService,
    private readonly placesService: PlacesService,
  ) {}

  async buildContext(payload: AiContextPayload) {
    const tripId = payload.tripId || 'trip-goa-escape';

    const [weather, intelligence, places] = await Promise.all([
      this.weatherService.getTripWeather(tripId),
      this.intelligenceService.getTripIntelligence(tripId),
      this.placesService.searchPlaces({ query: 'beach' }),
    ]);

    return {
      user: {
        id: payload.userId,
        name: 'Rameshwar Bhagwat',
        travelStyle: 'Relaxed & Cultural',
        preferredPace: 'Moderate',
        budgetLevel: 'Moderate',
      },
      trip: {
        id: tripId,
        destination: 'Goa, India',
        durationDays: 5,
        status: 'planning',
        startDate: '2026-08-21',
        endDate: '2026-08-25',
      },
      itinerarySummary: {
        totalActivities: 8,
        activeDayId: payload.dayId || 'day-1',
      },
      places: places.slice(0, 3),
      weather: {
        currentTemp: weather.current.temperature,
        condition: weather.current.condition.main,
        alertsCount: weather.alerts.length,
      },
      intelligence: {
        readinessStatus: intelligence.readiness.status,
        readinessSummary: intelligence.readiness.summary,
        insightsCount: intelligence.insights.length,
      },
      activeContextChip: 'Goa Trip · Day 1 · Fort Aguada',
    };
  }
}
