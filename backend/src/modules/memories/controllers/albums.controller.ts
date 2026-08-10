import { Controller, Get, Post, Param, Body } from '@nestjs/common';
import { AlbumsService, PhotoAlbumDto } from '../services/albums.service';

@Controller()
export class AlbumsController {
  constructor(private readonly albumsService: AlbumsService) {}

  @Get('trips/:tripId/albums')
  async getAlbums(@Param('tripId') tripId: string) {
    return this.albumsService.getAlbumsByTrip(tripId);
  }

  @Post('trips/:tripId/albums')
  async createAlbum(@Param('tripId') tripId: string, @Body() body: Partial<PhotoAlbumDto>) {
    return this.albumsService.createAlbum(tripId, body);
  }

  @Get('albums/:id')
  async getAlbumById(@Param('id') id: string) {
    return this.albumsService.getAlbumById(id);
  }

  @Post('albums/:id/photos')
  async addPhotosToAlbum(@Param('id') id: string, @Body('photoIds') photoIds: string[]) {
    return this.albumsService.addPhotosToAlbum(id, photoIds || []);
  }
}
