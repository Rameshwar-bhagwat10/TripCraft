import { Module } from '@nestjs/common';
import { WeatherModule } from '../weather/weather.module';
import { SmartTripIntelligenceModule } from '../smart-trip-intelligence/smart-trip-intelligence.module';
import { RouteIntelligenceModule } from '../route-intelligence/route-intelligence.module';
import { PlacesModule } from '../places/places.module';
import { OperationsModule } from '../operations/operations.module';
import { ExpensesModule } from '../expenses/expenses.module';
import { AiController } from './controllers/ai.controller';
import { AiService } from './services/ai.service';
import { AiContextManagerService } from './services/ai-context-manager.service';
import { AiToolRegistryService } from './services/ai-tool-registry.service';

@Module({
  imports: [WeatherModule, SmartTripIntelligenceModule, RouteIntelligenceModule, PlacesModule, OperationsModule, ExpensesModule],
  controllers: [AiController],
  providers: [AiService, AiContextManagerService, AiToolRegistryService],
  exports: [AiService],
})
export class AiModule {}
