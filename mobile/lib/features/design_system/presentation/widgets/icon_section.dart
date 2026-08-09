import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/section_layout.dart';
import '../../../../shared/widgets/cards/app_card.dart';

class IconSection extends StatelessWidget {
  const IconSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionLayout(
      title: 'Icon System',
      subtitle: 'Phosphor Icons across core app categories',
      child: AppCard(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Wrap(
          spacing: AppDimensions.space16,
          runSpacing: AppDimensions.space16,
          children: const [
            _IconBox('Home', PhosphorIconsRegular.house),
            _IconBox('Explore', PhosphorIconsRegular.compass),
            _IconBox('Trips', PhosphorIconsRegular.airplaneTilt),
            _IconBox('AI Copilot', PhosphorIconsRegular.sparkle, color: AppColors.aiAccent),
            _IconBox('Weather', PhosphorIconsRegular.sun),
            _IconBox('Map Pin', PhosphorIconsRegular.mapPin),
            _IconBox('Expenses', PhosphorIconsRegular.wallet),
            _IconBox('User', PhosphorIconsRegular.user),
            _IconBox('Chat', PhosphorIconsRegular.chatCircleText),
            _IconBox('Calendar', PhosphorIconsRegular.calendar),
            _IconBox('Bookmark', PhosphorIconsRegular.bookmarkSimple),
            _IconBox('Search', PhosphorIconsRegular.magnifyingGlass),
          ],
        ),
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? color;

  const _IconBox(this.label, this.icon, {this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Column(
        children: [
          Icon(icon, size: AppDimensions.iconXL, color: color ?? AppColors.textPrimary),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
