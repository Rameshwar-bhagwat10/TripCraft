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
        const SizedBox(height: AppDimensions.space32),
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(15, 118, 110, 0.16),
                blurRadius: 24,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            PhosphorIconsBold.checkCircle,
            size: 46,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppDimensions.space24),
        Text(
          "You're all set!",
          style: AppTypography.displaySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.space8),
        Text(
          'Tripcraft is now personalized around the exact way you love to travel.',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.space40),
        PrimaryButton(
          label: 'Start Exploring',
          isLoading: state.isSubmitting,
          onPressed: () => ref.read(onboardingProvider.notifier).completeOnboarding(),
        ),
        const SizedBox(height: AppDimensions.space24),
      ],
    );
  }
}
