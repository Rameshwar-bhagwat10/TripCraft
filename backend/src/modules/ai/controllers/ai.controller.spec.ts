import { Test, TestingModule } from '@nestjs/testing';
import { AiController } from './ai.controller';
import { AiService } from '../services/ai.service';
import { AiContextManagerService } from '../services/ai-context-manager.service';
import { AiToolRegistryService } from '../services/ai-tool-registry.service';
import { WeatherService } from '../../weather/services/weather.service';
import { SmartTripIntelligenceService } from '../../smart-trip-intelligence/services/smart-trip-intelligence.service';
import { RouteIntelligenceService } from '../../route-intelligence/services/route-intelligence.service';
import { PlacesService } from '../../places/services/places.service';
import { BookingsService } from '../../operations/services/bookings.service';
import { DocumentsService } from '../../operations/services/documents.service';
import { OperationsService } from '../../operations/services/operations.service';
import { BudgetsService } from '../../expenses/services/budgets.service';
import { ExpensesService } from '../../expenses/services/expenses.service';
import { SettlementsService } from '../../expenses/services/settlements.service';
import { CurrencyService } from '../../expenses/services/currency.service';
import { FinanceAnalyticsService } from '../../expenses/services/finance-analytics.service';

describe('AiController', () => {
  let controller: AiController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [AiController],
      providers: [
        AiService,
        AiContextManagerService,
        AiToolRegistryService,
        WeatherService,
        SmartTripIntelligenceService,
        RouteIntelligenceService,
        PlacesService,
        BookingsService,
        DocumentsService,
        OperationsService,
        BudgetsService,
        ExpensesService,
        SettlementsService,
        CurrencyService,
        FinanceAnalyticsService,
      ],
    }).compile();

    controller = module.get<AiController>(AiController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  it('should create conversation and respond to weather intent', async () => {
    const conv = await controller.createConversation({ tripId: 'trip-goa-1' });
    expect(conv).toBeDefined();
    expect(conv.id).toBeDefined();

    const msg = await controller.sendMessage(conv.id, { message: 'What is the weather tomorrow?', tripId: 'trip-goa-1' });
    expect(msg).toBeDefined();
    expect(msg.role).toBe('assistant');
    expect(msg.cards).toBeDefined();
    expect(msg.cards![0].type).toBe('weatherCard');
  });

  it('should generate action proposal when user requests moving an activity', async () => {
    const msg = await controller.sendMessage('conv-1', { message: 'Move Baga beach to morning', tripId: 'trip-goa-1' });
    expect(msg).toBeDefined();
    expect(msg.actionProposal).toBeDefined();
    expect(msg.actionProposal!.type).toBe('move_activity');
  });

  it('should confirm action proposal', async () => {
    const res = await controller.confirmAction('act-prop-1');
    expect(res).toBeDefined();
    expect(res.status).toBe('applied');
  });
});
