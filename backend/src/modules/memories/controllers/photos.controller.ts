import { Controller, Get, Post, Delete, Param, Body } from '@nestjs/common';
import { PhotosService, TripPhotoDto } from '../services/photos.service';

@Controller()
export class PhotosController {
  constructor(private readonly photosService: PhotosService) {}

  @Get('trips/:tripId/photos')
  async getPhotos(@Param('tripId') tripId: string) {
    return this.photosService.getPhotosByTrip(tripId);
  }

  @Post('trips/:tripId/photos')
  async createPhoto(@Param('tripId') tripId: string, @Body() body: Partial<TripPhotoDto>) {
    return this.photosService.createPhoto(tripId, body);
  }

  @Get('photos/:id')
  async getPhotoById(@Param('id') id: string) {
    return this.photosService.getPhotoById(id);
  }

  @Post('photos/:id/favorite')
  async toggleFavorite(@Param('id') id: string) {
    return this.photosService.toggleFavorite(id);
  }

  @Delete('photos/:id')
  async deletePhoto(@Param('id') id: string) {
    return this.photosService.deletePhoto(id);
  }
}
