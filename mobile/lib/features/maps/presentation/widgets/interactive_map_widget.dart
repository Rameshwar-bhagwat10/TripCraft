import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_typography.dart';
import '../../domain/entities/geo_point.dart';
import '../../domain/entities/map_marker.dart';

class InteractiveMapWidget extends StatefulWidget {
  final List<MapMarker> markers;
  final List<GeoPoint> routePoints;
  final String? selectedMarkerId;
  final ValueChanged<MapMarker>? onMarkerSelected;
  final VoidCallback? onFitTrip;
  final VoidCallback? onFitRoute;

  const InteractiveMapWidget({
    super.key,
    this.markers = const [],
    this.routePoints = const [],
    this.selectedMarkerId,
    this.onMarkerSelected,
    this.onFitTrip,
    this.onFitRoute,
  });

  @override
  State<InteractiveMapWidget> createState() => _InteractiveMapWidgetState();
}

class _InteractiveMapWidgetState extends State<InteractiveMapWidget> {
  double _zoom = 1.0;
  Offset _panOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF1F5F9), // Soft map canvas background
      child: Stack(
        children: [
          // Map Canvas Background & Grid Lines
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _panOffset += details.delta;
              });
            },
            child: CustomPaint(
              size: Size.infinite,
              painter: _MapCanvasPainter(
                markers: widget.markers,
                routePoints: widget.routePoints,
                selectedMarkerId: widget.selectedMarkerId,
                panOffset: _panOffset,
                zoom: _zoom,
              ),
            ),
          ),

          // Render Interactive Overlay Pins
          ...widget.markers.asMap().entries.map((entry) {
            final idx = entry.key;
            final marker = entry.value;
            final isSelected = marker.id == widget.selectedMarkerId;

            // Compute layout offset based on index spacing
            final double posX = 120.0 + (idx * 65.0) + _panOffset.dx;
            final double posY = 220.0 + ((idx % 2 == 0 ? 30 : -40)) + _panOffset.dy;

            return Positioned(
              left: posX - 20,
              top: posY - 40,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  widget.onMarkerSelected?.call(marker);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 2.5 : 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.35)
                            : Colors.black.withValues(alpha: 0.1),
                        blurRadius: isSelected ? 12 : 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : AppColors.primarySurface,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${marker.sequenceNumber ?? idx + 1}',
                            style: AppTypography.labelSmall.copyWith(
                              color: isSelected ? AppColors.primary : AppColors.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 90),
                        child: Text(
                          marker.title,
                          style: AppTypography.labelSmall.copyWith(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          // Floating Map Controls (Zoom In/Out, Fit Bounds)
          Positioned(
            right: 16,
            top: 100,
            child: Column(
              children: [
                _buildControlButton(
                  icon: PhosphorIconsBold.plus,
                  onPressed: () => setState(() => _zoom = (_zoom + 0.2).clamp(0.5, 3.0)),
                ),
                const SizedBox(height: 8),
                _buildControlButton(
                  icon: PhosphorIconsBold.minus,
                  onPressed: () => setState(() => _zoom = (_zoom - 0.2).clamp(0.5, 3.0)),
                ),
                const SizedBox(height: 8),
                _buildControlButton(
                  icon: PhosphorIconsBold.cornersOut,
                  onPressed: () {
                    setState(() {
                      _panOffset = Offset.zero;
                      _zoom = 1.0;
                    });
                    widget.onFitTrip?.call();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 18, color: AppColors.textPrimary),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class _MapCanvasPainter extends CustomPainter {
  final List<MapMarker> markers;
  final List<GeoPoint> routePoints;
  final String? selectedMarkerId;
  final Offset panOffset;
  final double zoom;

  _MapCanvasPainter({
    required this.markers,
    required this.routePoints,
    this.selectedMarkerId,
    required this.panOffset,
    required this.zoom,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final polylinePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Background water curve
    final waterPaint = Paint()..color = const Color(0xFFE0F2FE);
    final waterPath = Path()
      ..moveTo(0, size.height * 0.4)
      ..cubicTo(size.width * 0.3, size.height * 0.3, size.width * 0.6, size.height * 0.6, size.width, size.height * 0.5)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(waterPath, waterPaint);

    // Connecting Route Polyline between markers
    if (markers.length >= 2) {
      final routePath = Path();
      for (int i = 0; i < markers.length; i++) {
        final double posX = 120.0 + (i * 65.0) + panOffset.dx;
        final double posY = 220.0 + ((i % 2 == 0 ? 30 : -40)) + panOffset.dy;
        if (i == 0) {
          routePath.moveTo(posX, posY);
        } else {
          routePath.lineTo(posX, posY);
        }
      }
      canvas.drawPath(routePath, polylinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MapCanvasPainter oldDelegate) => true;
}
