import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_providers.dart';
import '../../data/datasources/expenses_remote_datasource.dart';
import '../../data/repositories/expenses_repository_impl.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/settlement.dart';
import '../../domain/entities/trip_budget.dart';

class TripFinanceState {
  final bool isLoading;
  final TripBudget? budget;
  final List<Expense> expenses;
  final List<TravelerBalance> balances;
  final List<SettlementSuggestion> settlements;
  final FinanceAnalytics? analytics;
  final String selectedCategoryFilter;
  final String? errorMessage;

  const TripFinanceState({
    this.isLoading = false,
    this.budget,
    this.expenses = const [],
    this.balances = const [],
    this.settlements = const [],
    this.analytics,
    this.selectedCategoryFilter = 'all',
    this.errorMessage,
  });

  TripFinanceState copyWith({
    bool? isLoading,
    TripBudget? budget,
    List<Expense>? expenses,
    List<TravelerBalance>? balances,
    List<SettlementSuggestion>? settlements,
    FinanceAnalytics? analytics,
    String? selectedCategoryFilter,
    String? errorMessage,
  }) {
    return TripFinanceState(
      isLoading: isLoading ?? this.isLoading,
      budget: budget ?? this.budget,
      expenses: expenses ?? this.expenses,
      balances: balances ?? this.balances,
      settlements: settlements ?? this.settlements,
      analytics: analytics ?? this.analytics,
      selectedCategoryFilter: selectedCategoryFilter ?? this.selectedCategoryFilter,
      errorMessage: errorMessage,
    );
  }
}

final expensesRepositoryProvider = Provider<ExpensesRepositoryImpl>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final ds = ExpensesRemoteDataSourceImpl(apiClient.client);
  return ExpensesRepositoryImpl(ds);
});

class TripFinanceNotifier extends StateNotifier<TripFinanceState> {
  final ExpensesRepositoryImpl _repository;
  final String tripId;

  TripFinanceNotifier(this._repository, this.tripId) : super(const TripFinanceState()) {
    loadFinanceData();
  }

  Future<void> loadFinanceData() async {
    state = state.copyWith(isLoading: true);
    try {
      final [budget, expenses, balances, settlements, analytics] = await Future.wait([
        _repository.getBudget(tripId),
        _repository.getExpenses(tripId),
        _repository.getTravelerBalances(tripId),
        _repository.getSettlements(tripId),
        _repository.getFinanceAnalytics(tripId),
      ]);

      state = state.copyWith(
        isLoading: false,
        budget: budget as TripBudget,
        expenses: expenses as List<Expense>,
        balances: balances as List<TravelerBalance>,
        settlements: settlements as List<SettlementSuggestion>,
        analytics: analytics as FinanceAnalytics,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false, errorMessage: 'Failed to load trip finances.');
    }
  }

  void setCategoryFilter(String category) {
    state = state.copyWith(selectedCategoryFilter: category);
  }

  Future<void> createExpense(Map<String, dynamic> body) async {
    final newExp = await _repository.createExpense(tripId, body);
    state = state.copyWith(expenses: [...state.expenses, newExp]);
    loadFinanceData();
  }

  Future<void> deleteExpense(String expenseId) async {
    await _repository.deleteExpense(expenseId);
    state = state.copyWith(expenses: state.expenses.where((e) => e.id != expenseId).toList());
    loadFinanceData();
  }

  Future<void> updateBudget(Map<String, dynamic> body) async {
    final updated = await _repository.createOrUpdateBudget(tripId, body);
    state = state.copyWith(budget: updated);
    loadFinanceData();
  }

  Future<void> markSettlementComplete(String settlementId) async {
    await _repository.markSettlementComplete(settlementId);
    loadFinanceData();
  }
}

final tripFinanceProvider = StateNotifierProvider.family<TripFinanceNotifier, TripFinanceState, String>((ref, tripId) {
  final repo = ref.watch(expensesRepositoryProvider);
  return TripFinanceNotifier(repo, tripId);
});
