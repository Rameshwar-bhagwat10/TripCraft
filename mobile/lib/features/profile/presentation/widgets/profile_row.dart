import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';

/// Reusable iOS-style List Row Component for Profile and Preference screens.
class ProfileRow extends StatefulWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? value;
  final Widget? trailing;
  final bool showChevron;
  final VoidCallback? onTap;

  const ProfileRow({
    super.key,
    required this.icon,
    this.iconColor,
    required this.title,
    this.value,
    this.trailing,
    this.showChevron = true,
    this.onTap,
  });

  @override
  State<ProfileRow> createState() => _ProfileRowState();
}

class _ProfileRowState extends State<ProfileRow> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isClickable = widget.onTap != null;

    final Widget content = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space14,
      ),
      color: _isPressed && isClickable ? AppColors.surfaceSecondary : AppColors.surface,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: (widget.iconColor ?? AppColors.primary).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              widget.icon,
              size: 18,
              color: widget.iconColor ?? AppColors.primary,
            ),
          ),
          const SizedBox(width: AppDimensions.space12),
          Expanded(
            child: Text(
              widget.title,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (widget.value != null && widget.value!.isNotEmpty) ...[
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 140),
              child: Text(
                widget.value!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              ),
            ),
            const SizedBox(width: AppDimensions.space8),
          ],
          if (widget.trailing != null) ...[
            widget.trailing!,
            if (widget.showChevron) const SizedBox(width: AppDimensions.space6),
          ],
          if (widget.showChevron && isClickable) ...[
            const Icon(
              PhosphorIconsRegular.caretRight,
              size: 18,
              color: AppColors.textTertiary,
            ),
          ],
        ],
      ),
    );

    if (isClickable) {
      return GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap?.call();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: content,
      );
    }

    return content;
  }
}
