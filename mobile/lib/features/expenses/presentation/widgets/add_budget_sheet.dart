import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';

class AddBudgetSheet extends StatefulWidget {
  final double currentBudget;
  final String currentCurrency;
  final Function(double, String) onSave;

  const AddBudgetSheet({
    super.key,
    required this.currentBudget,
    required this.currentCurrency,
    required this.onSave,
  });

  @override
  State<AddBudgetSheet> createState() => _AddBudgetSheetState();
}

class _AddBudgetSheetState extends State<AddBudgetSheet> {
  late TextEditingController _budgetController;
  late String _selectedCurrency;

  @override
  void initState() {
    super.initState();
    _budgetController = TextEditingController(text: widget.currentBudget.toStringAsFixed(0));
    _selectedCurrency = widget.currentCurrency;
  }

  @override
  void dispose() {
    _budgetController.dispose();
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

          Text('Set Trip Financial Budget', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('Define your total spending limit and primary base currency.', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppDimensions.space16),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _budgetController,
                  keyboardType: TextInputType.number,
                  style: AppTypography.displayMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800),
                  decoration: const InputDecoration(
                    labelText: 'TOTAL BUDGET',
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
          const SizedBox(height: AppDimensions.space24),

          PrimaryButton(
            label: 'Save Trip Budget',
            icon: const Icon(PhosphorIconsBold.check, size: 18),
            onPressed: () {
              Navigator.pop(context);
              final amt = double.tryParse(_budgetController.text) ?? widget.currentBudget;
              widget.onSave(amt, _selectedCurrency);
            },
          ),
        ],
      ),
    );
  }
}
