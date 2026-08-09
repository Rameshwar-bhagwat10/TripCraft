import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../shared/layouts/section_layout.dart';
import '../../../home/domain/entities/home_data.dart';
import '../../../home/presentation/widgets/destination_card.dart';
import '../../../home/presentation/widgets/greeting_header.dart';
import '../../../home/presentation/widgets/planning_search_entry.dart';
import '../../../home/presentation/widgets/quick_action_tile.dart';
import '../../../home/presentation/widgets/upcoming_trip_card.dart';
import '../../../home/presentation/widgets/weather_preview_card.dart';

class HomeComponentsSection extends StatelessWidget {
  const HomeComponentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionLayout(
      title: 'Home & Navigation Components',
      subtitle: 'Greeting Header, Search Entry, Upcoming Trip Card, Quick Action Tiles, and Weather Preview',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const GreetingHeader(
            fullName: 'Rameshwar Bhagwat',
          ),
          const SizedBox(height: AppDimensions.space16),
          const PlanningSearchEntry(),
          const SizedBox(height: AppDimensions.space16),
          const UpcomingTripCard(),
          const SizedBox(height: AppDimensions.space16),
          Row(
            children: const [
              Expanded(
                child: QuickActionTile(
                  icon: PhosphorIconsBold.compass,
                  title: 'Plan Trip',
                  isPrimary: true,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: QuickActionTile(
                  icon: PhosphorIconsRegular.magnifyingGlass,
                  title: 'Explore',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: QuickActionTile(
                  icon: PhosphorIconsRegular.bookmark,
                  title: 'Saved',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space16),
          const DestinationCard(
            destination: RecommendedDestination(
              id: 'showcase-1',
              title: 'Goa Coastline',
              location: 'Goa, India',
              category: 'Beach',
              imageUrl: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800',
            ),
          ),
          const SizedBox(height: AppDimensions.space16),
          const WeatherPreviewCard(
            weather: WeatherPreviewData(
              location: 'Mumbai, India',
              temperature: 28,
              condition: 'Partly Cloudy',
              feelsLike: 30,
              icon: 'cloud-sun',
            ),
          ),
        ],
      ),
    );
  }
}
