import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';

// Core Services & Repositories
import { DatabaseModule } from './core/database/database.module';
import { StorageModule } from './core/storage/storage.module';

// Feature Modules
import { AuthModule } from './modules/auth/auth.module';
import { ProfileModule } from './modules/profile/profile.module';
import { DestinationsModule } from './modules/destinations/destinations.module';
import { TripsModule } from './modules/trips/trips.module';
import { ItineraryModule } from './modules/itinerary/itinerary.module';
import { MapsModule } from './modules/maps/maps.module';
import { PlacesModule } from './modules/places/places.module';
import { RouteIntelligenceModule } from './modules/route-intelligence/route-intelligence.module';
import { WeatherModule } from './modules/weather/weather.module';
import { SmartTripIntelligenceModule } from './modules/smart-trip-intelligence/smart-trip-intelligence.module';
import { OperationsModule } from './modules/operations/operations.module';
import { ExpensesModule } from './modules/expenses/expenses.module';
import { AiModule } from './modules/ai/ai.module';

@Module({
  imports: [
    // Configuration
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ['.env.local', '.env'],
    }),

    // Core Foundation
    DatabaseModule,
    StorageModule,

    // Application Features
    AuthModule,
    ProfileModule,
    DestinationsModule,
    TripsModule,
    ItineraryModule,
    MapsModule,
    PlacesModule,
    RouteIntelligenceModule,
    WeatherModule,
    SmartTripIntelligenceModule,
    OperationsModule,
    ExpensesModule,
    AiModule,
  ],
})
export class AppModule {}
