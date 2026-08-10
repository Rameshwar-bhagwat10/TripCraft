import { Injectable, Logger } from '@nestjs/common';
import { AiContextManagerService } from './ai-context-manager.service';
import { AiToolRegistryService } from './ai-tool-registry.service';

export interface AiMessageDto {
  id: string;
  conversationId: string;
  role: 'user' | 'assistant' | 'tool' | 'system';
  content: string;
  cards?: any[];
  actionProposal?: {
    id: string;
    type: string;
    title: string;
    description: string;
    currentValue: string;
    proposedValue: string;
    reason: string;
    riskLevel: 'low' | 'medium' | 'high';
  };
  createdAt: string;
}

export interface AiConversationDto {
  id: string;
  title: string;
  tripId?: string;
  activeContextChip: string;
  createdAt: string;
  updatedAt: string;
}

@Injectable()
export class AiService {
  private readonly logger = new Logger(AiService.name);

  constructor(
    private readonly contextManager: AiContextManagerService,
    private readonly toolRegistry: AiToolRegistryService,
  ) {}

  async createConversation(userId: string, tripId?: string): Promise<AiConversationDto> {
    return {
      id: `conv-${Date.now()}`,
      title: 'Goa Trip Copilot Chat',
      tripId: tripId || 'trip-goa-escape',
      activeContextChip: 'Goa Trip · Day 1 · Fort Aguada',
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };
  }

  async sendMessage(userId: string, conversationId: string, userMessageText: string, tripId?: string): Promise<AiMessageDto> {
    const textLower = userMessageText.toLowerCase();

    // Intent detection & tool execution logic
    if (textLower.includes('weather') || textLower.includes('rain')) {
      const weatherData = await this.toolRegistry.executeReadTool('get_weather', { tripId });
      return {
        id: `msg-${Date.now()}`,
        conversationId,
        role: 'assistant',
        content: `Here is the current weather forecast for your Goa trip. Afternoon rain (85% probability) is expected on Day 2 during outdoor beach activities.`,
        cards: [
          {
            type: 'weatherCard',
            data: weatherData,
          },
        ],
        createdAt: new Date().toISOString(),
      };
    }

    if (textLower.includes('move') || textLower.includes('baga beach') || textLower.includes('schedule') || textLower.includes('optimize')) {
      return {
        id: `msg-${Date.now()}`,
        conversationId,
        role: 'assistant',
        content: `I've analyzed your itinerary against afternoon rain conditions on Day 2. I propose moving Baga Beach Watersports to 10:00 AM during the clear morning window.`,
        actionProposal: {
          id: `act-prop-${Date.now()}`,
          type: 'move_activity',
          title: 'Move Baga Beach Watersports',
          description: 'Reschedule beach visit to the sunny morning window.',
          currentValue: '03:00 PM (Heavy Rain Risk)',
          proposedValue: '10:00 AM (Sunny Window)',
          reason: 'Avoids 85% rain probability and reduces daily travel time by 18 minutes.',
          riskLevel: 'medium',
        },
        createdAt: new Date().toISOString(),
      };
    }

    if (textLower.includes('cafe') || textLower.includes('place') || textLower.includes('food')) {
      const placesData = await this.toolRegistry.executeReadTool('search_places', { query: 'cafe' });
      return {
        id: `msg-${Date.now()}`,
        conversationId,
        role: 'assistant',
        content: `I found these top-rated places near your itinerary route:`,
        cards: [
          {
            type: 'placeCard',
            data: placesData,
          },
        ],
        createdAt: new Date().toISOString(),
      };
    }

    // Default conversational reasoning
    return {
      id: `msg-${Date.now()}`,
      conversationId,
      role: 'assistant',
      content: `Your Goa trip is looking in great shape overall! You have 5 activities planned across 5 days. Is there anything specific you would like to adjust or check?`,
      createdAt: new Date().toISOString(),
    };
  }

  async confirmAction(userId: string, actionId: string) {
    return {
      actionId,
      status: 'applied',
      message: 'Itinerary schedule updated successfully. Route and weather intelligence recalculated.',
    };
  }

  async rejectAction(userId: string, actionId: string) {
    return {
      actionId,
      status: 'rejected',
      message: 'Action proposal rejected. Your itinerary remains unchanged.',
    };
  }

  async getMemories(userId: string) {
    return [
      { id: 'mem-1', category: 'preference', key: 'travel_style', value: 'Prefers quiet cafes and historic sightseeing', createdAt: '2026-08-09T10:00:00Z' },
      { id: 'mem-2', category: 'constraint', key: 'pace', value: 'Prefers relaxed mornings with clear activity buffer', createdAt: '2026-08-09T11:00:00Z' },
      { id: 'mem-3', category: 'avoidance', key: 'weather_risk', value: 'Avoids outdoor beach activities during heavy rain', createdAt: '2026-08-09T12:00:00Z' },
    ];
  }

  async deleteMemory(userId: string, memoryId: string) {
    return { success: true, deletedMemoryId: memoryId };
  }
}
