import { Injectable, Logger } from '@nestjs/common';
import { PhotosService, TripPhotoDto } from './photos.service';

export interface MemoryTimelineDayDto {
  dayNumber: number;
  dateTitle: string;
  locationTitle: string;
  photos: TripPhotoDto[];
}

export interface MemorySummaryDto {
  tripId: string;
  totalPhotosCount: number;
  totalAlbumsCount: number;
  totalPlacesPhotographed: number;
  favoritePhotosCount: number;
  mostPhotographedPlace: string;
  mostActiveDayNumber: number;
}

@Injectable()
export class MemoriesTimelineService {
  private readonly logger = new Logger(MemoriesTimelineService.name);

  constructor(private readonly photosService: PhotosService) {}

  async getTimelineByTrip(tripId: string): Promise<MemoryTimelineDayDto[]> {
    const photos = await this.photosService.getPhotosByTrip(tripId);

    const day1Photos = photos.filter((p) => p.tripDay === 1);
    const day2Photos = photos.filter((p) => p.tripDay === 2);

    return [
      {
        dayNumber: 1,
        dateTitle: 'Aug 21, 2026',
        locationTitle: 'Baga Beach & Sunset Coast',
        photos: day1Photos,
      },
      {
        dayNumber: 2,
        dateTitle: 'Aug 22, 2026',
        locationTitle: 'Fort Aguada & Vagator',
        photos: day2Photos,
      },
    ];
  }

  async getSummaryByTrip(tripId: string): Promise<MemorySummaryDto> {
    const photos = await this.photosService.getPhotosByTrip(tripId);
    const favoritesCount = photos.filter((p) => p.isFavorite).length;

    return {
      tripId,
      totalPhotosCount: photos.length,
      totalAlbumsCount: 2,
      totalPlacesPhotographed: 3,
      favoritePhotosCount: favoritesCount,
      mostPhotographedPlace: 'Baga Beach',
      mostActiveDayNumber: 2,
    };
  }
}
