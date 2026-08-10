import '../datasources/expenses_remote_datasource.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/settlement.dart';
import '../../domain/entities/trip_budget.dart';

class ExpensesRepositoryImpl {
  final ExpensesRemoteDataSource _dataSource;

  ExpensesRepositoryImpl(this._dataSource);

  Future<TripBudget> getBudget(String tripId) => _dataSource.getBudget(tripId);
  Future<TripBudget> createOrUpdateBudget(String tripId, Map<String, dynamic> body) => _dataSource.createOrUpdateBudget(tripId, body);
  Future<List<Expense>> getExpenses(String tripId) => _dataSource.getExpenses(tripId);
  Future<Expense> createExpense(String tripId, Map<String, dynamic> body) => _dataSource.createExpense(tripId, body);
  Future<void> deleteExpense(String expenseId) => _dataSource.deleteExpense(expenseId);
  Future<List<TravelerBalance>> getTravelerBalances(String tripId) => _dataSource.getTravelerBalances(tripId);
  Future<List<SettlementSuggestion>> getSettlements(String tripId) => _dataSource.getSettlements(tripId);
  Future<SettlementSuggestion> markSettlementComplete(String settlementId) => _dataSource.markSettlementComplete(settlementId);
  Future<FinanceAnalytics> getFinanceAnalytics(String tripId) => _dataSource.getFinanceAnalytics(tripId);
}
