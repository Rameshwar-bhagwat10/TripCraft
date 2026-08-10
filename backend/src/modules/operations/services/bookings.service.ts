import { Injectable, Logger, NotFoundException } from '@nestjs/common';

export interface BookingDto {
  id: string;
  tripId: string;
  type: 'flight' | 'hotel' | 'train' | 'bus' | 'car_rental' | 'activity' | 'restaurant' | 'other';
  title: string;
  providerName: string;
  confirmationNumber: string;
  status: 'draft' | 'pending' | 'confirmed' | 'cancelled' | 'completed';
  startDateTime: string;
  endDateTime?: string;
  location?: string;
  details?: Record<string, any>;
  linkedDocumentIds?: string[];
  createdAt: string;
}

@Injectable()
export class BookingsService {
  private readonly logger = new Logger(BookingsService.name);

  private mockBookings: BookingDto[] = [
    {
      id: 'book-flight-1',
      tripId: 'trip-goa-escape',
      type: 'flight',
      title: 'IndiGo Flight 6E-204 (BOM -> GOI)',
      providerName: 'IndiGo Airlines',
      confirmationNumber: '6E-PNR-8849',
      status: 'confirmed',
      startDateTime: '2026-08-21T08:30:00Z',
      endDateTime: '2026-08-21T09:45:00Z',
      location: 'Chhatrapati Shivaji Maharaj Intl Airport (BOM)',
      details: {
        flightNumber: '6E-204',
        departureTerminal: 'T2',
        seat: '12F',
        gate: 'B4',
        baggageAllowance: '15kg',
      },
      linkedDocumentIds: ['doc-ticket-1'],
      createdAt: '2026-08-01T10:00:00Z',
    },
    {
      id: 'book-hotel-1',
      tripId: 'trip-goa-escape',
      type: 'hotel',
      title: 'Taj Fort Aguada Resort & Spa',
      providerName: 'Taj Hotels',
      confirmationNumber: 'TAJ-RES-9932',
      status: 'confirmed',
      startDateTime: '2026-08-21T14:00:00Z',
      endDateTime: '2026-08-25T11:00:00Z',
      location: 'Sinquerim Beach, Candolim, Goa',
      details: {
        checkInTime: '02:00 PM',
        checkOutTime: '11:00 AM',
        roomType: 'Sea View Suite',
        guests: 2,
      },
      linkedDocumentIds: ['doc-hotel-1'],
      createdAt: '2026-08-02T11:00:00Z',
    },
    {
      id: 'book-act-1',
      tripId: 'trip-goa-escape',
      type: 'activity',
      title: 'Scuba Diving & Watersports Adventure',
      providerName: 'Goa Ocean Adventures',
      confirmationNumber: 'GOA-DIV-104',
      status: 'pending',
      startDateTime: '2026-08-22T10:00:00Z',
      endDateTime: '2026-08-22T13:30:00Z',
      location: 'Grand Island, Goa',
      details: {
        meetingPoint: 'Malim Jetty, Panaji',
        participants: 2,
      },
      linkedDocumentIds: [],
      createdAt: '2026-08-05T14:00:00Z',
    },
  ];

  async getBookingsByTrip(tripId: string): Promise<BookingDto[]> {
    return this.mockBookings.filter((b) => b.tripId === tripId);
  }

  async getBookingById(bookingId: string): Promise<BookingDto> {
    const found = this.mockBookings.find((b) => b.id === bookingId);
    if (!found) throw new NotFoundException(`Booking with id ${bookingId} not found`);
    return found;
  }

  async createBooking(tripId: string, payload: Partial<BookingDto>): Promise<BookingDto> {
    const newBooking: BookingDto = {
      id: `book-${Date.now()}`,
      tripId,
      type: payload.type || 'other',
      title: payload.title || 'Travel Reservation',
      providerName: payload.providerName || 'Provider',
      confirmationNumber: payload.confirmationNumber || `REF-${Math.floor(100000 + Math.random() * 900000)}`,
      status: payload.status || 'confirmed',
      startDateTime: payload.startDateTime || new Date().toISOString(),
      endDateTime: payload.endDateTime,
      location: payload.location,
      details: payload.details || {},
      linkedDocumentIds: payload.linkedDocumentIds || [],
      createdAt: new Date().toISOString(),
    };

    this.mockBookings.push(newBooking);
    return newBooking;
  }

  async updateBooking(bookingId: string, updates: Partial<BookingDto>): Promise<BookingDto> {
    const index = this.mockBookings.findIndex((b) => b.id === bookingId);
    if (index === -1) throw new NotFoundException(`Booking ${bookingId} not found`);

    this.mockBookings[index] = {
      ...this.mockBookings[index],
      ...updates,
    };

    return this.mockBookings[index];
  }

  async deleteBooking(bookingId: string): Promise<{ success: boolean }> {
    const initialLen = this.mockBookings.length;
    this.mockBookings = this.mockBookings.filter((b) => b.id !== bookingId);
    return { success: this.mockBookings.length < initialLen };
  }
}
