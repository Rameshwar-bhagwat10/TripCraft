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
import '../widgets/add_budget_sheet.dart';
import '../widgets/add_expense_sheet.dart';
import '../widgets/budget_summary_card.dart';
import '../widgets/category_spending_tile.dart';
import '../widgets/expense_card.dart';

class FinanceDashboardScreen extends ConsumerWidget {
  final String tripId;

  const FinanceDashboardScreen({
    super.key,
    required this.tripId,
  });

  void _showAddExpenseSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddExpenseSheet(
          onSave: (data) async {
            await ref.read(tripFinanceProvider(tripId).notifier).createExpense(data);
            if (context.mounted) {
              AppSnackBar.show(context, message: 'Expense recorded successfully');
            }
          },
        );
      },
    );
  }

  void _showAddBudgetSheet(BuildContext context, WidgetRef ref, double currentBudget, String currentCurrency) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddBudgetSheet(
          currentBudget: currentBudget,
          currentCurrency: currentCurrency,
          onSave: (total, currency) async {
            await ref.read(tripFinanceProvider(tripId).notifier).updateBudget({
              'totalBudget': total,
              'currency': currency,
            });
            if (context.mounted) {
              AppSnackBar.show(context, message: 'Trip budget updated');
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tripFinanceProvider(tripId));

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Expenses & Budget', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsBold.chartPieSlice, color: AppColors.primary),
            onPressed: () => context.push('/trips/$tripId/finance/analytics'),
          ),
        ],
      ),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.pageMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Budget Summary Card
                    if (state.budget != null) BudgetSummaryCard(budget: state.budget!),
                    const SizedBox(height: AppDimensions.space20),

                    // Quick Financial Actions
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _showAddExpenseSheet(context, ref),
                            icon: const Icon(PhosphorIconsBold.plus, size: 16),
                            label: const Text('Add Expense', style: TextStyle(fontWeight: FontWeight.w700)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _showAddBudgetSheet(context, ref, state.budget?.totalBudget ?? 50000, state.budget?.currency ?? 'INR'),
                            icon: const Icon(PhosphorIconsBold.pencilSimple, size: 16),
                            label: const Text('Set Budget', style: TextStyle(fontWeight: FontWeight.w700)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textPrimary,
                              side: const BorderSide(color: AppColors.border),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.space24),

                    // Shared Expenses & Balances Banner
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.space16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSecondary,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('SHARED TRAVEL EXPENSES', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
                              const SizedBox(height: 4),
                              Text('You are owed ₹19,400 by party', style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w800, color: const Color(0xFF10B981))),
                            ],
                          ),
                          OutlinedButton(
                            onPressed: () => context.push('/trips/$tripId/finance/shared'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            child: const Text('Balances', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space24),

                    // Category Budgets Breakdown
                    Text('CATEGORY BUDGETS', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
                    const SizedBox(height: AppDimensions.space10),

                    if (state.budget != null)
                      ...state.budget!.categoryBudgets.take(3).map((cat) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppDimensions.space8),
                          child: CategorySpendingTile(categoryBudget: cat),
                        );
                      }),

                    const SizedBox(height: AppDimensions.space24),

                    // Recent Expenses List
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('RECENT EXPENSES (${state.expenses.length})', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
                        TextButton(
                          onPressed: () => context.push('/trips/$tripId/expenses'),
                          child: Text('View All', style: AppTypography.labelMedium.copyWith(color: AppColors.primary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.space8),

                    if (state.expenses.isEmpty)
                      Text('No expenses recorded yet.', style: AppTypography.bodyMedium)
                    else
                      ...state.expenses.take(3).map((exp) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppDimensions.space10),
                          child: ExpenseCard(
                            expense: exp,
                            onTap: () => context.push('/trips/$tripId/expenses/${exp.id}'),
                          ),
                        );
                      }),
                  ],
                ),
              ),
      ),
    );
  }
}
