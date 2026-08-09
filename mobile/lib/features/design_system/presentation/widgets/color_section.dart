import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/section_layout.dart';
import '../../../../shared/widgets/cards/app_card.dart';

class ColorSection extends StatelessWidget {
  const ColorSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionLayout(
      title: 'Colors',
      subtitle: 'Centralized Slate neutral & Teal brand color palette',
      child: Column(
        children: [
          _buildGroup('Primary Brand', [
            _ColorSwatch('primary', AppColors.primary, '#0F766E'),
            _ColorSwatch('primaryDark', AppColors.primaryDark, '#115E59'),
            _ColorSwatch('primaryLight', AppColors.primaryLight, '#CCFBF1'),
            _ColorSwatch('primarySurface', AppColors.primarySurface, '#F0FDFA'),
          ]),
          const SizedBox(height: AppDimensions.space16),
          _buildGroup('Neutrals (Slate)', [
            _ColorSwatch('background', AppColors.background, '#F8FAFC'),
            _ColorSwatch('surface', AppColors.surface, '#FFFFFF'),
            _ColorSwatch('surfaceSecondary', AppColors.surfaceSecondary, '#F1F5F9'),
            _ColorSwatch('surfaceTertiary', AppColors.surfaceTertiary, '#E2E8F0'),
            _ColorSwatch('border', AppColors.border, '#E2E8F0'),
            _ColorSwatch('borderStrong', AppColors.borderStrong, '#CBD5E1'),
          ]),
          const SizedBox(height: AppDimensions.space16),
          _buildGroup('Typography Neutrals', [
            _ColorSwatch('textPrimary', AppColors.textPrimary, '#0F172A'),
            _ColorSwatch('textSecondary', AppColors.textSecondary, '#475569'),
            _ColorSwatch('textTertiary', AppColors.textTertiary, '#64748B'),
            _ColorSwatch('textDisabled', AppColors.textDisabled, '#94A3B8'),
          ]),
          const SizedBox(height: AppDimensions.space16),
          _buildGroup('Semantic Feedback & Accents', [
            _ColorSwatch('success', AppColors.success, '#16A34A'),
            _ColorSwatch('warning', AppColors.warning, '#D97706'),
            _ColorSwatch('error', AppColors.error, '#DC2626'),
            _ColorSwatch('info', AppColors.info, '#2563EB'),
            _ColorSwatch('accent (Travel)', AppColors.accent, '#F59E0B'),
            _ColorSwatch('aiAccent (AI)', AppColors.aiAccent, '#7C3AED'),
          ]),
        ],
      ),
    );
  }

  Widget _buildGroup(String groupTitle, List<_ColorSwatch> swatches) {
    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(groupTitle, style: AppTypography.titleMedium),
          const SizedBox(height: AppDimensions.space12),
          Wrap(
            spacing: AppDimensions.space12,
            runSpacing: AppDimensions.space12,
            children: swatches,
          ),
        ],
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final String name;
  final Color color;
  final String hex;

  const _ColorSwatch(this.name, this.color, this.hex);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 44,
            width: double.infinity,
            decoration: BoxDecoration(
              color: color,
              borderRadius: AppDimensions.borderSM,
              border: Border.all(color: AppColors.border, width: 1),
            ),
          ),
          const SizedBox(height: 6),
          Text(name, style: AppTypography.labelMedium),
          Text(
            hex,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}
