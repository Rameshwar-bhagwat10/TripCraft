import 'package:flutter/material.dart';
import '../../../app/app_dimensions.dart';
import '../../../app/app_typography.dart';
import '../buttons/destructive_button.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';

/// Reusable Confirmation Dialog in TripCraft.
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final bool isDestructive;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    required this.onConfirm,
    this.isDestructive = false,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    required VoidCallback onConfirm,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: onConfirm,
        isDestructive: isDestructive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: AppTypography.titleLarge),
      content: Text(message, style: AppTypography.bodyMedium),
      actionsPadding: const EdgeInsets.all(AppDimensions.space16),
      actions: [
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                label: cancelLabel,
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ),
            const SizedBox(width: AppDimensions.space12),
            Expanded(
              child: isDestructive
                  ? DestructiveButton(
                      label: confirmLabel,
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        onConfirm();
                      },
                    )
                  : PrimaryButton(
                      label: confirmLabel,
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        onConfirm();
                      },
                    ),
            ),
          ],
        ),
      ],
    );
  }
}