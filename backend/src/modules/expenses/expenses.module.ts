import { Module } from '@nestjs/common';
import { BudgetsController } from './controllers/budgets.controller';
import { ExpensesController } from './controllers/expenses.controller';
import { SettlementsController } from './controllers/settlements.controller';
import { FinanceController } from './controllers/finance.controller';
import { CurrencyService } from './services/currency.service';
import { BudgetsService } from './services/budgets.service';
import { ExpensesService } from './services/expenses.service';
import { SettlementsService } from './services/settlements.service';
import { FinanceAnalyticsService } from './services/finance-analytics.service';

@Module({
  controllers: [BudgetsController, ExpensesController, SettlementsController, FinanceController],
  providers: [CurrencyService, BudgetsService, ExpensesService, SettlementsService, FinanceAnalyticsService],
  exports: [CurrencyService, BudgetsService, ExpensesService, SettlementsService, FinanceAnalyticsService],
})
export class ExpensesModule {}
