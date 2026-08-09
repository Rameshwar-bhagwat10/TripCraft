import 'package:flutter/material.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/section_layout.dart';
import '../../../../shared/widgets/cards/app_card.dart';

class TypographySection extends StatelessWidget {
  const TypographySection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionLayout(
      title: 'Typography',
      subtitle: 'Official font: Plus Jakarta Sans typography scale',
      child: AppCard(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSample('Display Large (48/56 Bold)', AppTypography.displayLarge),
            _buildSample('Display Medium (40/48 Bold)', AppTypography.displayMedium),
            _buildSample('Headline Large (32/40 Bold)', AppTypography.headlineLarge),
            _buildSample('Headline Medium (28/36 Bold)', AppTypography.headlineMedium),
            _buildSample('Headline Small (24/32 Bold)', AppTypography.headlineSmall),
            _buildSample('Title Large (20/28 SemiBold)', AppTypography.titleLarge),
            _buildSample('Title Medium (18/24 SemiBold)', AppTypography.titleMedium),
            _buildSample('Title Small (16/22 SemiBold)', AppTypography.titleSmall),
            _buildSample('Body Large (16/24 Regular)', AppTypography.bodyLarge),
            _buildSample('Body Medium (14/20 Regular)', AppTypography.bodyMedium),
            _buildSample('Body Small (13/18 Regular)', AppTypography.bodySmall),
            _buildSample('Label Large (14/20 Medium)', AppTypography.labelLarge),
            _buildSample('Label Medium (12/16 Medium)', AppTypography.labelMedium),
            _buildSample('Label Small (11/14 Medium)', AppTypography.labelSmall),
          ],
        ),
      ),
    );
  }

  Widget _buildSample(String label, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.space12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: style),
          const SizedBox(height: 2),
        ],
      ),
    );
  }
}
