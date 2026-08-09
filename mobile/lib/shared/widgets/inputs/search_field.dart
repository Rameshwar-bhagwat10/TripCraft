import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_dimensions.dart';
import '../../../app/app_typography.dart';

/// Reusable Search Input Component in TripCraft.
class SearchField extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onFilterTap;
  final VoidCallback? onClear;
  final bool isLoading;
  final TextEditingController? controller;

  const SearchField({
    super.key,
    this.hintText = 'Search destinations, trips, places...',
    this.onChanged,
    this.onSubmitted,
    this.onFilterTap,
    this.onClear,
    this.isLoading = false,
    this.controller,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    setState(() {
      _hasText = _controller.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_handleTextChange);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(
          PhosphorIconsRegular.magnifyingGlass,
          size: AppDimensions.iconMD,
          color: AppColors.textSecondary,
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isLoading)
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              )
            else if (_hasText)
              IconButton(
                icon: const Icon(
                  PhosphorIconsRegular.xCircle,
                  size: AppDimensions.iconMD,
                  color: AppColors.textTertiary,
                ),
                onPressed: () {
                  _controller.clear();
                  widget.onClear?.call();
                  widget.onChanged?.call('');
                },
              ),
            if (widget.onFilterTap != null)
              IconButton(
                icon: const Icon(
                  PhosphorIconsRegular.slidersHorizontal,
                  size: AppDimensions.iconMD,
                  color: AppColors.primary,
                ),
                onPressed: widget.onFilterTap,
              ),
          ],
        ),
      ),
    );
  }
}