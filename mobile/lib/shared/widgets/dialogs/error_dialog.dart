import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_dimensions.dart';
import '../../../app/app_typography.dart';
import '../buttons/primary_button.dart';

/// Reusable Error Alert Dialog Component in TripCraft.
class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonLabel;

  const ErrorDialog({
    super.key,
    this.title = 'Error',
    required this.message,
    this.buttonLabel = 'OK',
  });

  static Future<void> show(
    BuildContext context, {
    String title = 'Error',
    required String message,
    String buttonLabel = 'OK',
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => ErrorDialog(
        title: title,
        message: message,
        buttonLabel: buttonLabel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(
            PhosphorIconsRegular.warningCircle,
            color: AppColors.error,
            size: AppDimensions.iconLG,
          ),
          const SizedBox(width: AppDimensions.space8),
          Expanded(child: Text(title, style: AppTypography.titleLarge)),
        ],
      ),
      content: Text(message, style: AppTypography.bodyMedium),
      actionsPadding: const EdgeInsets.all(AppDimensions.space16),
      actions: [
        PrimaryButton(
          label: buttonLabel,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}