import 'package:flutter/material.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../expenses/domain/entities/expense.dart';
import '../../../expenses/domain/entities/trip_budget.dart';
import '../../../expenses/presentation/widgets/budget_summary_card.dart';
import '../../../expenses/presentation/widgets/expense_card.dart';

class FinanceComponentsSection extends StatelessWidget {
  const FinanceComponentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TRIP EXPENSES & FINANCE COMPONENTS',
          style: AppTypography.labelSmall.copyWith(color: Colors.grey[600], letterSpacing: 1.2),
        ),
        const SizedBox(height: AppDimensions.space12),

        BudgetSummaryCard(
          budget: TripBudget(
            id: 'demo-budget',
            tripId: 'demo-trip',
            totalBudget: 50000.0,
            currency: 'INR',
            spentAmount: 29100.0,
            remainingAmount: 20900.0,
            percentageUsed: 58.2,
            status: BudgetStatus.onTrack,
            dailyAllowance: 5225.0,
            categoryBudgets: const [],
            createdAt: DateTime.now().toIso8601String(),
            updatedAt: DateTime.now().toIso8601String(),
          ),
        ),
        const SizedBox(height: AppDimensions.space12),

        ExpenseCard(
          expense: Expense(
            id: 'demo-exp-1',
            tripId: 'demo-trip',
            userId: 'user-1',
            category: ExpenseCategory.food,
            categoryName: 'Food & Dining',
            title: 'Seafood Dinner at Thalassa',
            amount: 6400.0,
            currency: 'INR',
            baseAmount: 6400.0,
            baseCurrency: 'INR',
            exchangeRate: 1.0,
            expenseDate: DateTime.now().toIso8601String(),
            payerId: 'user-1',
            payerName: 'Rameshwar',
            paymentMethod: 'card',
            createdAt: DateTime.now().toIso8601String(),
          ),
        ),
      ],
    );
  }
}
