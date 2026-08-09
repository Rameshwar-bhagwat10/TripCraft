import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';

/// Reusable Profile Avatar Component with edit badge and loading state.
class ProfileAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String fullName;
  final double size;
  final bool isUploading;
  final VoidCallback? onTap;

  const ProfileAvatar({
    super.key,
    this.avatarUrl,
    required this.fullName,
    this.size = 88.0,
    this.isUploading = false,
    this.onTap,
  });

  String get _initials {
    if (fullName.trim().isEmpty) return 'T';
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final Widget avatarImage = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: isUploading
            ? const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.primary,
                  ),
                ),
              )
            : avatarUrl != null && avatarUrl!.trim().isNotEmpty
                ? Image.network(
                    avatarUrl!,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildInitials(),
                  )
                : _buildInitials(),
      ),
    );

    return GestureDetector(
      onTap: isUploading ? null : onTap,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          avatarImage,
          if (onTap != null && !isUploading)
            Container(
              padding: const EdgeInsets.all(AppDimensions.space6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.0),
              ),
              child: const Icon(
                PhosphorIconsBold.camera,
                size: 14,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInitials() {
    return Center(
      child: Text(
        _initials,
        style: AppTypography.titleLarge.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.35,
        ),
      ),
    );
  }
}
