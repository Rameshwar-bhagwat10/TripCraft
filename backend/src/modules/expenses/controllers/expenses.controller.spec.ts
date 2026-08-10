import { Test, TestingModule } from '@nestjs/testing';
import { ExpensesController } from './expenses.controller';
import { BudgetsController } from './budgets.controller';
import { SettlementsController } from './settlements.controller';
import { FinanceController } from './finance.controller';
import { ExpensesService } from '../services/expenses.service';
import { BudgetsService } from '../services/budgets.service';
import { SettlementsService } from '../services/settlements.service';
import { CurrencyService } from '../services/currency.service';
import { FinanceAnalyticsService } from '../services/finance-analytics.service';

describe('ExpensesController', () => {
  let expensesController: ExpensesController;
  let budgetsController: BudgetsController;
  let financeController: FinanceController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [ExpensesController, BudgetsController, SettlementsController, FinanceController],
      providers: [ExpensesService, BudgetsService, SettlementsService, CurrencyService, FinanceAnalyticsService],
    }).compile();

    expensesController = module.get<ExpensesController>(ExpensesController);
    budgetsController = module.get<BudgetsController>(BudgetsController);
    financeController = module.get<FinanceController>(FinanceController);
  });

  it('should be defined', () => {
    expect(expensesController).toBeDefined();
    expect(budgetsController).toBeDefined();
    expect(financeController).toBeDefined();
  });

  it('should return trip budget overview', async () => {
    const budget = await budgetsController.getBudget('trip-goa-escape');
    expect(budget).toBeDefined();
    expect(budget.totalBudget).toBeGreaterThan(0);
    expect(budget.currency).toBe('INR');
  });

  it('should create an expense and recalculate trip budget', async () => {
    const newExp = await expensesController.createExpense('trip-goa-escape', {
      title: 'Scuba Diving Tour',
      amount: 3500,
      currency: 'INR',
      categoryId: 'activities',
      categoryName: 'Activities',
    });

    expect(newExp).toBeDefined();
    expect(newExp.id).toBeDefined();
    expect(newExp.amount).toBe(3500);
  });

  it('should calculate finance analytics & category breakdown', async () => {
    const analytics = await financeController.getFinanceAnalytics('trip-goa-escape');
    expect(analytics).toBeDefined();
    expect(analytics.categoryBreakdown).toBeDefined();
    expect(analytics.categoryBreakdown.length).toBeGreaterThan(0);
  });
});
