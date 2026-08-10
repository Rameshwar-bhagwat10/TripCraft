import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/feedback/app_snackbar.dart';
import '../../domain/entities/expense.dart';
import '../providers/trip_finance_provider.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  final String tripId;

  const AddExpenseScreen({
    super.key,
    required this.tripId,
  });

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _amountController = TextEditingController(text: '1250');
  final _titleController = TextEditingController(text: 'Dinner at Baga Beach Club');
  final _payerController = TextEditingController(text: 'Rameshwar');
  ExpenseCategory _selectedCategory = ExpenseCategory.food;
  String _selectedCurrency = 'INR';
  String _selectedPaymentMethod = 'card';

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _payerController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    final body = {
      'title': _titleController.text,
      'amount': double.tryParse(_amountController.text) ?? 0.0,
      'currency': _selectedCurrency,
      'categoryId': _selectedCategory.name,
      'categoryName': ExpenseCategoryConfig.getConfig(_selectedCategory).label,
      'payerName': _payerController.text,
      'paymentMethod': _selectedPaymentMethod,
      'expenseDate': DateTime.now().toIso8601String(),
    };

    await ref.read(tripFinanceProvider(widget.tripId).notifier).createExpense(body);
    if (mounted) {
      AppSnackBar.show(context, message: 'Expense record created');
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Add Full Expense', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.pageMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('EXPENSE TITLE', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
              const SizedBox(height: 6),
              _buildInput(_titleController),
              const SizedBox(height: AppDimensions.space16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('AMOUNT', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
                        const SizedBox(height: 6),
                        _buildInput(_amountController, keyboardType: TextInputType.number),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CURRENCY', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedCurrency,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.surface,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                          items: ['INR', 'USD', 'EUR', 'GBP', 'AED'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                          onChanged: (v) => setState(() => _selectedCurrency = v!),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.space16),

              Text('PAYMENT METHOD', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['card', 'cash', 'upi', 'bank_transfer'].map((method) {
                  final isSelected = _selectedPaymentMethod == method;
                  return ChoiceChip(
                    label: Text(method.toUpperCase()),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedPaymentMethod = method),
                    selectedColor: AppColors.primarySurface,
                    labelStyle: AppTypography.bodySmall.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    ),
                  );
                }).toList(),
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
              const SizedBox(height: AppDimensions.space20),

              Text('PAID BY', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
              const SizedBox(height: 6),
              _buildInput(_payerController),
              const SizedBox(height: AppDimensions.space24),

              PrimaryButton(
                label: 'Save Expense Record',
                icon: const Icon(PhosphorIconsBold.check, size: 18),
                onPressed: _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTypography.bodyMedium,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }
}