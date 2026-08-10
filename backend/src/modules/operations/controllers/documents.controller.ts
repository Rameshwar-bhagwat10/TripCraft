import { Controller, Get, Post, Delete, Param, Body } from '@nestjs/common';
import { DocumentsService, TravelDocumentDto } from '../services/documents.service';

@Controller()
export class DocumentsController {
  constructor(private readonly documentsService: DocumentsService) {}

  @Get('trips/:tripId/documents')
  async getDocuments(@Param('tripId') tripId: string) {
    return this.documentsService.getDocumentsByTrip(tripId);
  }

  @Post('trips/:tripId/documents')
  async createDocument(@Param('tripId') tripId: string, @Body() body: Partial<TravelDocumentDto>) {
    return this.documentsService.createDocument(tripId, body);
  }

  @Delete('documents/:id')
  async deleteDocument(@Param('id') id: string) {
    return this.documentsService.deleteDocument(id);
  }
}
