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
    int filledSegments;

    switch (strength) {
      case PasswordStrength.weak:
        color = AppColors.error;
        text = 'Weak password';
        filledSegments = 1;
        break;
      case PasswordStrength.medium:
        color = AppColors.warning;
        text = 'Medium strength';
        filledSegments = 3;
        break;
      case PasswordStrength.strong:
        color = AppColors.success;
        text = 'Strong password';
        filledSegments = 4;
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
              child: Row(
                children: List.generate(4, (index) {
                  final isFilled = index < filledSegments;
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 4,
                      margin: EdgeInsets.only(right: index < 3 ? 4.0 : 0.0),
                      decoration: BoxDecoration(
                        color: isFilled ? color : AppColors.surfaceSecondary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(width: AppDimensions.space12),
            Text(
              text,
              style: AppTypography.labelSmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
