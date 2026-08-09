import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_dimensions.dart';
import '../../../app/app_typography.dart';

enum AppAvatarSize {
  small,
  medium,
  large,
  extraLarge,
}

/// Reusable User Avatar Component for TripCraft.
class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final AppAvatarSize size;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = AppAvatarSize.medium,
  });

  double get _dimension {
    switch (size) {
      case AppAvatarSize.small:
        return AppDimensions.avatarSM; // 32
      case AppAvatarSize.medium:
        return AppDimensions.avatarMD; // 40
      case AppAvatarSize.large:
        return AppDimensions.avatarLG; // 56
      case AppAvatarSize.extraLarge:
        return AppDimensions.avatarXL; // 72
    }
  }

  String? get _initials {
    if (name == null || name!.trim().isEmpty) return null;
    final parts = name!.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final double dimension = _dimension;
    final String? initials = _initials;

    return Container(
      width: dimension,
      height: dimension,
      decoration: const BoxDecoration(
        color: AppColors.primaryLight,
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? Image.network(
              imageUrl!,
              width: dimension,
              height: dimension,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildFallback(initials, dimension),
            )
          : _buildFallback(initials, dimension),
    );
  }

  Widget _buildFallback(String? initials, double dimension) {
    if (initials != null) {
      return Center(
        child: Text(
          initials,
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.primaryDark,
            fontSize: dimension * 0.4,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
    return Center(
      child: Icon(
        PhosphorIconsRegular.user,
        size: dimension * 0.5,
        color: AppColors.primaryDark,
      ),
    );
  }
}
