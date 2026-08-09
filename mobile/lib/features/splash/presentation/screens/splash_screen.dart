import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Container
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(15, 118, 110, 0.2),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                PhosphorIconsBold.compass,
                color: Colors.white,
                size: 44,
              ),
            ),
            const SizedBox(height: AppDimensions.space20),
            // Wordmark
            Text(
              'TripCraft',
              style: AppTypography.headlineLarge.copyWith(
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: AppDimensions.space8),
            Text(
              'AI-Powered Travel Planning',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.space48),
            // Loading Indicator
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}