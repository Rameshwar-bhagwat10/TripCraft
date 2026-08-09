import 'package:flutter/material.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/section_layout.dart';
import '../../../../shared/widgets/bottom_sheets/app_bottom_sheet.dart';
import '../../../../shared/widgets/buttons/destructive_button.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/buttons/secondary_button.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../../../shared/widgets/dialogs/confirmation_dialog.dart';
import '../../../../shared/widgets/dialogs/error_dialog.dart';
import '../../../../shared/widgets/feedback/app_snackbar.dart';

class DialogSection extends StatelessWidget {
  const DialogSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionLayout(
      title: 'Dialogs, Sheets & Feedback',
      subtitle: 'Modals, bottom sheets, alert dialogs, and toast notifications',
      child: AppCard(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          children: [
            SecondaryButton(
              label: 'Show Confirmation Dialog',
              onPressed: () {
                ConfirmationDialog.show(
                  context,
                  title: 'Delete Itinerary Item?',
                  message: 'Are you sure you want to remove this activity from your day plan?',
                  confirmLabel: 'Delete',
                  isDestructive: true,
                  onConfirm: () {},
                );
              },
            ),
            const SizedBox(height: AppDimensions.space12),
            SecondaryButton(
              label: 'Show Error Dialog',
              onPressed: () {
                ErrorDialog.show(
                  context,
                  title: 'Sync Error',
                  message: 'Could not sync trip changes with the cloud database.',
                );
              },
            ),
            const SizedBox(height: AppDimensions.space12),
            SecondaryButton(
              label: 'Open Bottom Sheet',
              onPressed: () {
                AppBottomSheet.show(
                  context,
                  title: 'Select Travel Category',
                  child: Column(
                    children: [
                      Text('Choose a travel theme to filter destinations.', style: AppTypography.bodyMedium),
                      const SizedBox(height: 20),
                      PrimaryButton(
                        label: 'Apply Filters',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: AppDimensions.space12),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: 'Success Toast',
                    onPressed: () {
                      AppSnackBar.show(
                        context,
                        message: 'Trip saved successfully!',
                        variant: AppSnackBarVariant.success,
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppDimensions.space8),
                Expanded(
                  child: DestructiveButton(
                    label: 'Error Toast',
                    onPressed: () {
                      AppSnackBar.show(
                        context,
                        message: 'Failed to update preferences',
                        variant: AppSnackBarVariant.error,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
