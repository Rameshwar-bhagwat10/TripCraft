import 'package:flutter/material.dart';
import '../../app/app_colors.dart';
import '../../app/app_dimensions.dart';
import '../../app/app_typography.dart';

/// Reusable Section Container Structure for future features.
class SectionLayout extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailingAction;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const SectionLayout({
    super.key,
    required this.title,
    this.subtitle,
    this.trailingAction,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: AppDimensions.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.titleLarge),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppDimensions.space4),
                      Text(
                        subtitle!,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailingAction != null) trailingAction!,
            ],
          ),
          const SizedBox(height: AppDimensions.space16),
          child,
        ],
      ),
    );
  }
}