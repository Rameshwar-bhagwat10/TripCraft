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
import '../../../../shared/widgets/feedback/app_snackbar.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';
import '../../../../shared/widgets/states/empty_state.dart';

import '../../domain/entities/itinerary.dart';
import '../providers/itinerary_provider.dart';
import '../widgets/add_activity_sheet.dart';
import '../widgets/conflict_warning_banner.dart';
import '../widgets/itinerary_day_header.dart';
import '../widgets/itinerary_day_selector.dart';
import '../widgets/itinerary_item_card.dart';
import '../widgets/itinerary_overview.dart';
import '../widgets/timeline_node.dart';

class ItineraryScreen extends ConsumerWidget {
  final String tripId;

  const ItineraryScreen({
    super.key,
    required this.tripId,
  });

  void _openAddActivitySheet(BuildContext context, WidgetRef ref, String dayId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddActivitySheet(
          onSave: (body) async {
            final res = await ref.read(itineraryProvider(tripId).notifier).createActivity(dayId, body);
            if (context.mounted && res) {
              context.pop();
              AppSnackBar.show(context, message: 'Activity added!');
            }
          },
        );
      },
    );
  }

  void _openEditActivitySheet(BuildContext context, WidgetRef ref, dynamic item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddActivitySheet(
          existingItem: item,
          onSave: (body) async {
            final res = await ref.read(itineraryProvider(tripId).notifier).updateActivity(item.id, body);
            if (context.mounted && res) {
              context.pop();
              AppSnackBar.show(context, message: 'Activity updated!');
            }
          },
        );
      },
    );
  }

  void _showEditDayTitleDialog(BuildContext context, WidgetRef ref, String dayId, String? currentTitle) {
    final controller = TextEditingController(text: currentTitle ?? '');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Day Title'),
          content: AppTextField(
            controller: controller,
            hintText: 'e.g. Old Goa & Heritage',
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
            PrimaryButton(
              label: 'Save',
              onPressed: () async {
                final res = await ref.read(itineraryProvider(tripId).notifier).updateDayTitle(dayId, controller.text.trim());
                if (context.mounted && res) {
                  context.pop();
                  AppSnackBar.show(context, message: 'Day title updated');
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(itineraryProvider(tripId));
    final notifier = ref.read(itineraryProvider(tripId).notifier);

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Itinerary Builder',
          style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          // Segmented Switch: Timeline / Overview
          IconButton(
            icon: Icon(
              state.isOverviewMode ? PhosphorIconsBold.listNumbers : PhosphorIconsRegular.cards,
              color: AppColors.primary,
            ),
            tooltip: state.isOverviewMode ? 'Timeline View' : 'Overview View',
            onPressed: () {
              HapticFeedback.selectionClick();
              notifier.toggleOverviewMode();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : RefreshIndicator(
                onRefresh: () async => notifier.loadItinerary(isRefresh: true),
                color: AppColors.primary,
                child: Column(
                  children: [
                    // Day Selector Chips
                    if (state.itinerary != null) ...[
                      const SizedBox(height: AppDimensions.space8),
                      ItineraryDaySelector(
                        days: state.itinerary!.days,
                        selectedIndex: state.selectedDayIndex,
                        onDaySelected: (idx) => notifier.selectDay(idx),
                      ),
                      const SizedBox(height: AppDimensions.space12),
                    ],

                    // View Switcher (Overview vs Active Day Timeline)
                    Expanded(
                      child: state.isOverviewMode
                          ? ItineraryOverview(
                              days: state.itinerary?.days ?? [],
                              onDayTap: (idx) {
                                notifier.selectDay(idx);
                                notifier.toggleOverviewMode();
                              },
                            )
                          : _buildTimelineView(context, ref, state, notifier),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildTimelineView(
    BuildContext context,
    WidgetRef ref,
    ItineraryState state,
    ItineraryNotifier notifier,
  ) {
    final day = state.activeDay;
    if (day == null) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.pageMargin),
        child: EmptyState(
          title: 'No Days Generated',
          description: 'This trip does not have valid dates set.',
          icon: PhosphorIconsRegular.calendar,
        ),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppDimensions.pageMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day Header
          ItineraryDayHeader(
            day: day,
            onEditTitle: () => _showEditDayTitleDialog(context, ref, day.id, day.title),
          ),
          const SizedBox(height: AppDimensions.space16),

          // Conflict Warning Banner
          ConflictWarningBanner(conflicts: state.activeDayConflicts),

          // Timeline Activities or Empty State
          if (day.items.isEmpty) ...[
            EmptyState(
              title: 'Your Day is Wide Open',
              description: 'Start building your itinerary by adding activities, sights, or food spots for Day ${day.dayNumber}.',
              icon: PhosphorIconsRegular.sparkle,
              actionLabel: '+ Add Activity',
              onAction: () => _openAddActivitySheet(context, ref, day.id),
            ),
          ] else ...[
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: day.items.length,
              itemBuilder: (context, index) {
                final item = day.items[index];
                final typeConfig = ActivityTypeConfig.getConfig(item.type);

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Timeline Connector Node
                      TimelineNode(
                        tintColor: typeConfig.tintColor,
                        isFirst: index == 0,
                        isLast: index == day.items.length - 1,
                      ),
                      const SizedBox(width: AppDimensions.space12),

                      // Activity Card Content
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: AppDimensions.space12),
                          child: ItineraryItemCard(
                            item: item,
                            onTap: () => context.push('/trips/$tripId/items/${item.id}'),
                            onEdit: () => _openEditActivitySheet(context, ref, item),
                            onMove: () {
                              final nextDayId = day.dayNumber < 5 ? 'day-${day.dayNumber + 1}' : 'day-1';
                              notifier.moveActivity(item.id, nextDayId);
                              AppSnackBar.show(context, message: 'Moved activity to next day');
                            },
                            onDelete: () async {
                              final res = await notifier.deleteActivity(item.id);
                              if (context.mounted && res) {
                                AppSnackBar.show(context, message: 'Activity deleted');
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: AppDimensions.space16),

            // Add Activity Button
            PrimaryButton(
              label: '+ Add Activity',
              icon: const Icon(PhosphorIconsBold.plus, size: 18),
              onPressed: () => _openAddActivitySheet(context, ref, day.id),
            ),
          ],
          const SizedBox(height: AppDimensions.space32),
        ],
      ),
    );
  }
}