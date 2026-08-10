import { Controller, Get, Post, Patch, Param } from '@nestjs/common';
import { SettlementsService } from '../services/settlements.service';

@Controller()
export class SettlementsController {
  constructor(private readonly settlementsService: SettlementsService) {}

  @Get('trips/:tripId/balances')
  async getTravelerBalances(@Param('tripId') tripId: string) {
    return this.settlementsService.getTravelerBalances(tripId);
  }

  @Get('trips/:tripId/settlements')
  async getSettlements(@Param('tripId') tripId: string) {
    return this.settlementsService.getSettlementsByTrip(tripId);
  }

  @Patch('settlements/:id')
  async markSettlementComplete(@Param('id') id: string) {
    return this.settlementsService.markSettlementComplete(id);
  }
}
