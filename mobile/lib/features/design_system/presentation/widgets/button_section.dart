import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../shared/layouts/section_layout.dart';
import '../../../../shared/widgets/buttons/app_icon_button.dart';
import '../../../../shared/widgets/buttons/destructive_button.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/buttons/secondary_button.dart';
import '../../../../shared/widgets/buttons/tertiary_button.dart';
import '../../../../shared/widgets/cards/app_card.dart';

class ButtonSection extends StatelessWidget {
  const ButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionLayout(
      title: 'Buttons',
      subtitle: 'Primary, Secondary, Tertiary, Destructive, and Icon Buttons',
      child: AppCard(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          children: [
            PrimaryButton(
              label: 'Primary Button',
              onPressed: () {},
              icon: const Icon(PhosphorIconsRegular.paperPlane, size: 20, color: Colors.white),
            ),
            const SizedBox(height: AppDimensions.space12),
            PrimaryButton(
              label: 'Primary Loading',
              onPressed: () {},
              isLoading: true,
            ),
            const SizedBox(height: AppDimensions.space12),
            PrimaryButton(
              label: 'Primary Disabled',
              onPressed: null,
              isDisabled: true,
            ),
            const SizedBox(height: AppDimensions.space16),
            SecondaryButton(
              label: 'Secondary Button',
              onPressed: () {},
              icon: const Icon(PhosphorIconsRegular.bookmarkSimple, size: 20),
            ),
            const SizedBox(height: AppDimensions.space12),
            SecondaryButton(
              label: 'Secondary Loading',
              onPressed: () {},
              isLoading: true,
            ),
            const SizedBox(height: AppDimensions.space16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TertiaryButton(
                  label: 'Tertiary Action',
                  onPressed: () {},
                  icon: const Icon(PhosphorIconsRegular.arrowRight, size: 18),
                ),
                AppIconButton(
                  icon: const Icon(PhosphorIconsRegular.heart),
                  onPressed: () {},
                  tooltip: 'Save',
                ),
                AppIconButton(
                  icon: const Icon(PhosphorIconsRegular.shareNetwork),
                  onPressed: () {},
                  tooltip: 'Share',
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space16),
            DestructiveButton(
              label: 'Destructive Action',
              onPressed: () {},
              icon: const Icon(PhosphorIconsRegular.trash, size: 20, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
