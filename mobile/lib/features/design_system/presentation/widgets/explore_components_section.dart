import 'package:flutter/material.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../shared/layouts/section_layout.dart';
import '../../../explore/domain/entities/destination.dart';
import '../../../explore/presentation/widgets/activity_card.dart';
import '../../../explore/presentation/widgets/category_selector.dart';
import '../../../explore/presentation/widgets/explore_header.dart';
import '../../../explore/presentation/widgets/explore_search_bar.dart';
import '../../../explore/presentation/widgets/featured_destination_card.dart';

class ExploreComponentsSection extends StatelessWidget {
  const ExploreComponentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionLayout(
      title: 'Explore & Destination Components',
      subtitle: 'Header, Search Bar, Category Chips, Featured Hero Card, and Activity Preview',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ExploreHeader(),
          const SizedBox(height: AppDimensions.space16),
          const ExploreSearchBar(activeFilterCount: 2),
          const SizedBox(height: AppDimensions.space16),
          CategorySelector(
            selectedCategory: 'Beach',
            onCategorySelected: (_) {},
          ),
          const SizedBox(height: AppDimensions.space16),
          const FeaturedDestinationCard(
            destination: Destination(
              id: 'showcase-featured',
              name: 'Goa Coastline',
              slug: 'goa',
              city: 'Goa',
              country: 'India',
              region: 'South Asia',
              description: 'A relaxed coastal paradise famous for its golden beaches.',
              heroImage: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800',
              rating: 4.8,
              reviewCount: 340,
              isSaved: true,
            ),
          ),
          const SizedBox(height: AppDimensions.space16),
          const ActivityCard(
            title: 'Scuba Diving Tour',
            category: 'Adventure',
          ),
        ],
      ),
    );
  }
}
