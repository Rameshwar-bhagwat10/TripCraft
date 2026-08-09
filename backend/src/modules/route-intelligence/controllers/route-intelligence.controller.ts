import { Controller, Post, Param, Body, UseGuards } from "@nestjs/common";
import { ApiBearerAuth, ApiOperation, ApiTags } from "@nestjs/swagger";
import { SupabaseAuthGuard } from "../../auth/guards/supabase_auth.guard";
import { AnalyzeRouteDto } from "../dto/analyze-route.dto";
import { OptimizeRouteDto } from "../dto/optimize-route.dto";
import { RouteIntelligenceService } from "../services/route-intelligence.service";

@ApiTags("route-intelligence")
@Controller("trips/:tripId/days/:dayId")
@UseGuards(SupabaseAuthGuard)
@ApiBearerAuth()
export class RouteIntelligenceController {
  constructor(
    private readonly routeIntelligenceService: RouteIntelligenceService,
  ) {}

  @Post("route-analysis")
  @ApiOperation({
    summary:
      "Analyze itinerary day route for travel burden, backtracking & schedule conflicts",
  })
  async analyzeRoute(
    @Param("tripId") tripId: string,
    @Param("dayId") dayId: string,
    @Body() dto: AnalyzeRouteDto,
  ) {
    return this.routeIntelligenceService.analyzeRoute(tripId, dayId, dto);
  }

  @Post("route-optimization")
  @ApiOperation({
    summary: "Calculate 2-Opt sequence optimization preview and time savings",
  })
  async optimizeRoute(
    @Param("tripId") tripId: string,
    @Param("dayId") dayId: string,
    @Body() dto: OptimizeRouteDto,
  ) {
    return this.routeIntelligenceService.optimizeRoute(tripId, dayId, dto);
  }
}
