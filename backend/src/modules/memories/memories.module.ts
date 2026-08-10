import { Module } from '@nestjs/common';
import { PhotosController } from './controllers/photos.controller';
import { AlbumsController } from './controllers/albums.controller';
import { MemoriesController } from './controllers/memories.controller';
import { PhotosService } from './services/photos.service';
import { AlbumsService } from './services/albums.service';
import { MemoriesTimelineService } from './services/memories-timeline.service';
import { MemoriesMapService } from './services/memories-map.service';

@Module({
  controllers: [PhotosController, AlbumsController, MemoriesController],
  providers: [PhotosService, AlbumsService, MemoriesTimelineService, MemoriesMapService],
  exports: [PhotosService, AlbumsService, MemoriesTimelineService, MemoriesMapService],
})
export class MemoriesModule {}
