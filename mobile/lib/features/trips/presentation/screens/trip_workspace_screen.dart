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

import '../providers/trips_provider.dart';
import '../widgets/trip_module_row.dart';
import '../widgets/trip_status_badge.dart';

class TripWorkspaceScreen extends ConsumerWidget {
  final String tripId;

  const TripWorkspaceScreen({
    super.key,
    required this.tripId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripAsync = ref.watch(tripDetailsProvider(tripId));

    return AppScaffold(
      body: tripAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, __) => _buildErrorState(context),
        data: (trip) {
          final locationText = trip.destination != null
              ? '${trip.destination!.city}, ${trip.destination!.country}'
              : 'Destination';

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  // Hero Cover Bar
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
                          child: PopupMenuButton<String>(
                            icon: const Icon(PhosphorIconsBold.dotsThree, color: AppColors.textPrimary, size: 20),
                            onSelected: (value) async {
                              if (value == 'edit') {
                                context.push('/trips/${trip.id}/edit');
                              } else if (value == 'archive') {
                                final res = await ref.read(tripsProvider.notifier).archiveTrip(trip.id);
                                if (context.mounted && res) {
                                  AppSnackBar.show(context, message: 'Trip archived');
                                  context.pop();
                                }
                              } else if (value == 'delete') {
                                final res = await ref.read(tripsProvider.notifier).deleteTrip(trip.id);
                                if (context.mounted && res) {
                                  AppSnackBar.show(context, message: 'Trip deleted');
                                  context.pop();
                                }
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(PhosphorIconsRegular.pencilSimple, size: 16),
                                    SizedBox(width: 8),
                                    Text('Edit Trip'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'archive',
                                child: Row(
                                  children: [
                                    Icon(PhosphorIconsRegular.archive, size: 16),
                                    SizedBox(width: 8),
                                    Text('Archive Trip'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(PhosphorIconsRegular.trash, size: 16, color: AppColors.error),
                                    SizedBox(width: 8),
                                    Text('Delete Trip', style: TextStyle(color: AppColors.error)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.network(
                        trip.coverImage,
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
                          // Status & Title
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TripStatusBadge(status: trip.status),
                              Text(
                                '${trip.durationDays} DAYS',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.textTertiary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimensions.space8),
                          Text(
                            trip.title,
                            style: AppTypography.displaySmall.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(PhosphorIconsRegular.mapPin, size: 14, color: AppColors.textTertiary),
                              const SizedBox(width: 4),
                              Text(
                                locationText,
                                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimensions.space16),

                          // Summary Strip
                          Container(
                            padding: const EdgeInsets.all(AppDimensions.space14),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceSecondary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    const Icon(PhosphorIconsRegular.calendar, size: 18, color: AppColors.primary),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${trip.startDate} - ${trip.endDate}',
                                      style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      'Dates',
                                      style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
                                    ),
                                  ],
                                ),
                                Container(width: 1, height: 32, color: AppColors.border),
                                Column(
                                  children: [
                                    const Icon(PhosphorIconsRegular.users, size: 18, color: AppColors.primary),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${trip.travelersCount} Travelers',
                                      style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      'Party',
                                      style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppDimensions.space24),

                          // Primary Planning Action Hero Banner
                          Container(
                            padding: const EdgeInsets.all(AppDimensions.space20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.15),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(PhosphorIconsFill.sparkle, color: Colors.amber, size: 20),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'SMART TRIP INTELLIGENCE',
                                      style: AppTypography.labelSmall.copyWith(
                                        color: Colors.white70,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Weather & Itinerary Health',
                                  style: AppTypography.titleLarge.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Real-time destination weather, rain risk analysis & smart recommendations.',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                PrimaryButton(
                                  label: 'View Trip Intelligence',
                                  icon: const Icon(PhosphorIconsBold.sparkle, size: 18),
                                  onPressed: () {
                                    HapticFeedback.mediumImpact();
                                    context.push('/trips/${trip.id}/intelligence');
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppDimensions.space28),

                          // Module Groups Section
                          Text(
                            'PLANNING MODULES',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textTertiary,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.space12),

                          TripModuleRow(
                            icon: PhosphorIconsRegular.calendarCheck,
                            title: 'Itinerary Schedules',
                            subtitle: 'Day-by-day activities & timelines',
                            badgeText: 'Primary',
                            onTap: () {
                              context.push('/trips/${trip.id}/itinerary');
                            },
                          ),
                          const SizedBox(height: AppDimensions.space10),
                          TripModuleRow(
                            icon: PhosphorIconsRegular.mapPin,
                            title: 'Map & Saved Places',
                            subtitle: 'Interactive map pins & routes',
                            badgeText: 'Active',
                            onTap: () {
                              context.push('/trips/${trip.id}/map');
                            },
                          ),
                          const SizedBox(height: AppDimensions.space10),
                          TripModuleRow(
                            icon: PhosphorIconsRegular.cloudSun,
                            title: 'Destination Weather',
                            subtitle: 'Live weather & 5-day forecast',
                            badgeText: 'Active',
                            onTap: () {
                              context.push('/trips/${trip.id}/weather');
                            },
                          ),
                          const SizedBox(height: AppDimensions.space24),

                          Text(
                            'PEOPLE & RESERVATIONS',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textTertiary,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.space12),

                          const TripModuleRow(
                            icon: PhosphorIconsRegular.users,
                            title: 'Trip Members',
                            subtitle: 'You (Owner)',
                            badgeText: 'Active',
                          ),
                          const SizedBox(height: AppDimensions.space10),
                          const TripModuleRow(
                            icon: PhosphorIconsRegular.ticket,
                            title: 'Bookings & Reservations',
                            subtitle: 'Hotels, flights & tickets',
                            badgeText: 'Coming Soon',
                            isAvailable: false,
                          ),
                          const SizedBox(height: AppDimensions.space10),
                          const TripModuleRow(
                            icon: PhosphorIconsRegular.wallet,
                            title: 'Expenses & Budget',
                            subtitle: 'Track spending & split costs',
                            badgeText: 'Coming Soon',
                            isAvailable: false,
                          ),
                          const SizedBox(height: AppDimensions.space24),

                          Text(
                            'INTELLIGENCE & MEMORIES',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textTertiary,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.space12),

                          TripModuleRow(
                            icon: PhosphorIconsRegular.sparkle,
                            title: 'AI Travel Copilot & Health',
                            subtitle: 'Weather risk alerts & schedule optimizer',
                            badgeText: 'Active',
                            onTap: () {
                              context.push('/trips/${trip.id}/intelligence');
                            },
                          ),
                          const SizedBox(height: AppDimensions.space10),
                          const TripModuleRow(
                            icon: PhosphorIconsRegular.image,
                            title: 'Memories & Photos',
                            subtitle: 'Trip photo gallery & journal',
                            badgeText: 'Coming Soon',
                            isAvailable: false,
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
            Text('Trip unavailable', style: AppTypography.titleLarge),
            const SizedBox(height: 8),
            Text(
              'This trip could not be loaded.',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Back to Trips',
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
