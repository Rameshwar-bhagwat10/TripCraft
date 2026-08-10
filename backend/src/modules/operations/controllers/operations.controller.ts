import { Controller, Get, Param } from '@nestjs/common';
import { OperationsService } from '../services/operations.service';

@Controller('trips')
export class OperationsController {
  constructor(private readonly operationsService: OperationsService) {}

  @Get(':tripId/operations')
  async getOperationsSummary(@Param('tripId') tripId: string) {
    return this.operationsService.getOperationsSummary(tripId);
  }
}
