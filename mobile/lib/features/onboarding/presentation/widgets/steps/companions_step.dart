import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../app/app_colors.dart';
import '../../../../../app/app_dimensions.dart';
import '../../../../../app/app_typography.dart';
import '../../../../../shared/widgets/chips/app_chip.dart';
import '../../providers/onboarding_provider.dart';

class CompanionsStep extends ConsumerWidget {
  const CompanionsStep({super.key});

  static const Map<String, IconData> companionIcons = {
    'Solo': PhosphorIconsRegular.user,
    'Partner': PhosphorIconsRegular.heart,
    'Friends': PhosphorIconsRegular.usersThree,
    'Family': PhosphorIconsRegular.usersFour,
    'Groups': PhosphorIconsRegular.users,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Who do you usually travel with?', style: AppTypography.displaySmall),
        const SizedBox(height: AppDimensions.space6),
        Text(
          'Select all your typical travel companions.',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppDimensions.space24),
        Wrap(
          spacing: AppDimensions.space10,
          runSpacing: AppDimensions.space12,
          children: companionIcons.entries.map((entry) {
            final companion = entry.key;
            final icon = entry.value;
            final isSelected = state.companionTypes.contains(companion);
            return AppChip(
              label: companion,
              isSelected: isSelected,
              icon: Icon(icon),
              onTap: () => notifier.toggleCompanion(companion),
            );
          }).toList(),
        ),
      ],
    );
  }
}
