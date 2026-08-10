import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/feedback/app_snackbar.dart';
import '../providers/trip_finance_provider.dart';
import '../widgets/add_expense_sheet.dart';
import '../widgets/expense_card.dart';

class ExpenseListScreen extends ConsumerStatefulWidget {
  final String tripId;

  const ExpenseListScreen({
    super.key,
    required this.tripId,
  });

  @override
  ConsumerState<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends ConsumerState<ExpenseListScreen> {
  String _selectedCategoryFilter = 'all';

  void _showAddExpenseSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddExpenseSheet(
          onSave: (data) async {
            await ref.read(tripFinanceProvider(widget.tripId).notifier).createExpense(data);
            if (context.mounted) {
              AppSnackBar.show(context, message: 'Expense recorded');
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tripFinanceProvider(widget.tripId));

    final filtered = state.expenses.where((e) {
      if (_selectedCategoryFilter == 'all') return true;
      return e.category.name.toLowerCase() == _selectedCategoryFilter.toLowerCase();
    }).toList();

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Trip Expenses (${state.expenses.length})', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsBold.plus, color: AppColors.primary),
            onPressed: _showAddExpenseSheet,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageMargin, vertical: 8),
              child: Row(
                children: ['all', 'accommodation', 'transport', 'food', 'activities'].map((filter) {
                  final isSelected = _selectedCategoryFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(filter.toUpperCase()),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedCategoryFilter = filter),
                      selectedColor: AppColors.primarySurface,
                      labelStyle: AppTypography.bodySmall.copyWith(
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppDimensions.space10),

            Expanded(
              child: filtered.isEmpty
                  ? Center(child: Text('No expenses match category.', style: AppTypography.bodyMedium))
                  : ListView.builder(
                      padding: const EdgeInsets.all(AppDimensions.pageMargin),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final exp = filtered[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppDimensions.space12),
                          child: ExpenseCard(
                            expense: exp,
                            onTap: () => context.push('/trips/${widget.tripId}/expenses/${exp.id}'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
