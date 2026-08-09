import { Module } from "@nestjs/common";
import { ItineraryController } from "./controllers/itinerary.controller";
import { ItineraryService } from "./services/itinerary.service";

@Module({
  controllers: [ItineraryController],
  providers: [ItineraryService],
  exports: [ItineraryService],
})
export class ItineraryModule {}
