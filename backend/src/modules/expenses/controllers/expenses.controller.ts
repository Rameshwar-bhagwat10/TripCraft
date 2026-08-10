import { Controller, Get, Post, Delete, Param, Body } from '@nestjs/common';
import { ExpensesService, ExpenseDto } from '../services/expenses.service';

@Controller()
export class ExpensesController {
  constructor(private readonly expensesService: ExpensesService) {}

  @Get('trips/:tripId/expenses')
  async getExpenses(@Param('tripId') tripId: string) {
    return this.expensesService.getExpensesByTrip(tripId);
  }

  @Post('trips/:tripId/expenses')
  async createExpense(@Param('tripId') tripId: string, @Body() body: Partial<ExpenseDto>) {
    return this.expensesService.createExpense(tripId, body);
  }

  @Get('expenses/:id')
  async getExpenseById(@Param('id') id: string) {
    return this.expensesService.getExpenseById(id);
  }

  @Delete('expenses/:id')
  async deleteExpense(@Param('id') id: string) {
    return this.expensesService.deleteExpense(id);
  }
}
