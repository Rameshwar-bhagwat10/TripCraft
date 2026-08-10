import { Controller, Get, Post, Delete, Body, Param, Query } from '@nestjs/common';
import { AiService } from '../services/ai.service';

@Controller('ai')
export class AiController {
  constructor(private readonly aiService: AiService) {}

  @Post('conversations')
  async createConversation(@Body() body: { tripId?: string }) {
    return this.aiService.createConversation('user-1', body.tripId);
  }

  @Post('conversations/:id/messages')
  async sendMessage(
    @Param('id') conversationId: string,
    @Body() body: { message: string; tripId?: string },
  ) {
    return this.aiService.sendMessage('user-1', conversationId, body.message, body.tripId);
  }

  @Post('actions/:id/confirm')
  async confirmAction(@Param('id') actionId: string) {
    return this.aiService.confirmAction('user-1', actionId);
  }

  @Post('actions/:id/reject')
  async rejectAction(@Param('id') actionId: string) {
    return this.aiService.rejectAction('user-1', actionId);
  }

  @Get('memories')
  async getMemories() {
    return this.aiService.getMemories('user-1');
  }

  @Delete('memories/:id')
  async deleteMemory(@Param('id') memoryId: string) {
    return this.aiService.deleteMemory('user-1', memoryId);
  }
}
