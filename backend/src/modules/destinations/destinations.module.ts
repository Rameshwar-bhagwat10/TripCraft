import { Module } from "@nestjs/common";
import { DestinationsController } from "./controllers/destinations.controller";
import { DestinationsService } from "./services/destinations.service";

@Module({
  controllers: [DestinationsController],
  providers: [DestinationsService],
  exports: [DestinationsService],
})
export class DestinationsModule {}
