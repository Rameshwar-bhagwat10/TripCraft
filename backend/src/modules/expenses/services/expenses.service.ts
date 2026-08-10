import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { CurrencyService } from './currency.service';
import { BudgetsService } from './budgets.service';

export interface ExpenseDto {
  id: string;
  tripId: string;
  userId: string;
  categoryId: string;
  categoryName: string;
  title: string;
  description?: string;
  amount: number;
  currency: string;
  baseAmount: number;
  baseCurrency: string;
  exchangeRate: number;
  expenseDate: string;
  payerId: string;
  payerName: string;
  paymentMethod: 'cash' | 'card' | 'upi' | 'bank_transfer' | 'other';
  bookingId?: string;
  itineraryActivityId?: string;
  receiptDocumentId?: string;
  notes?: string;
  createdAt: string;
  updatedAt: string;
}

@Injectable()
export class ExpensesService {
  private readonly logger = new Logger(ExpensesService.name);

  constructor(
    private readonly currencyService: CurrencyService,
    private readonly budgetsService: BudgetsService,
  ) {}

  private mockExpenses: ExpenseDto[] = [
    {
      id: 'exp-hotel-1',
      tripId: 'trip-goa-escape',
      userId: 'user-rameshwar',
      categoryId: 'accommodation',
      categoryName: 'Accommodation',
      title: 'Taj Fort Aguada Advance Payment',
      amount: 14500,
      currency: 'INR',
      baseAmount: 14500,
      baseCurrency: 'INR',
      exchangeRate: 1.0,
      expenseDate: '2026-08-02T10:00:00Z',
      payerId: 'user-rameshwar',
      payerName: 'Rameshwar',
      paymentMethod: 'card',
      bookingId: 'book-hotel-1',
      receiptDocumentId: 'doc-hotel-1',
      createdAt: '2026-08-02T10:05:00Z',
      updatedAt: '2026-08-02T10:05:00Z',
    },
    {
      id: 'exp-flight-1',
      tripId: 'trip-goa-escape',
      userId: 'user-rameshwar',
      categoryId: 'transport',
      categoryName: 'Transportation',
      title: 'IndiGo BOM -> GOI Flight Tickets',
      amount: 8200,
      currency: 'INR',
      baseAmount: 8200,
      baseCurrency: 'INR',
      exchangeRate: 1.0,
      expenseDate: '2026-08-01T15:30:00Z',
      payerId: 'user-rameshwar',
      payerName: 'Rameshwar',
      paymentMethod: 'upi',
      bookingId: 'book-flight-1',
      receiptDocumentId: 'doc-ticket-1',
      createdAt: '2026-08-01T15:35:00Z',
      updatedAt: '2026-08-01T15:35:00Z',
    },
    {
      id: 'exp-dining-1',
      tripId: 'trip-goa-escape',
      userId: 'user-rameshwar',
      categoryId: 'food',
      categoryName: 'Food & Dining',
      title: 'Seafood Dinner at Thalassa',
      amount: 6400,
      currency: 'INR',
      baseAmount: 6400,
      baseCurrency: 'INR',
      exchangeRate: 1.0,
      expenseDate: '2026-08-09T20:45:00Z',
      payerId: 'user-rameshwar',
      payerName: 'Rameshwar',
      paymentMethod: 'card',
      createdAt: '2026-08-09T21:00:00Z',
      updatedAt: '2026-08-09T21:00:00Z',
    },
  ];

  async getExpensesByTrip(tripId: string): Promise<ExpenseDto[]> {
    return this.mockExpenses.filter((e) => e.tripId === tripId);
  }

  async getExpenseById(id: string): Promise<ExpenseDto> {
    const found = this.mockExpenses.find((e) => e.id === id);
    if (!found) {
      throw new NotFoundException(`Expense ${id} not found`);
    }
    return found;
  }

  async createExpense(tripId: string, payload: Partial<ExpenseDto>): Promise<ExpenseDto> {
    const budget = await this.budgetsService.getBudgetByTrip(tripId);
    const currency = payload.currency || budget.currency || 'INR';
    const amount = payload.amount || 0;

    const conversion = await this.currencyService.convertAmount(amount, currency, budget.currency);

    const newExpense: ExpenseDto = {
      id: `exp-${Date.now()}`,
      tripId,
      userId: payload.userId || 'user-rameshwar',
      categoryId: payload.categoryId || 'other',
      categoryName: payload.categoryName || 'Other',
      title: payload.title || 'Travel Expense',
      description: payload.description,
      amount,
      currency,
      baseAmount: conversion.convertedAmount,
      baseCurrency: budget.currency,
      exchangeRate: conversion.rate,
      expenseDate: payload.expenseDate || new Date().toISOString(),
      payerId: payload.payerId || 'user-rameshwar',
      payerName: payload.payerName || 'Rameshwar',
      paymentMethod: payload.paymentMethod || 'card',
      bookingId: payload.bookingId,
      itineraryActivityId: payload.itineraryActivityId,
      receiptDocumentId: payload.receiptDocumentId,
      notes: payload.notes,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };

    this.mockExpenses.push(newExpense);

    // Recalculate trip budget totals
    const allExpenses = await this.getExpensesByTrip(tripId);
    const newSpent = allExpenses.reduce((acc, curr) => acc + curr.baseAmount, 0);
    await this.budgetsService.createOrUpdateBudget(tripId, { spentAmount: newSpent });

    return newExpense;
  }

  async deleteExpense(id: string): Promise<{ success: boolean }> {
    const initialLen = this.mockExpenses.length;
    const target = this.mockExpenses.find((e) => e.id === id);
    this.mockExpenses = this.mockExpenses.filter((e) => e.id !== id);

    if (target) {
      const allExpenses = await this.getExpensesByTrip(target.tripId);
      const newSpent = allExpenses.reduce((acc, curr) => acc + curr.baseAmount, 0);
      await this.budgetsService.createOrUpdateBudget(target.tripId, { spentAmount: newSpent });
    }

    return { success: this.mockExpenses.length < initialLen };
  }
}
