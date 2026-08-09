import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../itinerary/presentation/providers/itinerary_provider.dart';
import '../../domain/entities/geo_point.dart';
import '../../domain/entities/map_marker.dart';
import '../widgets/interactive_map_widget.dart';

class TripMapScreen extends ConsumerStatefulWidget {
  final String tripId;

  const TripMapScreen({
    super.key,
    required this.tripId,
  });

  @override
  ConsumerState<TripMapScreen> createState() => _TripMapScreenState();
}

class _TripMapScreenState extends ConsumerState<TripMapScreen> {
  String? _selectedMarkerId;

  final List<MapMarker> _defaultMarkers = const [
    MapMarker(
      id: 'item-1',
      title: 'Cafe Bodega',
      position: GeoPoint(latitude: 15.4962, longitude: 73.8315),
      sequenceNumber: 1,
    ),
    MapMarker(
      id: 'item-2',
      title: 'Fort Aguada',
      position: GeoPoint(latitude: 15.4989, longitude: 73.7725),
      sequenceNumber: 2,
    ),
    MapMarker(
      id: 'item-3',
      title: 'Brittos Shack',
      position: GeoPoint(latitude: 15.5553, longitude: 73.7517),
      sequenceNumber: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final itineraryState = ref.watch(itineraryProvider(widget.tripId));

    List<MapMarker> mapMarkers = _defaultMarkers;
    if (itineraryState.activeDay != null && itineraryState.activeDay!.items.isNotEmpty) {
      mapMarkers = itineraryState.activeDay!.items.asMap().entries.map((e) {
        final idx = e.key;
        final item = e.value;
        return MapMarker(
          id: item.id,
          title: item.title,
          position: GeoPoint(
            latitude: 15.4989 + (idx * 0.02),
            longitude: 73.7725 + (idx * 0.015),
          ),
          sequenceNumber: idx + 1,
        );
      }).toList();
    }

    return AppScaffold(
      body: Stack(
        children: [
          // Spatial Map Canvas
          InteractiveMapWidget(
            markers: mapMarkers,
            selectedMarkerId: _selectedMarkerId,
            onMarkerSelected: (marker) {
              setState(() => _selectedMarkerId = marker.id);
            },
          ),

          // Floating Top Search Bar & Back Button Overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.pageMargin),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary, size: 20),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.space10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.push('/explore/places'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.border),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.08),
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(PhosphorIconsRegular.magnifyingGlass, size: 18, color: AppColors.textTertiary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Search places, food, sights...',
                                style: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Draggable Bottom Sheet (Collapsed Summary / Expanded List)
          DraggableScrollableSheet(
            initialChildSize: 0.28,
            minChildSize: 0.16,
            maxChildSize: 0.70,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.12),
                      blurRadius: 16,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppDimensions.pageMargin),
                  children: [
                    // Sheet Drag Indicator
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space12),

                    // Trip Route Summary Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today\'s Map Route',
                              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800),
                            ),
                            Text(
                              '${mapMarkers.length} stops · 42.6 km (1h 35m)',
                              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(PhosphorIconsRegular.navigationArrow, color: AppColors.primary),
                              onPressed: () => context.push('/trips/${widget.tripId}/days/day-1/route'),
                              tooltip: 'Route Details',
                            ),
                            IconButton(
                              icon: const Icon(PhosphorIconsBold.sparkle, color: AppColors.primary),
                              onPressed: () => context.push('/trips/${widget.tripId}/days/day-1/intelligence'),
                              tooltip: 'Route Intelligence',
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.space16),

                    // Stops Cards List
                    ...mapMarkers.asMap().entries.map((e) {
                      final idx = e.key;
                      final marker = e.value;
                      final isSelected = marker.id == _selectedMarkerId;

                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedMarkerId = marker.id);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: AppDimensions.space10),
                          padding: const EdgeInsets.all(AppDimensions.space12),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primarySurface : AppColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.border,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary : AppColors.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${idx + 1}',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: isSelected ? Colors.white : AppColors.textPrimary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppDimensions.space12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      marker.title,
                                      style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      'Stop ${idx + 1} on Day 1',
                                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(PhosphorIconsRegular.caretRight, size: 16, color: AppColors.textTertiary),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
