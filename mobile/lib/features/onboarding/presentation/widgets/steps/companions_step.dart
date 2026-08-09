import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../app/app_dimensions.dart';
import '../../../../../app/app_typography.dart';
import '../../../../../shared/widgets/chips/app_chip.dart';
import '../../providers/onboarding_provider.dart';

class CompanionsStep extends ConsumerWidget {
  const CompanionsStep({super.key});

  static const companions = [
    'Solo',
    'Partner',
    'Friends',
    'Family',
    'Groups',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Who do you usually travel with?', style: AppTypography.headlineMedium),
        const SizedBox(height: AppDimensions.space8),
        Text(
          'Select your typical travel companions.',
          style: AppTypography.bodyMedium,
        ),
        const SizedBox(height: AppDimensions.space24),
        Wrap(
          spacing: AppDimensions.space12,
          runSpacing: AppDimensions.space12,
          children: companions.map((companion) {
            final isSelected = state.companionTypes.contains(companion);
            return AppChip(
              label: companion,
              isSelected: isSelected,
              onTap: () => notifier.toggleCompanion(companion),
              icon: isSelected ? const Icon(PhosphorIconsRegular.check, size: 16) : null,
            );
          }).toList(),
        ),
      ],
    );
  }
}
