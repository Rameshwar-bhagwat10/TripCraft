import { Injectable, Logger } from '@nestjs/common';
import { WeatherService } from '../../weather/services/weather.service';

export interface TripReadinessData {
  status: 'ready' | 'good' | 'needs_review' | 'high_risk';
  label: string;
  summary: string;
  weatherFactor: { status: 'good' | 'warning'; label: string };
  routeFactor: { status: 'good' | 'warning'; label: string };
  scheduleFactor: { status: 'good' | 'warning'; label: string };
  activityFactor: { status: 'good' | 'warning'; label: string };
}

export interface SmartTripInsightData {
  id: string;
  type: string;
  severity: 'info' | 'suggestion' | 'warning' | 'critical';
  title: string;
  description: string;
  affectedActivityTitle?: string;
  affectedDayNumber?: number;
  estimatedTimeSavedMins?: number;
  recommendedAction?: string;
  alternativeSuggestions?: Array<{
    id: string;
    name: string;
    category: string;
    address: string;
    rating: number;
    suitabilityReason: string;
  }>;
}

@Injectable()
export class SmartTripIntelligenceService {
  private readonly logger = new Logger(SmartTripIntelligenceService.name);

  constructor(private readonly weatherService: WeatherService) {}

  async getTripIntelligence(tripId: string) {
    const weather = await this.weatherService.getTripWeather(tripId);

    const readiness: TripReadinessData = {
      status: 'needs_review',
      label: 'Needs Review',
      summary: '2 weather-sensitive outdoor activities overlap with expected afternoon monsoon rain on Day 2.',
      weatherFactor: { status: 'warning', label: 'Afternoon rain expected' },
      routeFactor: { status: 'good', label: 'Efficient travel route' },
      scheduleFactor: { status: 'warning', label: '1 timing conflict' },
      activityFactor: { status: 'good', label: '5 well-distributed activities' },
    };

    const insights: SmartTripInsightData[] = [
      {
        id: 'smart-ins-1',
        type: 'weatherConflict',
        severity: 'warning',
        title: 'Outdoor Rain Risk',
        description: 'Your planned visit to Baga Beach & Watersports at 03:00 PM overlaps with expected heavy monsoon rain (85% probability).',
        affectedActivityTitle: 'Baga Beach Watersports',
        affectedDayNumber: 2,
        estimatedTimeSavedMins: 30,
        recommendedAction: 'Move Baga Beach visit to 10:00 AM (sunny window) or substitute with an indoor museum/cafe.',
        alternativeSuggestions: [
          {
            id: 'alt-1',
            name: 'Museum of Christian Art',
            category: 'sightseeing',
            address: 'Old Goa Road, Goa',
            rating: 4.6,
            suitabilityReason: 'Indoor museum · Rain safe · 12 min away',
          },
          {
            id: 'alt-2',
            name: 'Cafe Bodega Art Gallery',
            category: 'cafe',
            address: 'Sunaparanta Art Centre, Altinho',
            rating: 4.8,
            suitabilityReason: 'Covered patio & cafe · Rain safe · 8 min away',
          },
        ],
      },
      {
        id: 'smart-ins-2',
        type: 'weatherRouteRisk',
        severity: 'suggestion',
        title: 'Rain Travel Buffer',
        description: 'Light rain expected during the 45-minute drive from Calangute to Old Goa. Allow an additional 15 minutes travel buffer.',
        affectedDayNumber: 2,
        estimatedTimeSavedMins: 15,
        recommendedAction: 'Depart Calangute 15 minutes earlier at 04:15 PM.',
      },
      {
        id: 'smart-ins-3',
        type: 'backtracking',
        severity: 'suggestion',
        title: 'Route Efficiency Opportunity',
        description: 'Visiting Fort Aguada before Brittos Shack reduces daily travel distance by 6.8 km.',
        affectedDayNumber: 1,
        estimatedTimeSavedMins: 24,
        recommendedAction: 'Reorder Day 1 stops to group coastal sites consecutively.',
      },
    ];

    return {
      tripId,
      readiness,
      weatherSummary: {
        condition: weather.current.condition.main,
        temperature: weather.current.temperature,
        humidity: weather.current.humidity,
        alertsCount: weather.alerts.length,
      },
      insights,
      updatedAt: new Date().toISOString(),
    };
  }

  async analyzeWeatherImpact(tripId: string, dayId: string) {
    const intelligence = await this.getTripIntelligence(tripId);
    return {
      tripId,
      dayId,
      weatherImpactLevel: 'warning',
      insights: intelligence.insights,
    };
  }
}
