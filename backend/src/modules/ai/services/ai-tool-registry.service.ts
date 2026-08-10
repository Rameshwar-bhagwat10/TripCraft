import { Injectable, Logger } from '@nestjs/common';
import { WeatherService } from '../../weather/services/weather.service';
import { SmartTripIntelligenceService } from '../../smart-trip-intelligence/services/smart-trip-intelligence.service';
import { RouteIntelligenceService } from '../../route-intelligence/services/route-intelligence.service';
import { PlacesService } from '../../places/services/places.service';
import { BookingsService } from '../../operations/services/bookings.service';
import { DocumentsService } from '../../operations/services/documents.service';
import { OperationsService } from '../../operations/services/operations.service';

export interface AiToolDefinition {
  name: string;
  description: string;
  type: 'read' | 'write';
  riskLevel: 'read' | 'low' | 'medium' | 'high';
  requiresConfirmation: boolean;
}

@Injectable()
export class AiToolRegistryService {
  private readonly logger = new Logger(AiToolRegistryService.name);

  constructor(
    private readonly weatherService: WeatherService,
    private readonly intelligenceService: SmartTripIntelligenceService,
    private readonly routeService: RouteIntelligenceService,
    private readonly placesService: PlacesService,
    private readonly bookingsService: BookingsService,
    private readonly documentsService: DocumentsService,
    private readonly operationsService: OperationsService,
  ) {}

  getTools(): AiToolDefinition[] {
    return [
      { name: 'get_user_profile', description: 'Get authenticated user travel profile and preferences', type: 'read', riskLevel: 'read', requiresConfirmation: false },
      { name: 'get_current_trip', description: 'Get details of active trip workspace', type: 'read', riskLevel: 'read', requiresConfirmation: false },
      { name: 'get_itinerary', description: 'Get day-by-day itinerary activities', type: 'read', riskLevel: 'read', requiresConfirmation: false },
      { name: 'search_places', description: 'Search nearby places and attractions by category', type: 'read', riskLevel: 'read', requiresConfirmation: false },
      { name: 'get_weather', description: 'Get current weather and 5-day forecast', type: 'read', riskLevel: 'read', requiresConfirmation: false },
      { name: 'get_route_intelligence', description: 'Analyze multi-stop route distances and travel burden', type: 'read', riskLevel: 'read', requiresConfirmation: false },
      { name: 'get_trip_readiness', description: 'Get overall trip health and weather risk insights', type: 'read', riskLevel: 'read', requiresConfirmation: false },
      { name: 'get_bookings', description: 'Get confirmed and pending travel bookings (flights, stays, trains)', type: 'read', riskLevel: 'read', requiresConfirmation: false },
      { name: 'get_documents', description: 'Get uploaded travel tickets, vouchers and document metadata', type: 'read', riskLevel: 'read', requiresConfirmation: false },
      { name: 'get_trip_operations', description: 'Get operational readiness overview and attention items', type: 'read', riskLevel: 'read', requiresConfirmation: false },
      { name: 'add_activity', description: 'Add a place or activity to an itinerary day', type: 'write', riskLevel: 'medium', requiresConfirmation: true },
      { name: 'move_activity', description: 'Change activity start time or day', type: 'write', riskLevel: 'medium', requiresConfirmation: true },
      { name: 'remove_activity', description: 'Delete an activity from an itinerary day', type: 'write', riskLevel: 'high', requiresConfirmation: true },
      { name: 'create_booking_record', description: 'Create a flight, hotel, or activity booking record', type: 'write', riskLevel: 'medium', requiresConfirmation: true },
    ];
  }

  async executeReadTool(name: string, params: Record<string, any>) {
    const tripId = params.tripId || 'trip-goa-escape';
    const dayId = params.dayId || 'day-1';

    switch (name) {
      case 'get_weather':
        return this.weatherService.getTripWeather(tripId);
      case 'get_trip_readiness':
        return this.intelligenceService.getTripIntelligence(tripId);
      case 'search_places':
        return this.placesService.searchPlaces({ query: params.query || 'beach' });
      case 'get_route_intelligence':
        return this.routeService.analyzeRoute(tripId, dayId, { mode: 'driving' });
      case 'get_bookings':
        return this.bookingsService.getBookingsByTrip(tripId);
      case 'get_documents':
        return this.documentsService.getDocumentsByTrip(tripId);
      case 'get_trip_operations':
        return this.operationsService.getOperationsSummary(tripId);
      default:
        return { message: `Executed tool ${name}` };
    }
  }
}
