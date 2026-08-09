import { Controller, Get, Query, UseGuards } from "@nestjs/common";
import { ApiBearerAuth, ApiOperation, ApiTags } from "@nestjs/swagger";
import { SupabaseAuthGuard } from "../../auth/guards/supabase_auth.guard";
import { MapsService } from "../services/maps.service";

@ApiTags("maps")
@Controller("maps")
@UseGuards(SupabaseAuthGuard)
@ApiBearerAuth()
export class MapsController {
  constructor(private readonly mapsService: MapsService) {}

  @Get("config")
  @ApiOperation({ summary: "Get map provider configuration" })
  async getMapConfig() {
    return this.mapsService.getMapConfig();
  }

  @Get("geocode")
  @ApiOperation({ summary: "Geocode address text to coordinates" })
  async geocode(@Query("q") query: string) {
    return this.mapsService.geocode(query);
  }

  @Get("reverse-geocode")
  @ApiOperation({ summary: "Reverse geocode coordinates to address" })
  async reverseGeocode(@Query("lat") lat: string, @Query("lng") lng: string) {
    return this.mapsService.reverseGeocode(parseFloat(lat), parseFloat(lng));
  }
}
