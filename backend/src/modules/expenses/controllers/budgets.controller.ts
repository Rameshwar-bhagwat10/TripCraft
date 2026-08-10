import { Controller, Get, Post, Patch, Param, Body } from '@nestjs/common';
import { BudgetsService, TripBudgetDto } from '../services/budgets.service';

@Controller()
export class BudgetsController {
  constructor(private readonly budgetsService: BudgetsService) {}

  @Get('trips/:tripId/budget')
  async getBudget(@Param('tripId') tripId: string) {
    return this.budgetsService.getBudgetByTrip(tripId);
  }

  @Post('trips/:tripId/budget')
  async createOrUpdateBudget(@Param('tripId') tripId: string, @Body() body: Partial<TripBudgetDto>) {
    return this.budgetsService.createOrUpdateBudget(tripId, body);
  }

  @Patch('budgets/:id')
  async updateBudgetById(@Param('id') id: string, @Body() body: Partial<TripBudgetDto>) {
    const tripId = body.tripId || 'trip-goa-escape';
    return this.budgetsService.createOrUpdateBudget(tripId, body);
  }
}
