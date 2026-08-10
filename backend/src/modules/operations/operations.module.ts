import { Module } from '@nestjs/common';
import { BookingsController } from './controllers/bookings.controller';
import { DocumentsController } from './controllers/documents.controller';
import { OperationsController } from './controllers/operations.controller';
import { BookingsService } from './services/bookings.service';
import { DocumentsService } from './services/documents.service';
import { OperationsService } from './services/operations.service';

@Module({
  controllers: [BookingsController, DocumentsController, OperationsController],
  providers: [BookingsService, DocumentsService, OperationsService],
  exports: [BookingsService, DocumentsService, OperationsService],
})
export class OperationsModule {}
