import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../app/app_colors.dart';
import '../../../../../app/app_dimensions.dart';
import '../../../../../app/app_typography.dart';
import '../../../../../shared/widgets/chips/app_chip.dart';
import '../../providers/onboarding_provider.dart';

class ActivitiesStep extends ConsumerWidget {
  const ActivitiesStep({super.key});

  static const Map<String, IconData> activityIcons = {
    'Outdoor': PhosphorIconsRegular.compass,
    'Adventure': PhosphorIconsRegular.personSimpleRun,
    'Food & Dining': PhosphorIconsRegular.cookingPot,
    'Culture': PhosphorIconsRegular.ticket,
    'Entertainment': PhosphorIconsRegular.musicNotes,
    'Shopping': PhosphorIconsRegular.tShirt,
    'Relaxation': PhosphorIconsRegular.flower,
    'Photography': PhosphorIconsRegular.aperture,
    'Local Experiences': PhosphorIconsRegular.mapPin,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What do you enjoy doing?', style: AppTypography.displaySmall),
        const SizedBox(height: AppDimensions.space6),
        Text(
          'Select activities you want prioritized in your trip itineraries.',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppDimensions.space24),
        Wrap(
          spacing: AppDimensions.space10,
          runSpacing: AppDimensions.space12,
          children: activityIcons.entries.map((entry) {
            final activity = entry.key;
            final icon = entry.value;
            final isSelected = state.activityPreferences.contains(activity);
            return AppChip(
              label: activity,
              isSelected: isSelected,
              icon: Icon(icon),
              onTap: () => notifier.toggleActivity(activity),
            );
          }).toList(),
        ),
      ],
    );
  }
}
