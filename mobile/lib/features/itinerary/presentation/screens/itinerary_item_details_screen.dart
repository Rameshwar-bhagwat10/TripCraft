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

import '../../domain/entities/itinerary.dart';
import '../providers/itinerary_provider.dart';
import '../widgets/add_activity_sheet.dart';

class ItineraryItemDetailsScreen extends ConsumerWidget {
  final String tripId;
  final String itemId;

  const ItineraryItemDetailsScreen({
    super.key,
    required this.tripId,
    required this.itemId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(itineraryProvider(tripId));

    dynamic foundItem;
    if (state.itinerary != null) {
      for (final day in state.itinerary!.days) {
        final match = day.items.where((i) => i.id == itemId);
        if (match.isNotEmpty) {
          foundItem = match.first;
          break;
        }
      }
    }

    if (foundItem == null) {
      return AppScaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          title: const Text('Activity Details'),
        ),
        body: const Center(child: Text('Activity not found')),
      );
    }

    final typeConfig = ActivityTypeConfig.getConfig(foundItem.type);

    return AppScaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 220,
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
                flexibleSpace: FlexibleSpaceBar(
                  background: foundItem.imageUrl != null
                      ? Image.network(
                          foundItem.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.surfaceSecondary,
                            child: Center(
                              child: Icon(typeConfig.icon, size: 48, color: typeConfig.tintColor),
                            ),
                          ),
                        )
                      : Container(
                          color: AppColors.surfaceSecondary,
                          child: Center(
                            child: Icon(typeConfig.icon, size: 48, color: typeConfig.tintColor),
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
                      // Category Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: typeConfig.tintColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(typeConfig.icon, size: 14, color: typeConfig.tintColor),
                            const SizedBox(width: 6),
                            Text(
                              typeConfig.label.toUpperCase(),
                              style: AppTypography.labelSmall.copyWith(
                                color: typeConfig.tintColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.space12),

                      Text(
                        foundItem.title,
                        style: AppTypography.displaySmall.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: AppDimensions.space12),

                      // Time Info Row
                      Row(
                        children: [
                          const Icon(PhosphorIconsRegular.clock, size: 18, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            foundItem.isAllDay
                                ? 'ALL DAY EVENT'
                                : '${foundItem.startTime ?? "09:00"} - ${foundItem.endTime ?? "10:30"} (${foundItem.duration ?? "1h 30m"})',
                            style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.space20),

                      if (foundItem.description != null && foundItem.description!.isNotEmpty) ...[
                        Text(
                          'DESCRIPTION',
                          style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          foundItem.description!,
                          style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary, height: 1.5),
                        ),
                        const SizedBox(height: AppDimensions.space20),
                      ],

                      if (foundItem.notes != null && foundItem.notes!.isNotEmpty) ...[
                        Text(
                          'NOTES & HIGHLIGHTS',
                          style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.all(AppDimensions.space14),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(PhosphorIconsRegular.note, size: 18, color: AppColors.primary),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  foundItem.notes!,
                                  style: AppTypography.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDimensions.space24),
                      ],

                      // Actions
                      PrimaryButton(
                        label: 'Edit Activity',
                        icon: const Icon(PhosphorIconsBold.pencilSimple, size: 18),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return AddActivitySheet(
                                existingItem: foundItem,
                                onSave: (body) async {
                                  final res = await ref.read(itineraryProvider(tripId).notifier).updateActivity(itemId, body);
                                  if (context.mounted && res) {
                                    context.pop();
                                    AppSnackBar.show(context, message: 'Activity updated');
                                  }
                                },
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: AppDimensions.space12),
                      OutlinedButton(
                        onPressed: () async {
                          final res = await ref.read(itineraryProvider(tripId).notifier).deleteActivity(itemId);
                          if (context.mounted && res) {
                            AppSnackBar.show(context, message: 'Activity deleted');
                            context.pop();
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Delete Activity', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
