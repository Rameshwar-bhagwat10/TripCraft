import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tripcraft/features/expenses/data/repositories/expenses_repository_impl.dart';
import 'package:tripcraft/features/expenses/domain/entities/expense.dart';
import 'package:tripcraft/features/expenses/domain/entities/settlement.dart';
import 'package:tripcraft/features/expenses/domain/entities/trip_budget.dart';
import 'package:tripcraft/features/expenses/presentation/providers/trip_finance_provider.dart';
import 'package:tripcraft/features/expenses/presentation/screens/finance_dashboard_screen.dart';

class FakeExpensesRepository implements ExpensesRepositoryImpl {
  @override
  Future<TripBudget> getBudget(String tripId) async {
    return TripBudget(
      id: 'budget-1',
      tripId: tripId,
      totalBudget: 50000.0,
      currency: 'INR',
      spentAmount: 20000.0,
      remainingAmount: 30000.0,
      percentageUsed: 40.0,
      status: BudgetStatus.onTrack,
      dailyAllowance: 6000.0,
      categoryBudgets: const [],
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<List<Expense>> getExpenses(String tripId) async {
    return [
      Expense(
        id: 'exp-1',
        tripId: tripId,
        userId: 'user-1',
        category: ExpenseCategory.food,
        categoryName: 'Food & Dining',
        title: 'Dinner at Beach Shack',
        amount: 1500.0,
        currency: 'INR',
        baseAmount: 1500.0,
        baseCurrency: 'INR',
        exchangeRate: 1.0,
        expenseDate: DateTime.now().toIso8601String(),
        payerId: 'user-1',
        payerName: 'Rameshwar',
        paymentMethod: 'card',
        createdAt: DateTime.now().toIso8601String(),
      ),
    ];
  }

  @override
  Future<List<TravelerBalance>> getTravelerBalances(String tripId) async => const [];

  @override
  Future<List<SettlementSuggestion>> getSettlements(String tripId) async => const [];

  @override
  Future<FinanceAnalytics> getFinanceAnalytics(String tripId) async {
    return const FinanceAnalytics(
      tripId: 'test-trip-1',
      totalSpent: 20000.0,
      totalBudget: 50000.0,
      projectedTotalSpend: 25000.0,
      dailyAverageSpend: 5000.0,
      topSpendingCategory: 'Food & Dining',
      categoryBreakdown: [],
      spendingInsights: ['On track.'],
    );
  }

  @override
  Future<TripBudget> createOrUpdateBudget(String tripId, Map<String, dynamic> body) async {
    return getBudget(tripId);
  }

  @override
  Future<Expense> createExpense(String tripId, Map<String, dynamic> body) async {
    return (await getExpenses(tripId))[0];
  }

  @override
  Future<void> deleteExpense(String expenseId) async {}

  @override
  Future<SettlementSuggestion> markSettlementComplete(String settlementId) async {
    return const SettlementSuggestion(id: 's-1', payerId: 'p', payerName: 'P', receiverId: 'r', receiverName: 'R', amount: 100, currency: 'INR', status: 'settled');
  }
}

void main() {
  testWidgets('FinanceDashboardScreen renders budget summary card and quick buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          expensesRepositoryProvider.overrideWithValue(FakeExpensesRepository()),
        ],
        child: const MaterialApp(
          home: FinanceDashboardScreen(tripId: 'test-trip-1'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Expenses & Budget'), findsOneWidget);
    expect(find.text('TRIP FINANCIAL BUDGET'), findsOneWidget);
    expect(find.text('Add Expense'), findsOneWidget);
    expect(find.text('Set Budget'), findsOneWidget);
  });
}
