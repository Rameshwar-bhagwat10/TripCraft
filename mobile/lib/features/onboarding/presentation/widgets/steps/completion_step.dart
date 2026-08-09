import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../app/app_colors.dart';
import '../../../../../app/app_dimensions.dart';
import '../../../../../app/app_typography.dart';
import '../../../../../shared/widgets/buttons/primary_button.dart';
import '../../providers/onboarding_provider.dart';

class CompletionStep extends ConsumerWidget {
  const CompletionStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: AppColors.successLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            PhosphorIconsBold.checkCircle,
            size: 44,
            color: AppColors.success,
          ),
        ),
        const SizedBox(height: AppDimensions.space24),
        Text(
          'Your Tripcraft is ready',
          style: AppTypography.headlineLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.space12),
        Text(
          "We've personalized your travel experience based on your choices.",
          style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.space32),
        PrimaryButton(
          label: 'Start Exploring',
          isLoading: state.isSubmitting,
          onPressed: () => ref.read(onboardingProvider.notifier).completeOnboarding(),
        ),
      ],
    );
  }
}
