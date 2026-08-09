import 'package:flutter/material.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/section_layout.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../../../shared/widgets/cards/glass_card.dart';

class CardSection extends StatelessWidget {
  const CardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionLayout(
      title: 'Cards',
      subtitle: 'Standard, Interactive, Selected, Disabled, and Glass cards',
      child: Column(
        children: [
          const AppCard(
            child: Text(
              'Standard Container Card (White surface + subtle border + minimal shadow)',
              style: TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: AppDimensions.space12),
          AppCard(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Interactive Card (Tap target)', style: AppTypography.titleMedium),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.space12),
          const AppCard(
            isSelected: true,
            child: Text(
              'Selected State Card (Teal border & soft background)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: AppDimensions.space12),
          const AppCard(
            isDisabled: true,
            child: Text('Disabled Container State', style: TextStyle(fontSize: 14)),
          ),
          const SizedBox(height: AppDimensions.space12),
          const GlassCard(
            child: Text(
              'Glassmorphic Overlay Card (Subtle Blur)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
