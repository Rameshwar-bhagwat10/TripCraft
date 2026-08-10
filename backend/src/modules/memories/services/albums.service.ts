import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { PhotosService, TripPhotoDto } from './photos.service';

export interface PhotoAlbumDto {
  id: string;
  tripId: string;
  userId: string;
  title: string;
  description?: string;
  coverPhotoUrl: string;
  photoCount: number;
  createdAt: string;
  updatedAt: string;
}

@Injectable()
export class AlbumsService {
  private readonly logger = new Logger(AlbumsService.name);

  constructor(private readonly photosService: PhotosService) {}

  private mockAlbums: PhotoAlbumDto[] = [
    {
      id: 'album-sunsets-1',
      tripId: 'trip-goa-escape',
      userId: 'user-rameshwar',
      title: 'Beach Sunsets & Evenings',
      description: 'Golden hour pictures from Baga & Anjuna beach shacks',
      coverPhotoUrl: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=600',
      photoCount: 12,
      createdAt: '2026-08-21T19:00:00Z',
      updatedAt: '2026-08-21T19:00:00Z',
    },
    {
      id: 'album-sightseeing-1',
      tripId: 'trip-goa-escape',
      userId: 'user-rameshwar',
      title: 'Historic Forts & Architecture',
      description: 'Fort Aguada, Chapora & Old Goa Latin Quarter',
      coverPhotoUrl: 'https://images.unsplash.com/photo-1587922546307-776227941871?w=600',
      photoCount: 18,
      createdAt: '2026-08-22T12:00:00Z',
      updatedAt: '2026-08-22T12:00:00Z',
    },
  ];

  async getAlbumsByTrip(tripId: string): Promise<PhotoAlbumDto[]> {
    return this.mockAlbums.filter((a) => a.tripId === tripId);
  }

  async getAlbumById(id: string): Promise<PhotoAlbumDto> {
    const album = this.mockAlbums.find((a) => a.id === id);
    if (!album) throw new NotFoundException(`Album ${id} not found`);
    return album;
  }

  async createAlbum(tripId: string, payload: Partial<PhotoAlbumDto>): Promise<PhotoAlbumDto> {
    const newAlbum: PhotoAlbumDto = {
      id: `album-${Date.now()}`,
      tripId,
      userId: payload.userId || 'user-rameshwar',
      title: payload.title || 'New Photo Album',
      description: payload.description || 'Custom collection of trip photos',
      coverPhotoUrl: payload.coverPhotoUrl || 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600',
      photoCount: 0,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };

    this.mockAlbums.push(newAlbum);
    return newAlbum;
  }

  async addPhotosToAlbum(albumId: string, photoIds: string[]): Promise<PhotoAlbumDto> {
    const album = await this.getAlbumById(albumId);
    album.photoCount += photoIds.length;
    album.updatedAt = new Date().toISOString();
    return album;
  }
}
