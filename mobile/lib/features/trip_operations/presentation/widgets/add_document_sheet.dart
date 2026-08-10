import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../domain/entities/travel_document.dart';

class AddDocumentSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onUpload;

  const AddDocumentSheet({
    super.key,
    required this.onUpload,
  });

  @override
  State<AddDocumentSheet> createState() => _AddDocumentSheetState();
}

class _AddDocumentSheetState extends State<AddDocumentSheet> {
  final _titleController = TextEditingController(text: 'IndiGo Flight Ticket.pdf');
  DocumentCategory _selectedCategory = DocumentCategory.transport;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: AppDimensions.space16,
        left: AppDimensions.pageMargin,
        right: AppDimensions.pageMargin,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppDimensions.space24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: AppDimensions.space16),

          Text('Upload Travel Document', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('Upload e-tickets, hotel vouchers, or passport copies to your private vault.', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppDimensions.space16),

          Text('DOCUMENT TITLE', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
          const SizedBox(height: 6),
          TextField(
            controller: _titleController,
            style: AppTypography.bodyMedium,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceSecondary,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          const SizedBox(height: AppDimensions.space16),

          Text('CATEGORY', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: DocumentCategory.values.map((cat) {
              final config = DocumentCategoryConfig.getConfig(cat);
              final isSelected = _selectedCategory == cat;
              return ChoiceChip(
                label: Text(config.label),
                selected: isSelected,
                onSelected: (_) => setState(() => _selectedCategory = cat),
                selectedColor: AppColors.primarySurface,
                labelStyle: AppTypography.bodySmall.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppDimensions.space24),

          PrimaryButton(
            label: 'Confirm Upload & Encrypt',
            icon: const Icon(PhosphorIconsBold.uploadSimple, size: 18),
            onPressed: () {
              Navigator.pop(context);
              widget.onUpload({
                'title': _titleController.text,
                'category': _selectedCategory.name,
                'fileType': 'pdf',
                'fileSizeBytes': 450000,
              });
            },
          ),
        ],
      ),
    );
  }
}
