import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../app/app_colors.dart';
import '../../../../../app/app_dimensions.dart';
import '../../../../../app/app_typography.dart';
import '../../../../../shared/widgets/chips/app_chip.dart';
import '../../providers/onboarding_provider.dart';

class InterestsStep extends ConsumerWidget {
  const InterestsStep({super.key});

  static const Map<String, IconData> interestIcons = {
    'Beaches': PhosphorIconsRegular.waves,
    'Mountains': PhosphorIconsRegular.mountains,
    'History': PhosphorIconsRegular.hourglass,
    'Museums': PhosphorIconsRegular.columns,
    'Food': PhosphorIconsRegular.forkKnife,
    'Shopping': PhosphorIconsRegular.shoppingBag,
    'Nightlife': PhosphorIconsRegular.moon,
    'Photography': PhosphorIconsRegular.camera,
    'Wildlife': PhosphorIconsRegular.pawPrint,
    'Architecture': PhosphorIconsRegular.sketchLogo,
    'Sports': PhosphorIconsRegular.basketball,
    'Wellness': PhosphorIconsRegular.heartbeat,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What are you interested in?', style: AppTypography.displaySmall),
        const SizedBox(height: AppDimensions.space6),
        Text(
          'Choose the themes and activities you love exploring.',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppDimensions.space24),
        Wrap(
          spacing: AppDimensions.space10,
          runSpacing: AppDimensions.space12,
          children: interestIcons.entries.map((entry) {
            final interest = entry.key;
            final icon = entry.value;
            final isSelected = state.interests.contains(interest);
            return AppChip(
              label: interest,
              isSelected: isSelected,
              icon: Icon(icon),
              onTap: () => notifier.toggleInterest(interest),
            );
          }).toList(),
        ),
      ],
    );
  }
}
