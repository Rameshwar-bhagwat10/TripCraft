import { Module } from "@nestjs/common";
import { RouteIntelligenceController } from "./controllers/route-intelligence.controller";
import { RouteIntelligenceService } from "./services/route-intelligence.service";

@Module({
  controllers: [RouteIntelligenceController],
  providers: [RouteIntelligenceService],
  exports: [RouteIntelligenceService],
})
export class RouteIntelligenceModule {}
