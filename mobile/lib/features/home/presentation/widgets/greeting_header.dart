import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_typography.dart';
import '../../../profile/presentation/widgets/profile_avatar.dart';

/// Reusable Greeting Header Component with Time-based greeting and Profile Avatar.
class GreetingHeader extends StatelessWidget {
  final String? fullName;
  final String? avatarUrl;
  final VoidCallback? onAvatarTap;

  const GreetingHeader({
    super.key,
    this.fullName,
    this.avatarUrl,
    this.onAvatarTap,
  });

  static String get greetingText {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good evening';
    } else {
      return 'Good night';
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayName = (fullName != null && fullName!.trim().isNotEmpty)
        ? fullName!.trim().split(' ').first
        : 'Traveler';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greetingText,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                displayName,
                style: AppTypography.displaySmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        ProfileAvatar(
          fullName: fullName ?? 'Traveler',
          avatarUrl: avatarUrl,
          size: 44,
          onTap: onAvatarTap,
        ),
      ],
    );
  }
}
