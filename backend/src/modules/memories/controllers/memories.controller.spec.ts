import { Test, TestingModule } from '@nestjs/testing';
import { PhotosController } from './photos.controller';
import { AlbumsController } from './albums.controller';
import { MemoriesController } from './memories.controller';
import { PhotosService } from '../services/photos.service';
import { AlbumsService } from '../services/albums.service';
import { MemoriesTimelineService } from '../services/memories-timeline.service';
import { MemoriesMapService } from '../services/memories-map.service';

describe('MemoriesControllers', () => {
  let photosController: PhotosController;
  let albumsController: AlbumsController;
  let memoriesController: MemoriesController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [PhotosController, AlbumsController, MemoriesController],
      providers: [PhotosService, AlbumsService, MemoriesTimelineService, MemoriesMapService],
    }).compile();

    photosController = module.get<PhotosController>(PhotosController);
    albumsController = module.get<AlbumsController>(AlbumsController);
    memoriesController = module.get<MemoriesController>(MemoriesController);
  });

  it('should be defined', () => {
    expect(photosController).toBeDefined();
    expect(albumsController).toBeDefined();
    expect(memoriesController).toBeDefined();
  });

  it('should return trip photos', async () => {
    const photos = await photosController.getPhotos('trip-goa-escape');
    expect(photos).toBeDefined();
    expect(photos.length).toBeGreaterThan(0);
    expect(photos[0].id).toBeDefined();
  });

  it('should create a photo record', async () => {
    const newPhoto = await photosController.createPhoto('trip-goa-escape', {
      caption: 'Sunset over Anjuna Beach',
      locationName: 'Anjuna Beach',
      tripDay: 3,
    });
    expect(newPhoto).toBeDefined();
    expect(newPhoto.id).toBeDefined();
    expect(newPhoto.caption).toBe('Sunset over Anjuna Beach');
  });

  it('should return trip memory summary', async () => {
    const summary = await memoriesController.getSummary('trip-goa-escape');
    expect(summary).toBeDefined();
    expect(summary.totalPhotosCount).toBeGreaterThan(0);
  });
});
