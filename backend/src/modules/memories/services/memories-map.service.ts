import { Injectable, Logger } from '@nestjs/common';
import { PhotosService, TripPhotoDto } from './photos.service';

export interface MemoryMapPointDto {
  id: string;
  locationName: string;
  latitude: number;
  longitude: number;
  photoCount: number;
  coverPhotoUrl: string;
  photos: TripPhotoDto[];
}

@Injectable()
export class MemoriesMapService {
  private readonly logger = new Logger(MemoriesMapService.name);

  constructor(private readonly photosService: PhotosService) {}

  async getMapPointsByTrip(tripId: string): Promise<MemoryMapPointDto[]> {
    const photos = await this.photosService.getPhotosByTrip(tripId);

    const pointsMap: Record<string, TripPhotoDto[]> = {};
    for (const p of photos) {
      const key = p.locationName || 'Unknown Location';
      if (!pointsMap[key]) pointsMap[key] = [];
      pointsMap[key].push(p);
    }

    return Object.entries(pointsMap).map(([locName, locPhotos], idx) => {
      const first = locPhotos[0];
      return {
        id: `map-pt-${idx + 1}`,
        locationName: locName,
        latitude: first.latitude || 15.5551,
        longitude: first.longitude || 73.7512,
        photoCount: locPhotos.length,
        coverPhotoUrl: first.thumbnailPath,
        photos: locPhotos,
      };
    });
  }
}
