import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/section_layout.dart';
import '../../../../shared/widgets/cards/app_card.dart';

class SpacingSection extends StatelessWidget {
  const SpacingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = [
      _SpacingItem('4 (xs)', AppDimensions.xs),
      _SpacingItem('8 (sm)', AppDimensions.sm),
      _SpacingItem('12 (md)', AppDimensions.md),
      _SpacingItem('16 (lg/pageMargin)', AppDimensions.lg),
      _SpacingItem('20 (xl)', AppDimensions.xl),
      _SpacingItem('24 (xxl)', AppDimensions.xxl),
      _SpacingItem('32 (section)', AppDimensions.section),
      _SpacingItem('40 (space40)', AppDimensions.space40),
      _SpacingItem('48 (buttonHeight)', AppDimensions.space48),
      _SpacingItem('64 (hero/space64)', AppDimensions.space64),
    ];

    return SectionLayout(
      title: 'Spacing System',
      subtitle: '8-point grid spacing system (xs to hero)',
      child: AppCard(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          children: tokens.map((item) => item.buildRow()).toList(),
        ),
      ),
    );
  }
}

class _SpacingItem {
  final String label;
  final double value;

  _SpacingItem(this.label, this.value);

  Widget buildRow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.space8),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: AppTypography.labelMedium),
          ),
          Container(
            height: 16,
            width: value,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: AppDimensions.borderXS,
            ),
          ),
          const SizedBox(width: AppDimensions.space8),
          Text('${value.toInt()}px', style: AppTypography.bodySmall),
        ],
      ),
    );
  }
}
