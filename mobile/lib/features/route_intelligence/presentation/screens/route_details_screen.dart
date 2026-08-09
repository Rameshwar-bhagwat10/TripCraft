import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../features/maps/domain/providers/routing_provider.dart';

import '../providers/route_intelligence_provider.dart';

class RouteDetailsScreen extends ConsumerWidget {
  final String tripId;
  final String dayId;

  const RouteDetailsScreen({
    super.key,
    required this.tripId,
    required this.dayId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = '$tripId:$dayId';
    final state = ref.watch(routeIntelligenceProvider(key));
    final notifier = ref.read(routeIntelligenceProvider(key).notifier);

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Route Details', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.pageMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Transport Mode Selector Bar
                    Text('TRANSPORT MODE', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
                    const SizedBox(height: AppDimensions.space8),
                    Row(
                      children: TransportMode.values.map((mode) {
                        final isSelected = state.selectedTransportMode == mode;
                        IconData iconData = PhosphorIconsRegular.car;
                        if (mode == TransportMode.walking) iconData = PhosphorIconsRegular.footprints;
                        if (mode == TransportMode.cycling) iconData = PhosphorIconsRegular.bicycle;
                        if (mode == TransportMode.transit) iconData = PhosphorIconsRegular.bus;

                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              notifier.setTransportMode(mode);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : AppColors.surfaceSecondary,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                              ),
                              child: Column(
                                children: [
                                  Icon(iconData, size: 18, color: isSelected ? Colors.white : AppColors.textPrimary),
                                  const SizedBox(height: 4),
                                  Text(
                                    mode.name.toUpperCase(),
                                    style: AppTypography.labelSmall.copyWith(
                                      color: isSelected ? Colors.white : AppColors.textSecondary,
                                      fontSize: 10,
                                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppDimensions.space20),

                    // Route Distance & Time Summary Card
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.space16),
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text('TOTAL DISTANCE', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary)),
                              const SizedBox(height: 4),
                              Text(
                                '${state.analysis?.totalDistanceKm ?? 42.6} km',
                                style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                          Container(width: 1, height: 32, color: AppColors.border),
                          Column(
                            children: [
                              Text('ESTIMATED TIME', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary)),
                              const SizedBox(height: 4),
                              Text(
                                '${state.analysis?.totalDurationMins ?? 95} mins',
                                style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space24),

                    // Route Segments Timeline List
                    Text('ROUTE SEGMENTS', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
                    const SizedBox(height: AppDimensions.space12),

                    if (state.analysis?.segments != null)
                      ...state.analysis!.segments.map((seg) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: AppDimensions.space12),
                          padding: const EdgeInsets.all(AppDimensions.space14),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(PhosphorIconsRegular.mapPin, size: 16, color: AppColors.primary),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      seg['fromTitle'] as String? ?? 'Origin',
                                      style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 7, top: 4, bottom: 4),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceSecondary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '↓ ${seg["durationMins"]} mins (${seg["distanceKm"]} km)',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(PhosphorIconsRegular.mapPin, size: 16, color: AppColors.primary),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      seg['toTitle'] as String? ?? 'Destination',
                                      style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              ),
      ),
    );
  }
}
