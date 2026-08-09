import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../shared/layouts/section_layout.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../../../shared/widgets/chips/app_chip.dart';

class ChipSection extends StatelessWidget {
  const ChipSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionLayout(
      title: 'Chips',
      subtitle: 'Filter and status selection chips',
      child: AppCard(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Wrap(
          spacing: AppDimensions.space8,
          runSpacing: AppDimensions.space8,
          children: const [
            AppChip(label: 'Standard'),
            AppChip(label: 'Selected', isSelected: true),
            AppChip(label: 'Outlined', variant: AppChipVariant.outlined),
            AppChip(
              label: 'Success',
              variant: AppChipVariant.success,
              icon: Icon(PhosphorIconsRegular.check, size: 14),
            ),
            AppChip(
              label: 'Warning',
              variant: AppChipVariant.warning,
              icon: Icon(PhosphorIconsRegular.warning, size: 14),
            ),
            AppChip(
              label: 'AI Recommendation',
              variant: AppChipVariant.ai,
              icon: Icon(PhosphorIconsRegular.sparkle, size: 14),
            ),
          ],
        ),
      ),
    );
  }
}
