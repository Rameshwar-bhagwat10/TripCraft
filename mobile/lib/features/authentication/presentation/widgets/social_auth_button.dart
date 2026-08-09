import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';

enum SocialProvider {
  google,
  apple,
}

class SocialAuthButton extends StatelessWidget {
  final SocialProvider provider;
  final VoidCallback onPressed;
  final bool isLoading;

  const SocialAuthButton({
    super.key,
    required this.provider,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final String label = provider == SocialProvider.google
        ? 'Continue with Google'
        : 'Continue with Apple';

    final IconData icon = provider == SocialProvider.google
        ? PhosphorIconsRegular.googleLogo
        : PhosphorIconsRegular.appleLogo;

    return SizedBox(
      height: AppDimensions.buttonHeight,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border, width: 1),
          shape: const RoundedRectangleBorder(
            borderRadius: AppDimensions.buttonRadius,
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.textPrimary,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: AppDimensions.iconMD, color: AppColors.textPrimary),
                  const SizedBox(width: AppDimensions.space12),
                  Text(
                    label,
                    style: AppTypography.labelLarge.copyWith(color: AppColors.textPrimary),
                  ),
                ],
              ),
      ),
    );
  }
}
