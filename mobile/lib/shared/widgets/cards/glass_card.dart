import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_dimensions.dart';

/// Specialized Glassmorphic Card for hero/overlay visuals in TripCraft.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppDimensions.cardRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding ?? const EdgeInsets.all(AppDimensions.space16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.75),
            borderRadius: AppDimensions.cardRadius,
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.8),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}