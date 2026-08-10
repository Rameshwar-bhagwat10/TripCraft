import { Injectable, Logger, NotFoundException } from '@nestjs/common';

export interface TravelDocumentDto {
  id: string;
  tripId: string;
  bookingId?: string;
  title: string;
  category: 'transport' | 'accommodation' | 'activities' | 'insurance' | 'identification' | 'other';
  fileType: string;
  fileSizeBytes: number;
  storagePath: string;
  uploadedAt: string;
  isPrivate: boolean;
}

@Injectable()
export class DocumentsService {
  private readonly logger = new Logger(DocumentsService.name);

  private mockDocuments: TravelDocumentDto[] = [
    {
      id: 'doc-ticket-1',
      tripId: 'trip-goa-escape',
      bookingId: 'book-flight-1',
      title: 'IndiGo Flight E-Ticket.pdf',
      category: 'transport',
      fileType: 'pdf',
      fileSizeBytes: 428000,
      storagePath: 'private/documents/indigo-eticket-8849.pdf',
      uploadedAt: '2026-08-01T10:05:00Z',
      isPrivate: true,
    },
    {
      id: 'doc-hotel-1',
      tripId: 'trip-goa-escape',
      bookingId: 'book-hotel-1',
      title: 'Taj Hotel Booking Voucher.pdf',
      category: 'accommodation',
      fileType: 'pdf',
      fileSizeBytes: 612000,
      storagePath: 'private/documents/taj-voucher-9932.pdf',
      uploadedAt: '2026-08-02T11:10:00Z',
      isPrivate: true,
    },
  ];

  async getDocumentsByTrip(tripId: string): Promise<TravelDocumentDto[]> {
    return this.mockDocuments.filter((d) => d.tripId === tripId);
  }

  async createDocument(tripId: string, payload: Partial<TravelDocumentDto>): Promise<TravelDocumentDto> {
    const newDoc: TravelDocumentDto = {
      id: `doc-${Date.now()}`,
      tripId,
      bookingId: payload.bookingId,
      title: payload.title || 'Travel Document.pdf',
      category: payload.category || 'other',
      fileType: payload.fileType || 'pdf',
      fileSizeBytes: payload.fileSizeBytes || 250000,
      storagePath: `private/documents/${Date.now()}-${payload.title || 'doc.pdf'}`,
      uploadedAt: new Date().toISOString(),
      isPrivate: true,
    };

    this.mockDocuments.push(newDoc);
    return newDoc;
  }

  async deleteDocument(documentId: string): Promise<{ success: boolean }> {
    const initialLen = this.mockDocuments.length;
    this.mockDocuments = this.mockDocuments.filter((d) => d.id !== documentId);
    return { success: this.mockDocuments.length < initialLen };
  }
}
