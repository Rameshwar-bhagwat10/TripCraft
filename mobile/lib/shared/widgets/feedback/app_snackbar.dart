import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_dimensions.dart';
import '../../../app/app_typography.dart';

enum AppSnackBarVariant {
  success,
  error,
  warning,
  info,
}

/// Reusable Feedback SnackBar Presenter in TripCraft.
abstract class AppSnackBar {
  const AppSnackBar._();

  static void show(
    BuildContext context, {
    required String message,
    AppSnackBarVariant variant = AppSnackBarVariant.info,
    Duration duration = const Duration(seconds: 4),
  }) {
    Color bg;
    IconData iconData;

    switch (variant) {
      case AppSnackBarVariant.success:
        bg = AppColors.success;
        iconData = PhosphorIconsRegular.checkCircle;
        break;
      case AppSnackBarVariant.error:
        bg = AppColors.error;
        iconData = PhosphorIconsRegular.warningCircle;
        break;
      case AppSnackBarVariant.warning:
        bg = AppColors.warning;
        iconData = PhosphorIconsRegular.warning;
        break;
      case AppSnackBarVariant.info:
        bg = AppColors.textPrimary;
        iconData = PhosphorIconsRegular.info;
        break;
    }

    final snackBar = SnackBar(
      backgroundColor: bg,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: AppDimensions.borderMD,
      ),
      content: Row(
        children: [
          Icon(iconData, color: Colors.white, size: AppDimensions.iconMD),
          const SizedBox(width: AppDimensions.space12),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodyMedium.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
