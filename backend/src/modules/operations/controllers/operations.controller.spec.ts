import { Test, TestingModule } from '@nestjs/testing';
import { OperationsController } from './operations.controller';
import { BookingsController } from './bookings.controller';
import { DocumentsController } from './documents.controller';
import { OperationsService } from '../services/operations.service';
import { BookingsService } from '../services/bookings.service';
import { DocumentsService } from '../services/documents.service';

describe('OperationsController', () => {
  let operationsController: OperationsController;
  let bookingsController: BookingsController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [OperationsController, BookingsController, DocumentsController],
      providers: [OperationsService, BookingsService, DocumentsService],
    }).compile();

    operationsController = module.get<OperationsController>(OperationsController);
    bookingsController = module.get<BookingsController>(BookingsController);
  });

  it('should be defined', () => {
    expect(operationsController).toBeDefined();
    expect(bookingsController).toBeDefined();
  });

  it('should return operational summary and readiness score', async () => {
    const summary = await operationsController.getOperationsSummary('trip-goa-escape');
    expect(summary).toBeDefined();
    expect(summary.readinessScore).toBeGreaterThanOrEqual(70);
    expect(summary.totalBookings).toBeGreaterThan(0);
  });

  it('should create a flight booking record', async () => {
    const newBooking = await bookingsController.createBooking('trip-goa-escape', {
      type: 'flight',
      title: 'Air India Flight AI-582',
      providerName: 'Air India',
      confirmationNumber: 'AI-PNR-7711',
      status: 'confirmed',
    });

    expect(newBooking).toBeDefined();
    expect(newBooking.id).toBeDefined();
    expect(newBooking.title).toBe('Air India Flight AI-582');
  });
});
