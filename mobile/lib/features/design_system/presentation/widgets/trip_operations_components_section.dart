import 'package:flutter/material.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../trip_operations/domain/entities/booking.dart';
import '../../../trip_operations/domain/entities/travel_document.dart';
import '../../../trip_operations/presentation/widgets/booking_card.dart';
import '../../../trip_operations/presentation/widgets/document_card.dart';
import '../../../trip_operations/presentation/widgets/operational_readiness_card.dart';

class TripOperationsComponentsSection extends StatelessWidget {
  const TripOperationsComponentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TRIP OPERATIONS & VAULT COMPONENTS',
          style: AppTypography.labelSmall.copyWith(color: Colors.grey[600], letterSpacing: 1.2),
        ),
        const SizedBox(height: AppDimensions.space12),

        const OperationalReadinessCard(
          summary: TripOperationsSummary(
            tripId: 'demo-trip',
            readinessScore: 92,
            readinessStatus: 'mostly_ready',
            summary: '2 of 2 bookings confirmed. Flight & stay vouchers attached.',
            totalBookings: 2,
            confirmedBookingsCount: 2,
            totalDocumentsCount: 2,
            attentionItems: [],
          ),
        ),
        const SizedBox(height: AppDimensions.space12),

        BookingCard(
          booking: Booking(
            id: 'demo-b-1',
            tripId: 'demo-trip',
            type: BookingType.flight,
            title: 'IndiGo Flight 6E-204 (BOM -> GOI)',
            providerName: 'IndiGo Airlines',
            confirmationNumber: '6E-PNR-8849',
            status: BookingStatus.confirmed,
            startDateTime: '2026-08-21T08:30:00Z',
            createdAt: DateTime.now().toIso8601String(),
          ),
        ),
        const SizedBox(height: AppDimensions.space12),

        DocumentCard(
          document: TravelDocument(
            id: 'demo-doc-1',
            tripId: 'demo-trip',
            title: 'IndiGo Flight E-Ticket.pdf',
            category: DocumentCategory.transport,
            fileType: 'pdf',
            fileSizeBytes: 428000,
            storagePath: 'private/documents/ticket.pdf',
            uploadedAt: DateTime.now().toIso8601String(),
          ),
        ),
      ],
    );
  }
}
