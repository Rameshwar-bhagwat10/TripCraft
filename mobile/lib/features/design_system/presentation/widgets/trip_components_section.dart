import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../shared/layouts/section_layout.dart';
import '../../../trips/domain/entities/trip.dart';
import '../../../trips/presentation/widgets/traveler_stepper.dart';
import '../../../trips/presentation/widgets/trip_card.dart';
import '../../../trips/presentation/widgets/trip_module_row.dart';
import '../../../trips/presentation/widgets/trip_status_badge.dart';

class TripComponentsSection extends StatefulWidget {
  const TripComponentsSection({super.key});

  @override
  State<TripComponentsSection> createState() => _TripComponentsSectionState();
}

class _TripComponentsSectionState extends State<TripComponentsSection> {
  int _travelerCount = 2;

  @override
  Widget build(BuildContext context) {
    return SectionLayout(
      title: 'Trip Creation & Workspace Components',
      subtitle: 'Status Badges, Traveler Stepper, Trip Card, and Module Rows',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Badges Row
          const Wrap(
            spacing: AppDimensions.space8,
            runSpacing: AppDimensions.space8,
            children: [
              TripStatusBadge(status: TripStatus.upcoming),
              TripStatusBadge(status: TripStatus.ongoing),
              TripStatusBadge(status: TripStatus.completed),
              TripStatusBadge(status: TripStatus.draft),
              TripStatusBadge(status: TripStatus.archived),
            ],
          ),
          const SizedBox(height: AppDimensions.space16),

          // Traveler Stepper
          TravelerStepper(
            count: _travelerCount,
            onChanged: (val) => setState(() => _travelerCount = val),
          ),
          const SizedBox(height: AppDimensions.space16),

          // Trip Card Preview
          TripCard(
            trip: Trip(
              id: 'showcase-trip',
              ownerId: 'user-1',
              destinationId: 'dest-goa',
              title: 'Goa Coastal Escape',
              description: 'A 5-day relaxation and beach hopping trip along South Goa.',
              coverImage: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=1200',
              startDate: '2026-08-21',
              endDate: '2026-08-25',
              status: TripStatus.upcoming,
              travelersCount: _travelerCount,
              destination: const TripDestination(
                id: 'dest-goa',
                name: 'Goa',
                city: 'Goa',
                country: 'India',
                heroImage: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=1200',
              ),
              createdAt: '2026-08-09T10:00:00Z',
              updatedAt: '2026-08-09T10:00:00Z',
            ),
          ),
          const SizedBox(height: AppDimensions.space16),

          // Module Row Preview
          TripModuleRow(
            icon: PhosphorIconsRegular.calendarCheck,
            title: 'Itinerary Schedules',
            subtitle: 'Day-by-day activities & timelines',
            badgeText: 'Primary',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
