import { Controller, Get, Param } from '@nestjs/common';
import { FinanceAnalyticsService } from '../services/finance-analytics.service';

@Controller('trips')
export class FinanceController {
  constructor(private readonly analyticsService: FinanceAnalyticsService) {}

  @Get(':tripId/finance-analytics')
  async getFinanceAnalytics(@Param('tripId') tripId: string) {
    return this.analyticsService.getFinanceAnalytics(tripId);
  }
}
