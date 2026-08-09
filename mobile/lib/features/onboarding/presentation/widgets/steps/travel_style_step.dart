import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../app/app_colors.dart';
import '../../../../../app/app_dimensions.dart';
import '../../../../../app/app_typography.dart';
import '../../../../../shared/widgets/chips/app_chip.dart';
import '../../providers/onboarding_provider.dart';

class TravelStyleStep extends ConsumerWidget {
  const TravelStyleStep({super.key});

  static const Map<String, IconData> styleIcons = {
    'Adventure': PhosphorIconsRegular.mountains,
    'Relaxation': PhosphorIconsRegular.sun,
    'Luxury': PhosphorIconsRegular.crown,
    'Budget': PhosphorIconsRegular.wallet,
    'Culture': PhosphorIconsRegular.buildings,
    'Nature': PhosphorIconsRegular.tree,
    'Road Trips': PhosphorIconsRegular.car,
    'Backpacking': PhosphorIconsRegular.backpack,
    'City Exploration': PhosphorIconsRegular.city,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('How do you like to travel?', style: AppTypography.displaySmall),
        const SizedBox(height: AppDimensions.space6),
        Text(
          'Choose the experiences you naturally gravitate toward.',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppDimensions.space24),
        Wrap(
          spacing: AppDimensions.space10,
          runSpacing: AppDimensions.space12,
          children: styleIcons.entries.map((entry) {
            final style = entry.key;
            final icon = entry.value;
            final isSelected = state.travelStyles.contains(style);
            return AppChip(
              label: style,
              isSelected: isSelected,
              icon: Icon(icon),
              onTap: () => notifier.toggleTravelStyle(style),
            );
          }).toList(),
        ),
      ],
    );
  }
}
