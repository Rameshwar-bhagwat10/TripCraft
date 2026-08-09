import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/widgets/buttons/secondary_button.dart';
import 'profile_avatar.dart';

/// Reusable Profile Header Component for TripCraft.
class ProfileHeader extends StatelessWidget {
  final String? avatarUrl;
  final String fullName;
  final String email;
  final bool isAvatarUploading;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onEditProfileTap;

  const ProfileHeader({
    super.key,
    this.avatarUrl,
    required this.fullName,
    required this.email,
    this.isAvatarUploading = false,
    this.onAvatarTap,
    this.onEditProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileAvatar(
          avatarUrl: avatarUrl,
          fullName: fullName,
          isUploading: isAvatarUploading,
          onTap: onAvatarTap,
        ),
        const SizedBox(height: AppDimensions.space12),
        Text(
          fullName.isNotEmpty ? fullName : 'Traveler',
          style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          email,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        if (onEditProfileTap != null) ...[
          const SizedBox(height: AppDimensions.space16),
          SecondaryButton(
            label: 'Edit Profile',
            height: 38,
            onPressed: onEditProfileTap,
          ),
        ],
      ],
    );
  }
}