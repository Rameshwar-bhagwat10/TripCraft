import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';

import '../../domain/entities/destination.dart';
import '../providers/explore_provider.dart';
import '../widgets/activity_card.dart';

class DestinationDetailsScreen extends ConsumerWidget {
  final String destinationId;

  const DestinationDetailsScreen({
    super.key,
    required this.destinationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destAsync = ref.watch(destinationDetailsProvider(destinationId));
    final exploreNotifier = ref.read(exploreProvider.notifier);

    return AppScaffold(
      body: destAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (_, __) => _buildErrorState(context),
        data: (dest) => _buildDetailsContent(context, dest, exploreNotifier),
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
            Text('Destination unavailable', style: AppTypography.titleLarge),
            const SizedBox(height: 8),
            Text(
              'This destination could not be loaded.',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Back to Explore',
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsContent(BuildContext context, Destination dest, ExploreNotifier notifier) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // Collapsing Hero Image App Bar
            SliverAppBar(
              expandedHeight: 280,
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
                      icon: const Icon(PhosphorIconsRegular.shareNetwork, color: AppColors.textPrimary, size: 20),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: const Text('Sharing destination link...')),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: Icon(
                        dest.isSaved ? PhosphorIconsFill.bookmark : PhosphorIconsRegular.bookmark,
                        color: dest.isSaved ? AppColors.primary : AppColors.textPrimary,
                        size: 20,
                      ),
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        notifier.toggleSaveDestination(dest.id);
                      },
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  dest.heroImage,
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

            // Content Body
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.pageMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dest.name,
                                style: AppTypography.displaySmall.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(PhosphorIconsRegular.mapPin, size: 14, color: AppColors.textTertiary),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${dest.city}, ${dest.country}',
                                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(PhosphorIconsFill.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${dest.rating}',
                                style: AppTypography.labelMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.space20),

                    // Description
                    Text(
                      dest.description,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space24),

                    // Highlights Section
                    if (dest.highlights.isNotEmpty) ...[
                      Text(
                        'HIGHLIGHTS',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textTertiary,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.space10),
                      Wrap(
                        spacing: AppDimensions.space8,
                        runSpacing: AppDimensions.space8,
                        children: dest.highlights.map((item) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceSecondary,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(PhosphorIconsRegular.sparkle, size: 14, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Text(item, style: AppTypography.bodySmall),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: AppDimensions.space28),
                    ],

                    // Things to do Preview
                    if (dest.activities.isNotEmpty) ...[
                      Text(
                        'THINGS TO DO',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textTertiary,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.space10),
                      SizedBox(
                        height: 110,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: dest.activities.length,
                          separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.space12),
                          itemBuilder: (context, index) {
                            return ActivityCard(
                              title: dest.activities[index],
                              category: 'Must Visit',
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: AppDimensions.space28),
                    ],

                    // Info Section: Best Time & Daily Budget
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(AppDimensions.space14),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(PhosphorIconsRegular.calendar, color: AppColors.primary, size: 20),
                                const SizedBox(height: 8),
                                Text(
                                  'BEST TIME TO VISIT',
                                  style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  dest.bestTimeToVisit ?? 'Year Round',
                                  style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.space12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(AppDimensions.space14),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(PhosphorIconsRegular.wallet, color: AppColors.primary, size: 20),
                                const SizedBox(height: 8),
                                Text(
                                  'ESTIMATED BUDGET',
                                  style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  dest.budgetRange,
                                  style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 100), // Space for bottom action bar
                  ],
                ),
              ),
            ),
          ],
        ),

        // Sticky Bottom Action Bar
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.space16),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                  blurRadius: 10,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: PrimaryButton(
                label: 'Plan a Trip',
                icon: const Icon(PhosphorIconsBold.suitcase, size: 18),
                onPressed: () {
                  context.push('/trips/create?destinationId=${dest.id}');
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}