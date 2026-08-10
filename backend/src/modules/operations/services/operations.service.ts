import { Injectable, Logger } from '@nestjs/common';
import { BookingsService } from './bookings.service';
import { DocumentsService } from './documents.service';

export interface TripOperationsSummaryDto {
  tripId: string;
  readinessScore: number;
  readinessStatus: 'ready' | 'mostly_ready' | 'needs_attention';
  summary: string;
  totalBookings: number;
  confirmedBookingsCount: number;
  totalDocumentsCount: number;
  attentionItems: {
    id: string;
    severity: 'high' | 'medium' | 'low';
    title: string;
    description: string;
    actionLabel: string;
    bookingId?: string;
  }[];
}

@Injectable()
export class OperationsService {
  private readonly logger = new Logger(OperationsService.name);

  constructor(
    private readonly bookingsService: BookingsService,
    private readonly documentsService: DocumentsService,
  ) {}

  async getOperationsSummary(tripId: string): Promise<TripOperationsSummaryDto> {
    const [bookings, docs] = await Promise.all([
      this.bookingsService.getBookingsByTrip(tripId),
      this.documentsService.getDocumentsByTrip(tripId),
    ]);

    const confirmed = bookings.filter((b) => b.status === 'confirmed').length;
    const total = bookings.length;

    const attentionItems = [];

    // Evaluate unconfirmed bookings
    const pending = bookings.filter((b) => b.status === 'pending');
    for (const p of pending) {
      attentionItems.push({
        id: `att-pending-${p.id}`,
        severity: 'medium' as const,
        title: `Unconfirmed Reservation: ${p.title}`,
        description: `Booking reference ${p.confirmationNumber} is still pending provider confirmation.`,
        actionLabel: 'Check Status',
        bookingId: p.id,
      });
    }

    // Evaluate missing documents for confirmed bookings
    const confirmedWithoutDocs = bookings.filter((b) => b.status === 'confirmed' && (!b.linkedDocumentIds || b.linkedDocumentIds.length === 0));
    for (const c of confirmedWithoutDocs) {
      attentionItems.push({
        id: `att-doc-${c.id}`,
        severity: 'low' as const,
        title: `Document Missing: ${c.title}`,
        description: `No PDF ticket or voucher is attached to this confirmed booking record.`,
        actionLabel: 'Upload Document',
        bookingId: c.id,
      });
    }

    let readinessStatus: 'ready' | 'mostly_ready' | 'needs_attention' = 'ready';
    let readinessScore = 100;

    if (attentionItems.length > 0) {
      readinessStatus = attentionItems.some((i) => i.severity === 'high') ? 'needs_attention' : 'mostly_ready';
      readinessScore = Math.max(70, 100 - attentionItems.length * 10);
    }

    return {
      tripId,
      readinessScore,
      readinessStatus,
      summary: readinessStatus === 'ready'
        ? 'All flights, stays and activity reservations are confirmed with tickets attached.'
        : `${confirmed} of ${total} bookings confirmed. ${attentionItems.length} operational items need review.`,
      totalBookings: total,
      confirmedBookingsCount: confirmed,
      totalDocumentsCount: docs.length,
      attentionItems,
    };
  }
}
