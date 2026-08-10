import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';

class AddPhotoSheet extends StatefulWidget {
  final Function(Map<String, dynamic> photoData) onSubmit;

  const AddPhotoSheet({
    super.key,
    required this.onSubmit,
  });

  @override
  State<AddPhotoSheet> createState() => _AddPhotoSheetState();
}

class _AddPhotoSheetState extends State<AddPhotoSheet> {
  final _captionController = TextEditingController(text: 'Sunset view from Baga cliff top');
  final _locationController = TextEditingController(text: 'Baga Beach, North Goa');
  int _selectedDay = 1;

  @override
  void dispose() {
    _captionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _handleSave() {
    widget.onSubmit({
      'caption': _captionController.text,
      'locationName': _locationController.text,
      'tripDay': _selectedDay,
      'thumbnailPath': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400',
      'previewPath': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200',
    });
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppDimensions.pageMargin,
        right: AppDimensions.pageMargin,
        top: AppDimensions.pageMargin,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppDimensions.pageMargin,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),
          Text('Upload Memory Photo', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),

          // Upload Box Simulation
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(PhosphorIconsBold.cloudArrowUp, size: 36, color: AppColors.primary),
                  SizedBox(height: 6),
                  Text('Photo Selected (1 File)', style: TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.space16),

          Text('CAPTION', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
          const SizedBox(height: 6),
          TextField(
            controller: _captionController,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          const SizedBox(height: AppDimensions.space14),

          Text('LOCATION', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
          const SizedBox(height: 6),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          const SizedBox(height: AppDimensions.space14),

          Text('TRIP DAY', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
          const SizedBox(height: 6),
          Row(
            children: [1, 2, 3, 4, 5].map((d) {
              final isSelected = _selectedDay == d;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text('Day $d'),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedDay = d),
                  selectedColor: AppColors.primarySurface,
                  labelStyle: TextStyle(color: isSelected ? AppColors.primary : AppColors.textPrimary, fontWeight: FontWeight.w700),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppDimensions.space20),

          PrimaryButton(
            label: 'Save & Upload Photo',
            icon: const Icon(PhosphorIconsBold.check, size: 18),
            onPressed: _handleSave,
          ),
        ],
      ),
    );
  }
}
