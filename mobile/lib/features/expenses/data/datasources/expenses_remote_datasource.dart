import 'package:dio/dio.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/settlement.dart';
import '../../domain/entities/trip_budget.dart';

abstract class ExpensesRemoteDataSource {
  Future<TripBudget> getBudget(String tripId);
  Future<TripBudget> createOrUpdateBudget(String tripId, Map<String, dynamic> body);
  Future<List<Expense>> getExpenses(String tripId);
  Future<Expense> createExpense(String tripId, Map<String, dynamic> body);
  Future<void> deleteExpense(String expenseId);
  Future<List<TravelerBalance>> getTravelerBalances(String tripId);
  Future<List<SettlementSuggestion>> getSettlements(String tripId);
  Future<SettlementSuggestion> markSettlementComplete(String settlementId);
  Future<FinanceAnalytics> getFinanceAnalytics(String tripId);
}

class ExpensesRemoteDataSourceImpl implements ExpensesRemoteDataSource {
  final Dio _dio;

  ExpensesRemoteDataSourceImpl(this._dio);

  static final TripBudget _mockBudget = TripBudget(
    id: 'budget-goa-1',
    tripId: 'trip-goa-escape',
    totalBudget: 50000.0,
    currency: 'INR',
    spentAmount: 29100.0,
    remainingAmount: 20900.0,
    percentageUsed: 58.2,
    status: BudgetStatus.onTrack,
    dailyAllowance: 5225.0,
    categoryBudgets: const [
      CategoryBudget(categoryId: 'accommodation', categoryName: 'Accommodation', allocatedAmount: 20000, spentAmount: 14500),
      CategoryBudget(categoryId: 'transport', categoryName: 'Transportation', allocatedAmount: 12000, spentAmount: 8200),
      CategoryBudget(categoryId: 'food', categoryName: 'Food & Dining', allocatedAmount: 10000, spentAmount: 6400),
      CategoryBudget(categoryId: 'activities', categoryName: 'Activities', allocatedAmount: 5000, spentAmount: 0),
      CategoryBudget(categoryId: 'shopping', categoryName: 'Shopping', allocatedAmount: 3000, spentAmount: 0),
    ],
    createdAt: DateTime.now().toIso8601String(),
    updatedAt: DateTime.now().toIso8601String(),
  );

  static final List<Expense> _mockExpenses = [
    Expense(
      id: 'exp-hotel-1',
      tripId: 'trip-goa-escape',
      userId: 'user-rameshwar',
      category: ExpenseCategory.accommodation,
      categoryName: 'Accommodation',
      title: 'Taj Fort Aguada Advance Payment',
      amount: 14500.0,
      currency: 'INR',
      baseAmount: 14500.0,
      baseCurrency: 'INR',
      exchangeRate: 1.0,
      expenseDate: '2026-08-02T10:00:00Z',
      payerId: 'user-rameshwar',
      payerName: 'Rameshwar',
      paymentMethod: 'card',
      bookingId: 'book-hotel-1',
      receiptDocumentId: 'doc-hotel-1',
      createdAt: DateTime.now().toIso8601String(),
    ),
    Expense(
      id: 'exp-flight-1',
      tripId: 'trip-goa-escape',
      userId: 'user-rameshwar',
      category: ExpenseCategory.transport,
      categoryName: 'Transportation',
      title: 'IndiGo BOM -> GOI Flight Tickets',
      amount: 8200.0,
      currency: 'INR',
      baseAmount: 8200.0,
      baseCurrency: 'INR',
      exchangeRate: 1.0,
      expenseDate: '2026-08-01T15:30:00Z',
      payerId: 'user-rameshwar',
      payerName: 'Rameshwar',
      paymentMethod: 'upi',
      bookingId: 'book-flight-1',
      receiptDocumentId: 'doc-ticket-1',
      createdAt: DateTime.now().toIso8601String(),
    ),
    Expense(
      id: 'exp-dining-1',
      tripId: 'trip-goa-escape',
      userId: 'user-rameshwar',
      category: ExpenseCategory.food,
      categoryName: 'Food & Dining',
      title: 'Seafood Dinner at Thalassa',
      amount: 6400.0,
      currency: 'INR',
      baseAmount: 6400.0,
      baseCurrency: 'INR',
      exchangeRate: 1.0,
      expenseDate: '2026-08-09T20:45:00Z',
      payerId: 'user-rameshwar',
      payerName: 'Rameshwar',
      paymentMethod: 'card',
      createdAt: DateTime.now().toIso8601String(),
    ),
  ];

  @override
  Future<TripBudget> getBudget(String tripId) async {
    try {
      final res = await _dio.get('/trips/$tripId/budget');
      return TripBudget.fromJson(res.data as Map<String, dynamic>);
    } catch (_) {
      return _mockBudget;
    }
  }

