import { Injectable, Logger } from '@nestjs/common';

export interface ExchangeRateDto {
  from: string;
  to: string;
  rate: number;
  updatedAt: string;
  isCached: boolean;
}

@Injectable()
export class CurrencyService {
  private readonly logger = new Logger(CurrencyService.name);

  // Default exchange rates relative to USD / INR
  private readonly mockRates: Record<string, number> = {
    INR: 1.0,
    USD: 83.5,
    EUR: 91.2,
    GBP: 106.4,
    AED: 22.7,
    JPY: 0.55,
    AUD: 54.8,
    CAD: 61.2,
    SGD: 62.1,
  };

  async getExchangeRate(from: string, to: string): Promise<ExchangeRateDto> {
    const fromRateInInr = this.mockRates[from.toUpperCase()] || 1.0;
    const toRateInInr = this.mockRates[to.toUpperCase()] || 1.0;

    const rate = fromRateInInr / toRateInInr;

    return {
      from: from.toUpperCase(),
      to: to.toUpperCase(),
      rate: Number(rate.toFixed(4)),
      updatedAt: new Date().toISOString(),
      isCached: true,
    };
  }

  async convertAmount(amount: number, from: string, to: string): Promise<{ convertedAmount: number; rate: number }> {
    if (from.toUpperCase() === to.toUpperCase()) {
      return { convertedAmount: amount, rate: 1.0 };
    }

    const { rate } = await this.getExchangeRate(from, to);
    const convertedAmount = Number((amount * rate).toFixed(2));
    return { convertedAmount, rate };
  }
}
