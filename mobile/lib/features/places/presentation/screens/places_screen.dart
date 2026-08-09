import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';
import '../../../../shared/widgets/states/empty_state.dart';
import '../../domain/entities/place.dart';
import '../providers/places_provider.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(placesProvider);
    final notifier = ref.read(placesProvider.notifier);

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Discover Places', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Input
            Padding(
              padding: const EdgeInsets.all(AppDimensions.pageMargin),
              child: AppTextField(
                controller: _searchController,
                hintText: 'Search places, food, attractions...',
                prefixIcon: const Icon(PhosphorIconsRegular.magnifyingGlass, color: AppColors.textTertiary),
                onChanged: (val) => notifier.setSearchQuery(val),
              ),
            ),

            // Horizontal Category Selector Chips
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageMargin),
                itemCount: PlaceCategory.values.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.space8),
                itemBuilder: (context, index) {
                  final cat = PlaceCategory.values[index];
                  final config = PlaceCategoryConfig.getConfig(cat);
                  final isSelected = state.selectedCategory == cat;

                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      notifier.selectCategory(cat);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.surfaceSecondary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(config.icon, size: 14, color: isSelected ? Colors.white : AppColors.textPrimary),
                          const SizedBox(width: 6),
                          Text(
                            config.label,
                            style: AppTypography.bodySmall.copyWith(
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppDimensions.space16),

            // Places List / Grid
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : state.places.isEmpty
                      ? SingleChildScrollView(
                          child: EmptyState(
                            title: 'No Places Found',
                            description: 'Try searching for something else or change category filter.',
                            icon: PhosphorIconsRegular.mapPin,
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(AppDimensions.pageMargin),
                          itemCount: state.places.length,
                          separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.space14),
                          itemBuilder: (context, index) {
                            final place = state.places[index];
                            final catConfig = PlaceCategoryConfig.getConfig(place.category);

                            return GestureDetector(
                              onTap: () => context.push('/places/${place.id}'),
                              child: Container(
                                padding: const EdgeInsets.all(AppDimensions.space12),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.border),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.02),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // Place Thumbnail
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        place.imageUrl,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 80,
                                          height: 80,
                                          color: AppColors.surfaceSecondary,
                                          child: const Icon(PhosphorIconsRegular.image, color: AppColors.textTertiary),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: AppDimensions.space12),

                                    // Content
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  place.name,
                                                  style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  place.isSaved ? PhosphorIconsFill.heart : PhosphorIconsRegular.heart,
                                                  color: place.isSaved ? AppColors.error : AppColors.textTertiary,
                                                  size: 18,
                                                ),
                                                onPressed: () => notifier.toggleSave(place.id),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            place.address,
                                            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              const Icon(PhosphorIconsFill.star, size: 14, color: Colors.amber),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${place.rating} (${place.reviewCount})',
                                                style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w700),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '· ${catConfig.label}',
                                                style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
