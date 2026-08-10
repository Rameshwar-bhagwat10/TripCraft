import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../domain/entities/expense.dart';

class AddExpenseSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const AddExpenseSheet({
    super.key,
    required this.onSave,
  });

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final _amountController = TextEditingController(text: '650');
  final _titleController = TextEditingController(text: 'Seafood Lunch at Brittos');
  ExpenseCategory _selectedCategory = ExpenseCategory.food;
  String _selectedCurrency = 'INR';

  @override
  void dispose() {
    _amountController.dispose();
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
            child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
          ),
          const SizedBox(height: AppDimensions.space16),

          Text('Add Quick Expense', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('Record actual travel spending in seconds.', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppDimensions.space16),

          // Amount & Currency Row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  style: AppTypography.displayMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800),
                  decoration: const InputDecoration(
                    labelText: 'AMOUNT',
                    prefixText: '₹ ',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              DropdownButton<String>(
                value: _selectedCurrency,
                items: ['INR', 'USD', 'EUR', 'GBP', 'AED'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _selectedCurrency = v!),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space16),

          Text('EXPENSE TITLE', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
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
            children: ExpenseCategory.values.map((cat) {
              final config = ExpenseCategoryConfig.getConfig(cat);
              final isSelected = _selectedCategory == cat;
              return ChoiceChip(
                label: Text(config.label),
                selected: isSelected,
                onSelected: (_) => setState(() => _selectedCategory = cat),
                selectedColor: config.color.withValues(alpha: 0.15),
                labelStyle: AppTypography.bodySmall.copyWith(
                  color: isSelected ? config.color : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppDimensions.space24),

          PrimaryButton(
            label: 'Save Expense Record',
            icon: const Icon(PhosphorIconsBold.check, size: 18),
            onPressed: () {
              Navigator.pop(context);
              widget.onSave({
                'title': _titleController.text,
                'amount': double.tryParse(_amountController.text) ?? 0.0,
                'currency': _selectedCurrency,
                'categoryId': _selectedCategory.name,
                'categoryName': ExpenseCategoryConfig.getConfig(_selectedCategory).label,
              });
            },
          ),
        ],
      ),
    );
  }
}
