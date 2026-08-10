import { Controller, Get, Param } from '@nestjs/common';
import { MemoriesTimelineService } from '../services/memories-timeline.service';
import { MemoriesMapService } from '../services/memories-map.service';

@Controller('trips')
export class MemoriesController {
  constructor(
    private readonly timelineService: MemoriesTimelineService,
    private readonly mapService: MemoriesMapService,
  ) {}

  @Get(':tripId/memories/summary')
  async getSummary(@Param('tripId') tripId: string) {
    return this.timelineService.getSummaryByTrip(tripId);
  }

  @Get(':tripId/memories/timeline')
  async getTimeline(@Param('tripId') tripId: string) {
    return this.timelineService.getTimelineByTrip(tripId);
  }

  @Get(':tripId/memories/map')
  async getMapPoints(@Param('tripId') tripId: string) {
    return this.mapService.getMapPointsByTrip(tripId);
  }
}
