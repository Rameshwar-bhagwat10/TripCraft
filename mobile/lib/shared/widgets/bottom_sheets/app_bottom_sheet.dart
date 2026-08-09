import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_dimensions.dart';
import '../../../app/app_typography.dart';

/// Reusable Bottom Sheet Primitive for TripCraft.
class AppBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final List<Widget>? actions;

  const AppBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.actions,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required Widget child,
    List<Widget>? actions,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppDimensions.bottomSheetRadius,
      ),
      builder: (context) => AppBottomSheet(
        title: title,
        actions: actions,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag Handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: AppDimensions.space12),
                width: AppDimensions.bottomSheetHandleWidth,
                height: AppDimensions.bottomSheetHandleHeight,
                decoration: BoxDecoration(
                  color: AppColors.borderStrong,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            if (title != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.space20,
                  AppDimensions.space16,
                  AppDimensions.space20,
                  AppDimensions.space8,
                ),
                child: Text(
                  title!,
                  style: AppTypography.titleLarge,
                ),
              ),
              const Divider(),
            ],
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.space20),
                child: child,
              ),
            ),
            if (actions != null && actions!.isNotEmpty) ...[
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(AppDimensions.space16),
                child: Row(
                  children: actions!
                      .map((widget) => Expanded(child: widget))
                      .toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}