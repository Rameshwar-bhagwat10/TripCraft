import { Injectable, Logger } from '@nestjs/common';
import { ExpensesService } from './expenses.service';

export interface TravelerBalanceDto {
  travelerId: string;
  travelerName: string;
  totalPaid: number;
  totalShare: number;
  netBalance: number; // positive = owed money (+), negative = owes money (-)
}

export interface SettlementSuggestionDto {
  id: string;
  payerId: string;
  payerName: string;
  receiverId: string;
  receiverName: string;
  amount: number;
  currency: string;
  status: 'pending' | 'settled';
}

@Injectable()
export class SettlementsService {
  private readonly logger = new Logger(SettlementsService.name);

  constructor(private readonly expensesService: ExpensesService) {}

  private mockSettlements: SettlementSuggestionDto[] = [
    {
      id: 'settle-1',
      payerId: 'user-friend-1',
      payerName: 'Amit',
      receiverId: 'user-rameshwar',
      receiverName: 'Rameshwar',
      amount: 2130,
      currency: 'INR',
      status: 'pending',
    },
    {
      id: 'settle-2',
      payerId: 'user-friend-2',
      payerName: 'Neha',
      receiverId: 'user-rameshwar',
      receiverName: 'Rameshwar',
      amount: 1450,
      currency: 'INR',
      status: 'pending',
    },
  ];

  async getTravelerBalances(tripId: string): Promise<TravelerBalanceDto[]> {
    const expenses = await this.expensesService.getExpensesByTrip(tripId);
    const totalSpent = expenses.reduce((sum, e) => sum + e.baseAmount, 0);

    // Mock 3 travelers sharing costs
    const sharePerPerson = Number((totalSpent / 3).toFixed(2));

    return [
      {
        travelerId: 'user-rameshwar',
        travelerName: 'Rameshwar',
        totalPaid: totalSpent,
        totalShare: sharePerPerson,
        netBalance: Number((totalSpent - sharePerPerson).toFixed(2)),
      },
      {
        travelerId: 'user-friend-1',
        travelerName: 'Amit',
        totalPaid: 0,
        totalShare: sharePerPerson,
        netBalance: Number((0 - sharePerPerson).toFixed(2)),
      },
      {
        travelerId: 'user-friend-2',
        travelerName: 'Neha',
        totalPaid: 0,
        totalShare: sharePerPerson,
        netBalance: Number((0 - sharePerPerson).toFixed(2)),
      },
    ];
  }

  async getSettlementsByTrip(tripId: string): Promise<SettlementSuggestionDto[]> {
    return this.mockSettlements;
  }

  async markSettlementComplete(settlementId: string): Promise<SettlementSuggestionDto> {
    const target = this.mockSettlements.find((s) => s.id === settlementId);
    if (target) {
      target.status = 'settled';
      return target;
    }
    return {
      id: settlementId,
      payerId: 'user-friend-1',
      payerName: 'Amit',
      receiverId: 'user-rameshwar',
      receiverName: 'Rameshwar',
      amount: 2130,
      currency: 'INR',
      status: 'settled',
    };
  }
}
