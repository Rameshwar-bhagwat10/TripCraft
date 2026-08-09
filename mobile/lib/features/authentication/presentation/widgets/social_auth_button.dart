import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';

enum SocialProvider {
  google,
  apple,
}

class SocialAuthButton extends StatefulWidget {
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
  State<SocialAuthButton> createState() => _SocialAuthButtonState();
}

class _SocialAuthButtonState extends State<SocialAuthButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final String label = widget.provider == SocialProvider.google
        ? 'Continue with Google'
        : 'Continue with Apple';

    final IconData icon = widget.provider == SocialProvider.google
        ? PhosphorIconsRegular.googleLogo
        : PhosphorIconsRegular.appleLogo;

    final Widget content = widget.isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
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
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );

    return AnimatedScale(
      scale: _isPressed && !widget.isLoading ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          if (!widget.isLoading) widget.onPressed();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: SizedBox(
          height: AppDimensions.buttonHeight,
          width: double.infinity,
          child: OutlinedButton(
            onPressed: widget.isLoading ? null : widget.onPressed,
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.border, width: 1.0),
              shape: const RoundedRectangleBorder(
                borderRadius: AppDimensions.buttonRadius,
              ),
              elevation: 0,
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}