  @override
  Future<TripBudget> createOrUpdateBudget(String tripId, Map<String, dynamic> body) async {
    try {
      final res = await _dio.post('/trips/$tripId/budget', data: body);
      return TripBudget.fromJson(res.data as Map<String, dynamic>);
    } catch (_) {
      return TripBudget.fromJson({...body, 'id': 'budget-$tripId', 'tripId': tripId});
    }
  }

  @override
  Future<List<Expense>> getExpenses(String tripId) async {
    try {
      final res = await _dio.get('/trips/$tripId/expenses');
      return (res.data as List<dynamic>).map((e) => Expense.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return _mockExpenses;
    }
  }

  @override
  Future<Expense> createExpense(String tripId, Map<String, dynamic> body) async {
    try {
      final res = await _dio.post('/trips/$tripId/expenses', data: body);
      return Expense.fromJson(res.data as Map<String, dynamic>);
    } catch (_) {
      return Expense.fromJson({
        ...body,
        'id': 'exp-${DateTime.now().millisecondsSinceEpoch}',
        'tripId': tripId,
        'baseAmount': body['amount'] ?? 1000.0,
        'baseCurrency': body['currency'] ?? 'INR',
        'exchangeRate': 1.0,
      });
    }
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    try {
      await _dio.delete('/expenses/$expenseId');
    } catch (_) {}
  }

  @override
  Future<List<TravelerBalance>> getTravelerBalances(String tripId) async {
    try {
      final res = await _dio.get('/trips/$tripId/balances');
      return (res.data as List<dynamic>).map((e) => TravelerBalance.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return const [
        TravelerBalance(travelerId: 'user-rameshwar', travelerName: 'Rameshwar', totalPaid: 29100.0, totalShare: 9700.0, netBalance: 19400.0),
        TravelerBalance(travelerId: 'user-friend-1', travelerName: 'Amit', totalPaid: 0.0, totalShare: 9700.0, netBalance: -9700.0),
        TravelerBalance(travelerId: 'user-friend-2', travelerName: 'Neha', totalPaid: 0.0, totalShare: 9700.0, netBalance: -9700.0),
      ];
    }
  }

  @override
  Future<List<SettlementSuggestion>> getSettlements(String tripId) async {
    try {
      final res = await _dio.get('/trips/$tripId/settlements');
      return (res.data as List<dynamic>).map((e) => SettlementSuggestion.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return const [
        SettlementSuggestion(id: 'settle-1', payerId: 'user-friend-1', payerName: 'Amit', receiverId: 'user-rameshwar', receiverName: 'Rameshwar', amount: 9700.0, currency: 'INR', status: 'pending'),
        SettlementSuggestion(id: 'settle-2', payerId: 'user-friend-2', payerName: 'Neha', receiverId: 'user-rameshwar', receiverName: 'Rameshwar', amount: 9700.0, currency: 'INR', status: 'pending'),
      ];
    }
  }

  @override
  Future<SettlementSuggestion> markSettlementComplete(String settlementId) async {
    try {
      final res = await _dio.patch('/settlements/$settlementId');
      return SettlementSuggestion.fromJson(res.data as Map<String, dynamic>);
    } catch (_) {
      return SettlementSuggestion(id: settlementId, payerId: 'user-friend-1', payerName: 'Amit', receiverId: 'user-rameshwar', receiverName: 'Rameshwar', amount: 9700.0, currency: 'INR', status: 'settled');
    }
  }

  @override
  Future<FinanceAnalytics> getFinanceAnalytics(String tripId) async {
    try {
      final res = await _dio.get('/trips/$tripId/finance-analytics');
      return FinanceAnalytics.fromJson(res.data as Map<String, dynamic>);
    } catch (_) {
      return const FinanceAnalytics(
        tripId: 'trip-goa-escape',
        totalSpent: 29100.0,
        totalBudget: 50000.0,
        projectedTotalSpend: 34500.0,
        dailyAverageSpend: 9700.0,
        topSpendingCategory: 'Accommodation',
        categoryBreakdown: [
          CategoryBreakdownItem(categoryName: 'Accommodation', amount: 14500.0, percentage: 49.8),
          CategoryBreakdownItem(categoryName: 'Transportation', amount: 8200.0, percentage: 28.2),
          CategoryBreakdownItem(categoryName: 'Food & Dining', amount: 6400.0, percentage: 22.0),
        ],
        spendingInsights: [
          'Accommodation is your largest spending category at ₹14,500.',
          'Daily average spend is ₹9,700.',
          'Projected final trip cost is ₹34,500, well within your ₹50,000 budget.',
        ],
      );
    }
  }
}
