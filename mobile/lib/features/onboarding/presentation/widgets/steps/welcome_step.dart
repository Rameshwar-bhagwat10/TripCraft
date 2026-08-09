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
        const SizedBox(height: AppDimensions.space24),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(15, 118, 110, 0.14),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
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
          style: AppTypography.displaySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.space8),
        Text(
          "Let's personalize your travel experience.",
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.space24),
        AppCard(
          padding: const EdgeInsets.all(AppDimensions.space20),
          child: Text(
            "We'll ask a few quick choices to tailor destinations, activities, and AI trip recommendations around your unique travel style.",
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AppDimensions.space24),
      ],
    );
  }
}
