import { Controller, Get, Post, Patch, Delete, Param, Body } from '@nestjs/common';
import { BookingsService, BookingDto } from '../services/bookings.service';

@Controller()
export class BookingsController {
  constructor(private readonly bookingsService: BookingsService) {}

  @Get('trips/:tripId/bookings')
  async getBookings(@Param('tripId') tripId: string) {
    return this.bookingsService.getBookingsByTrip(tripId);
  }

  @Post('trips/:tripId/bookings')
  async createBooking(@Param('tripId') tripId: string, @Body() body: Partial<BookingDto>) {
    return this.bookingsService.createBooking(tripId, body);
  }

  @Get('bookings/:id')
  async getBookingById(@Param('id') id: string) {
    return this.bookingsService.getBookingById(id);
  }

  @Patch('bookings/:id')
  async updateBooking(@Param('id') id: string, @Body() body: Partial<BookingDto>) {
    return this.bookingsService.updateBooking(id, body);
  }

  @Delete('bookings/:id')
  async deleteBooking(@Param('id') id: string) {
    return this.bookingsService.deleteBooking(id);
  }
}
