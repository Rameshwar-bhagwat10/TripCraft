import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';

enum PasswordStrength {
  none,
  weak,
  medium,
  strong,
}

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
  });

  PasswordStrength get strength {
    if (password.isEmpty) return PasswordStrength.none;
    if (password.length < 6) return PasswordStrength.weak;

    bool hasLetters = password.contains(RegExp(r'[a-zA-Z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (password.length >= 10 && hasLetters && hasDigits && hasSpecial) {
      return PasswordStrength.strong;
    } else if (password.length >= 8 && hasLetters && hasDigits) {
      return PasswordStrength.medium;
    } else {
      return PasswordStrength.weak;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    Color color;
    String text;
    double progress;

    switch (strength) {
      case PasswordStrength.weak:
        color = AppColors.error;
        text = 'Weak password';
        progress = 0.33;
        break;
      case PasswordStrength.medium:
        color = AppColors.warning;
        text = 'Medium strength';
        progress = 0.66;
        break;
      case PasswordStrength.strong:
        color = AppColors.success;
        text = 'Strong password';
        progress = 1.0;
        break;
      case PasswordStrength.none:
        return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppDimensions.space8),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: AppDimensions.borderXS,
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.surfaceSecondary,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 4,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.space12),
            Text(
              text,
              style: AppTypography.labelSmall.copyWith(color: color),
            ),
          ],
        ),
      ],
    );
  }
}
