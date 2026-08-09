import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../app/app_dimensions.dart';
import '../../../../../app/app_typography.dart';
import '../../../../../shared/widgets/chips/app_chip.dart';
import '../../providers/onboarding_provider.dart';

class TravelStyleStep extends ConsumerWidget {
  const TravelStyleStep({super.key});

  static const styles = [
    'Adventure',
    'Relaxation',
    'Luxury',
    'Budget',
    'Culture',
    'Nature',
    'Road Trips',
    'Backpacking',
    'City Exploration',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('How do you like to travel?', style: AppTypography.headlineMedium),
        const SizedBox(height: AppDimensions.space8),
        Text(
          'Select all that match your travel vibe.',
          style: AppTypography.bodyMedium,
        ),
        const SizedBox(height: AppDimensions.space24),
        Wrap(
          spacing: AppDimensions.space12,
          runSpacing: AppDimensions.space12,
          children: styles.map((style) {
            final isSelected = state.travelStyles.contains(style);
            return AppChip(
              label: style,
              isSelected: isSelected,
              onTap: () => notifier.toggleTravelStyle(style),
              icon: isSelected ? const Icon(PhosphorIconsRegular.check, size: 16) : null,
            );
          }).toList(),
        ),
      ],
    );
  }
}
