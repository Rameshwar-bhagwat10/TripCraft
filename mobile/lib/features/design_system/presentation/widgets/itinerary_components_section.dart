import 'package:flutter/material.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../shared/layouts/section_layout.dart';
import '../../../itinerary/domain/entities/itinerary.dart';
import '../../../itinerary/presentation/widgets/conflict_warning_banner.dart';
import '../../../itinerary/presentation/widgets/itinerary_day_selector.dart';
import '../../../itinerary/presentation/widgets/itinerary_item_card.dart';

class ItineraryComponentsSection extends StatefulWidget {
  const ItineraryComponentsSection({super.key});

  @override
  State<ItineraryComponentsSection> createState() => _ItineraryComponentsSectionState();
}

class _ItineraryComponentsSectionState extends State<ItineraryComponentsSection> {
  int _selectedDay = 0;

  final List<TripDay> _days = [
    TripDay(
      id: 'day-1',
      tripId: 'showcase-trip',
      date: '2026-08-21',
      dayNumber: 1,
      title: 'Old Goa & Heritage',
      createdAt: '',
      updatedAt: '',
    ),
    TripDay(
      id: 'day-2',
      tripId: 'showcase-trip',
      date: '2026-08-22',
      dayNumber: 2,
      title: 'Beach & Watersports',
      createdAt: '',
      updatedAt: '',
    ),
  ];

  final _sampleItem1 = ItineraryItem(
    id: 'item-showcase-1',
    tripDayId: 'day-1',
    title: 'Explore Fort Aguada',
    description: '17th-century Portuguese lighthouse and fort',
    type: ActivityType.sightseeing,
    startTime: '10:30',
    endTime: '12:30',
    duration: '2h',
    createdAt: '',
    updatedAt: '',
  );

  final _sampleItem2 = ItineraryItem(
    id: 'item-showcase-2',
    tripDayId: 'day-1',
    title: 'Seafood Lunch at Brittos',
    description: 'Famous beach shack in Baga',
    type: ActivityType.food,
    startTime: '11:30',
    endTime: '13:00',
    duration: '1h 30m',
    createdAt: '',
    updatedAt: '',
  );

  @override
  Widget build(BuildContext context) {
    return SectionLayout(
      title: 'Visual Itinerary Components',
      subtitle: 'Day Selector, Activity Card, Conflict Warning Banner',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ItineraryDaySelector(
            days: _days,
            selectedIndex: _selectedDay,
            onDaySelected: (idx) => setState(() => _selectedDay = idx),
          ),
          const SizedBox(height: AppDimensions.space16),

          ConflictWarningBanner(
            conflicts: [
              ItineraryConflict(item1: _sampleItem1, item2: _sampleItem2),
            ],
          ),
          const SizedBox(height: AppDimensions.space12),

          ItineraryItemCard(item: _sampleItem1),
          const SizedBox(height: AppDimensions.space12),
          ItineraryItemCard(item: _sampleItem2),
        ],
      ),
    );
  }
}
