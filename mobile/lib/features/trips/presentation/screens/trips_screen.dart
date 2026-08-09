import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/feedback/app_snackbar.dart';
import '../../../../shared/widgets/states/empty_state.dart';

import '../providers/trips_provider.dart';
import '../widgets/trip_card.dart';

class TripsScreen extends ConsumerWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsState = ref.watch(tripsProvider);
    final notifier = ref.read(tripsProvider.notifier);

    List dynamicTrips;
    switch (tripsState.selectedTab) {
      case 1:
        dynamicTrips = tripsState.pastTrips;
        break;
      case 2:
        dynamicTrips = tripsState.archivedTrips;
        break;
      case 0:
      default:
        dynamicTrips = tripsState.upcomingTrips;
        break;
    }

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Trips',
          style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsBold.plus, color: AppColors.primary),
            onPressed: () {
              HapticFeedback.selectionClick();
              context.push('/trips/create');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Segmented Control Tabs (Upcoming | Past | Archived)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageMargin, vertical: AppDimensions.space8),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    _buildSegmentTab(
                      context,
                      label: 'Upcoming (${tripsState.upcomingTrips.length})',
                      isSelected: tripsState.selectedTab == 0,
                      onTap: () => notifier.setSelectedTab(0),
                    ),
                    _buildSegmentTab(
                      context,
                      label: 'Past (${tripsState.pastTrips.length})',
                      isSelected: tripsState.selectedTab == 1,
                      onTap: () => notifier.setSelectedTab(1),
                    ),
                    _buildSegmentTab(
                      context,
                      label: 'Archived (${tripsState.archivedTrips.length})',
                      isSelected: tripsState.selectedTab == 2,
                      onTap: () => notifier.setSelectedTab(2),
                    ),
                  ],
                ),
              ),
            ),

            // Main Content Area
            Expanded(
              child: tripsState.isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : RefreshIndicator(
                      onRefresh: () async => notifier.loadTrips(isRefresh: true),
                      color: AppColors.primary,
                      child: dynamicTrips.isEmpty
                          ? SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(AppDimensions.pageMargin),
                              child: EmptyState(
                                title: tripsState.selectedTab == 0
                                    ? 'Your Next Adventure Awaits'
                                    : tripsState.selectedTab == 1
                                        ? 'No Past Trips Yet'
                                        : 'No Archived Trips',
                                description: tripsState.selectedTab == 0
                                    ? 'Create your first trip or explore top destinations to start planning something memorable.'
                                    : 'Completed journeys will appear here.',
                                icon: PhosphorIconsRegular.suitcase,
                                actionLabel: tripsState.selectedTab == 0 ? 'Plan a Trip' : 'Explore Destinations',
                                onAction: () {
                                  if (tripsState.selectedTab == 0) {
                                    context.push('/trips/create');
                                  } else {
                                    context.go('/explore');
                                  }
                                },
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.all(AppDimensions.pageMargin),
                              itemCount: dynamicTrips.length,
                              separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.space16),
                              itemBuilder: (context, index) {
                                final trip = dynamicTrips[index];
                                return TripCard(
                                  trip: trip,
                                  onTap: () => context.push('/trips/${trip.id}'),
                                  onEdit: () => context.push('/trips/${trip.id}/edit'),
                                  onArchive: () async {
                                    final res = await notifier.archiveTrip(trip.id);
                                    if (context.mounted && res) {
                                      AppSnackBar.show(context, message: 'Trip archived');
                                    }
                                  },
                                  onRestore: () async {
                                    final res = await notifier.restoreTrip(trip.id);
                                    if (context.mounted && res) {
                                      AppSnackBar.show(context, message: 'Trip restored');
                                    }
                                  },
                                  onDelete: () async {
                                    final res = await notifier.deleteTrip(trip.id);
                                    if (context.mounted && res) {
                                      AppSnackBar.show(context, message: 'Trip deleted');
                                    }
                                  },
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentTab(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.05),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.labelSmall.copyWith(
              color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}