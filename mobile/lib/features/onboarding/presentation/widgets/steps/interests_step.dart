import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../app/app_dimensions.dart';
import '../../../../../app/app_typography.dart';
import '../../../../../shared/widgets/chips/app_chip.dart';
import '../../providers/onboarding_provider.dart';

class InterestsStep extends ConsumerWidget {
  const InterestsStep({super.key});

  static const interests = [
    'Beaches',
    'Mountains',
    'History',
    'Museums',
    'Food',
    'Shopping',
    'Nightlife',
    'Photography',
    'Wildlife',
    'Architecture',
    'Sports',
    'Wellness',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What are you interested in?', style: AppTypography.headlineMedium),
        const SizedBox(height: AppDimensions.space8),
        Text(
          'Choose the themes you love exploring.',
          style: AppTypography.bodyMedium,
        ),
        const SizedBox(height: AppDimensions.space24),
        Wrap(
          spacing: AppDimensions.space12,
          runSpacing: AppDimensions.space12,
          children: interests.map((interest) {
            final isSelected = state.interests.contains(interest);
            return AppChip(
              label: interest,
              isSelected: isSelected,
              onTap: () => notifier.toggleInterest(interest),
              icon: isSelected ? const Icon(PhosphorIconsRegular.check, size: 16) : null,
            );
          }).toList(),
        ),
      ],
    );
  }
}
