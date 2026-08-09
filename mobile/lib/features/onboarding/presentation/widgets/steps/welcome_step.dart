import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../app/app_colors.dart';
import '../../../../../app/app_dimensions.dart';
import '../../../../../app/app_typography.dart';
import '../../../../../shared/widgets/cards/app_card.dart';

class WelcomeStep extends StatelessWidget {
  const WelcomeStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: AppColors.primarySurface,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            PhosphorIconsBold.sparkle,
            size: 40,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppDimensions.space24),
        Text(
          'Welcome to Tripcraft',
          style: AppTypography.headlineLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.space12),
        Text(
          "Let's personalize your travel experience.",
          style: AppTypography.titleMedium.copyWith(color: AppColors.primary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.space16),
        AppCard(
          padding: const EdgeInsets.all(AppDimensions.space20),
          child: Text(
            "We'll use a few quick choices to tailor destinations, activities, and future trip plans exclusively for you.",
            style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
