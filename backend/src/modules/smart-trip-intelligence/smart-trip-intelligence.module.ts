import { Module } from '@nestjs/common';
import { WeatherModule } from '../weather/weather.module';
import { SmartTripIntelligenceController } from './controllers/smart-trip-intelligence.controller';
import { SmartTripIntelligenceService } from './services/smart-trip-intelligence.service';

@Module({
  imports: [WeatherModule],
  controllers: [SmartTripIntelligenceController],
  providers: [SmartTripIntelligenceService],
  exports: [SmartTripIntelligenceService],
})
export class SmartTripIntelligenceModule {}
