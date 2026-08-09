import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/feedback/app_snackbar.dart';

import '../../../itinerary/presentation/providers/itinerary_provider.dart';
import '../../domain/entities/place.dart';
import '../providers/places_provider.dart';
import '../widgets/add_place_to_trip_sheet.dart';

class PlaceDetailsScreen extends ConsumerWidget {
  final String placeId;

  const PlaceDetailsScreen({
    super.key,
    required this.placeId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placeAsync = ref.watch(placeDetailsProvider(placeId));

    return AppScaffold(
      body: placeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, __) => _buildErrorState(context),
        data: (place) {
          final catConfig = PlaceCategoryConfig.getConfig(place.category);

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 240,
                    pinned: true,
                    backgroundColor: AppColors.surface,
                    elevation: 0,
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary, size: 20),
                          onPressed: () => context.pop(),
                        ),
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: Icon(
                              place.isSaved ? PhosphorIconsFill.heart : PhosphorIconsRegular.heart,
                              color: place.isSaved ? AppColors.error : AppColors.textPrimary,
                              size: 20,
                            ),
                            onPressed: () => ref.read(placesProvider.notifier).toggleSave(place.id),
                          ),
                        ),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.network(
                        place.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.surfaceSecondary,
                          child: const Center(
                            child: Icon(PhosphorIconsRegular.image, size: 48, color: AppColors.textTertiary),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.pageMargin),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primarySurface,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(catConfig.icon, size: 14, color: AppColors.primary),
                                    const SizedBox(width: 6),
                                    Text(
                                      catConfig.label.toUpperCase(),
                                      style: AppTypography.labelSmall.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              const Icon(PhosphorIconsFill.star, size: 16, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                '${place.rating} (${place.reviewCount} reviews)',
                                style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimensions.space12),

                          Text(
                            place.name,
                            style: AppTypography.displaySmall.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(PhosphorIconsRegular.mapPin, size: 16, color: AppColors.textTertiary),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  place.address,
                                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimensions.space20),

                          if (place.description.isNotEmpty) ...[
                            Text('ABOUT', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
                            const SizedBox(height: 6),
                            Text(
                              place.description,
                              style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary, height: 1.5),
                            ),
                            const SizedBox(height: AppDimensions.space20),
                          ],

                          if (place.openingHours != null || place.phone != null) ...[
                            Text('USEFUL INFORMATION', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
                            const SizedBox(height: AppDimensions.space8),
                            Container(
                              padding: const EdgeInsets.all(AppDimensions.space14),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceSecondary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  if (place.openingHours != null)
                                    Row(
                                      children: [
                                        const Icon(PhosphorIconsRegular.clock, size: 18, color: AppColors.primary),
                                        const SizedBox(width: 10),
                                        Text('Hours: ', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                                        Text(place.openingHours!, style: AppTypography.bodyMedium),
                                      ],
                                    ),
                                  if (place.phone != null) ...[
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(PhosphorIconsRegular.phone, size: 18, color: AppColors.primary),
                                        const SizedBox(width: 10),
                                        Text('Phone: ', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                                        Text(place.phone!, style: AppTypography.bodyMedium),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: AppDimensions.space24),
                          ],

                          PrimaryButton(
                            label: 'Add to Trip Itinerary',
                            icon: const Icon(PhosphorIconsBold.plus, size: 18),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return AddPlaceToTripSheet(
                                    place: place,
                                    onAdd: (dayNum, startTime) async {
                                      final dayId = 'day-$dayNum';
                                      final body = {
                                        'placeId': place.id,
                                        'title': place.name,
                                        'description': place.description,
                                        'type': place.category.name,
                                        'startTime': startTime,
                                        'imageUrl': place.imageUrl,
                                      };
                                      final res = await ref.read(itineraryProvider('trip-goa-escape').notifier).createActivity(dayId, body);
                                      if (context.mounted && res) {
                                        context.pop();
                                        AppSnackBar.show(context, message: '${place.name} added to Day $dayNum!');
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: AppDimensions.space32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(PhosphorIconsRegular.warningCircle, size: 48, color: AppColors.error),
            const SizedBox(height: 12),
            Text('Place details unavailable', style: AppTypography.titleLarge),
            const SizedBox(height: 16),
            PrimaryButton(label: 'Go Back', onPressed: () => context.pop()),
          ],
        ),
      ),
    );
  }
}
