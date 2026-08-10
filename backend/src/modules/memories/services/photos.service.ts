import { Injectable, Logger, NotFoundException } from '@nestjs/common';

export interface TripPhotoDto {
  id: string;
  tripId: string;
  userId: string;
  storagePath: string;
  thumbnailPath: string;
  previewPath: string;
  fileName: string;
  fileSizeBytes: number;
  width: number;
  height: number;
  caption?: string;
  latitude?: number;
  longitude?: number;
  locationName?: string;
  takenAt: string;
  uploadedAt: string;
  itineraryActivityId?: string;
  placeId?: string;
  tripDay?: number;
  isFavorite: boolean;
  albumIds: string[];
}

@Injectable()
export class PhotosService {
  private readonly logger = new Logger(PhotosService.name);

  private mockPhotos: TripPhotoDto[] = [
    {
      id: 'photo-baga-sunset-1',
      tripId: 'trip-goa-escape',
      userId: 'user-rameshwar',
      storagePath: 'private/memories/baga-sunset-1.jpg',
      thumbnailPath: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=400',
      previewPath: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=1200',
      fileName: 'baga-sunset-1.jpg',
      fileSizeBytes: 2450000,
      width: 3840,
      height: 2160,
      caption: 'Golden hour sunset at Baga Beach',
      latitude: 15.5551,
      longitude: 73.7512,
      locationName: 'Baga Beach, North Goa',
      takenAt: '2026-08-21T18:15:00Z',
      uploadedAt: '2026-08-21T18:30:00Z',
      itineraryActivityId: 'item-1',
      placeId: 'place-baga-beach',
      tripDay: 1,
      isFavorite: true,
      albumIds: ['album-sunsets-1'],
    },
    {
      id: 'photo-fort-aguada-1',
      tripId: 'trip-goa-escape',
      userId: 'user-rameshwar',
      storagePath: 'private/memories/fort-aguada-1.jpg',
      thumbnailPath: 'https://images.unsplash.com/photo-1587922546307-776227941871?w=400',
      previewPath: 'https://images.unsplash.com/photo-1587922546307-776227941871?w=1200',
      fileName: 'fort-aguada-1.jpg',
      fileSizeBytes: 3100000,
      width: 4000,
      height: 3000,
      caption: 'Panoramics from Fort Aguada lighthouse',
      latitude: 15.4924,
      longitude: 73.7737,
      locationName: 'Fort Aguada, Candolim',
      takenAt: '2026-08-22T10:30:00Z',
      uploadedAt: '2026-08-22T11:00:00Z',
      itineraryActivityId: 'item-2',
      placeId: 'place-fort-aguada',
      tripDay: 2,
      isFavorite: true,
      albumIds: ['album-sightseeing-1'],
    },
    {
      id: 'photo-thalassa-dinner-1',
      tripId: 'trip-goa-escape',
      userId: 'user-rameshwar',
      storagePath: 'private/memories/thalassa-1.jpg',
      thumbnailPath: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=400',
      previewPath: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=1200',
      fileName: 'thalassa-1.jpg',
      fileSizeBytes: 1850000,
      width: 3024,
      height: 4032,
      caption: 'Greek dinner at Thalassa Vagator',
      latitude: 15.6022,
      longitude: 73.7335,
      locationName: 'Thalassa Restaurant, Vagator',
      takenAt: '2026-08-22T20:00:00Z',
      uploadedAt: '2026-08-22T21:15:00Z',
      tripDay: 2,
      isFavorite: false,
      albumIds: [],
    },
  ];

  async getPhotosByTrip(tripId: string): Promise<TripPhotoDto[]> {
    return this.mockPhotos.filter((p) => p.tripId === tripId);
  }

  async getPhotoById(id: string): Promise<TripPhotoDto> {
    const photo = this.mockPhotos.find((p) => p.id === id);
    if (!photo) throw new NotFoundException(`Photo ${id} not found`);
    return photo;
  }

  async createPhoto(tripId: string, payload: Partial<TripPhotoDto>): Promise<TripPhotoDto> {
    const newPhoto: TripPhotoDto = {
      id: `photo-${Date.now()}`,
      tripId,
      userId: payload.userId || 'user-rameshwar',
      storagePath: `private/memories/${Date.now()}-${payload.fileName || 'photo.jpg'}`,
      thumbnailPath: payload.thumbnailPath || 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400',
      previewPath: payload.previewPath || 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200',
      fileName: payload.fileName || 'photo.jpg',
      fileSizeBytes: payload.fileSizeBytes || 2500000,
      width: payload.width || 3840,
      height: payload.height || 2160,
      caption: payload.caption || 'Captured travel memory',
      latitude: payload.latitude || 15.5551,
      longitude: payload.longitude || 73.7512,
      locationName: payload.locationName || 'Goa, India',
      takenAt: payload.takenAt || new Date().toISOString(),
      uploadedAt: new Date().toISOString(),
      itineraryActivityId: payload.itineraryActivityId,
      placeId: payload.placeId,
      tripDay: payload.tripDay || 1,
      isFavorite: payload.isFavorite || false,
      albumIds: payload.albumIds || [],
    };

    this.mockPhotos.push(newPhoto);
    return newPhoto;
  }

  async toggleFavorite(photoId: string): Promise<TripPhotoDto> {
    const photo = await this.getPhotoById(photoId);
    photo.isFavorite = !photo.isFavorite;
    return photo;
  }

  async deletePhoto(photoId: string): Promise<{ success: boolean }> {
    const initialLen = this.mockPhotos.length;
    this.mockPhotos = this.mockPhotos.filter((p) => p.id !== photoId);
    return { success: this.mockPhotos.length < initialLen };
  }
}
