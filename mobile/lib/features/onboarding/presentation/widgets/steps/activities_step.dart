import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../app/app_dimensions.dart';
import '../../../../../app/app_typography.dart';
import '../../../../../shared/widgets/chips/app_chip.dart';
import '../../providers/onboarding_provider.dart';

class ActivitiesStep extends ConsumerWidget {
  const ActivitiesStep({super.key});

  static const activities = [
    'Outdoor',
    'Adventure',
    'Food & Dining',
    'Culture',
    'Entertainment',
    'Shopping',
    'Relaxation',
    'Photography',
    'Local Experiences',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What do you enjoy doing?', style: AppTypography.headlineMedium),
        const SizedBox(height: AppDimensions.space8),
        Text(
          'Select activities you want included in itineraries.',
          style: AppTypography.bodyMedium,
        ),
        const SizedBox(height: AppDimensions.space24),
        Wrap(
          spacing: AppDimensions.space12,
          runSpacing: AppDimensions.space12,
          children: activities.map((activity) {
            final isSelected = state.activityPreferences.contains(activity);
            return AppChip(
              label: activity,
              isSelected: isSelected,
              onTap: () => notifier.toggleActivity(activity),
              icon: isSelected ? const Icon(PhosphorIconsRegular.check, size: 16) : null,
            );
          }).toList(),
        ),
      ],
    );
  }
}
