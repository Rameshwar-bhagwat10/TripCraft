import { Injectable, Logger, NotFoundException } from '@nestjs/common';

export interface CategoryBudgetDto {
  categoryId: string;
  categoryName: string;
  allocatedAmount: number;
  spentAmount: number;
}

export interface TripBudgetDto {
  id: string;
  tripId: string;
  totalBudget: number;
  currency: string;
  spentAmount: number;
  remainingAmount: number;
  percentageUsed: number;
  status: 'on_track' | 'approaching_limit' | 'over_budget';
  dailyAllowance: number;
  categoryBudgets: CategoryBudgetDto[];
  createdAt: string;
  updatedAt: string;
}

@Injectable()
export class BudgetsService {
  private readonly logger = new Logger(BudgetsService.name);

  private mockBudgets: Record<string, TripBudgetDto> = {
    'trip-goa-escape': {
      id: 'budget-goa-1',
      tripId: 'trip-goa-escape',
      totalBudget: 50000,
      currency: 'INR',
      spentAmount: 32450,
      remainingAmount: 17550,
      percentageUsed: 64.9,
      status: 'on_track',
      dailyAllowance: 4387.5,
      categoryBudgets: [
        { categoryId: 'accommodation', categoryName: 'Accommodation', allocatedAmount: 20000, spentAmount: 14500 },
        { categoryId: 'transport', categoryName: 'Transportation', allocatedAmount: 12000, spentAmount: 8200 },
        { categoryId: 'food', categoryName: 'Food & Dining', allocatedAmount: 10000, spentAmount: 6400 },
        { categoryId: 'activities', categoryName: 'Activities', allocatedAmount: 5000, spentAmount: 2350 },
        { categoryId: 'shopping', categoryName: 'Shopping', allocatedAmount: 3000, spentAmount: 1000 },
      ],
      createdAt: '2026-08-01T00:00:00Z',
      updatedAt: '2026-08-10T12:00:00Z',
    },
  };

  async getBudgetByTrip(tripId: string): Promise<TripBudgetDto> {
    if (this.mockBudgets[tripId]) {
      return this.mockBudgets[tripId];
    }

    return {
      id: `budget-${Date.now()}`,
      tripId,
      totalBudget: 50000,
      currency: 'INR',
      spentAmount: 0,
      remainingAmount: 50000,
      percentageUsed: 0,
      status: 'on_track',
      dailyAllowance: 10000,
      categoryBudgets: [
        { categoryId: 'accommodation', categoryName: 'Accommodation', allocatedAmount: 20000, spentAmount: 0 },
        { categoryId: 'transport', categoryName: 'Transportation', allocatedAmount: 12000, spentAmount: 0 },
        { categoryId: 'food', categoryName: 'Food & Dining', allocatedAmount: 10000, spentAmount: 0 },
        { categoryId: 'activities', categoryName: 'Activities', allocatedAmount: 5000, spentAmount: 0 },
        { categoryId: 'shopping', categoryName: 'Shopping', allocatedAmount: 3000, spentAmount: 0 },
      ],
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };
  }

  async createOrUpdateBudget(tripId: string, payload: Partial<TripBudgetDto>): Promise<TripBudgetDto> {
    const existing = await this.getBudgetByTrip(tripId);

    const totalBudget = payload.totalBudget ?? existing.totalBudget;
    const spentAmount = payload.spentAmount ?? existing.spentAmount;
    const remainingAmount = totalBudget - spentAmount;
    const percentageUsed = totalBudget > 0 ? Number(((spentAmount / totalBudget) * 100).toFixed(1)) : 0;

    let status: 'on_track' | 'approaching_limit' | 'over_budget' = 'on_track';
    if (percentageUsed >= 100) {
      status = 'over_budget';
    } else if (percentageUsed >= 80) {
      status = 'approaching_limit';
    }

    const updated: TripBudgetDto = {
      ...existing,
      totalBudget,
      currency: payload.currency || existing.currency,
      spentAmount,
      remainingAmount,
      percentageUsed,
      status,
      categoryBudgets: payload.categoryBudgets || existing.categoryBudgets,
      updatedAt: new Date().toISOString(),
    };

    this.mockBudgets[tripId] = updated;
    return updated;
  }
}
