import { Controller, Get, Post, Param, Query, UseGuards } from "@nestjs/common";
import { ApiBearerAuth, ApiOperation, ApiTags } from "@nestjs/swagger";
import { SupabaseAuthGuard } from "../../auth/guards/supabase_auth.guard";
import { SearchPlacesDto } from "../dto/search-places.dto";
import { PlacesService } from "../services/places.service";

@ApiTags("places")
@Controller("places")
@UseGuards(SupabaseAuthGuard)
@ApiBearerAuth()
export class PlacesController {
  constructor(private readonly placesService: PlacesService) {}

  @Get("search")
  @ApiOperation({ summary: "Search and discover places by query and category" })
  async searchPlaces(@Query() dto: SearchPlacesDto) {
    return this.placesService.searchPlaces(dto);
  }

  @Get(":id")
  @ApiOperation({ summary: "Get place details" })
  async getPlaceDetails(@Param("id") id: string) {
    return this.placesService.getPlaceDetails(id);
  }

  @Post(":id/save")
  @ApiOperation({ summary: "Toggle save place to favorites" })
  async toggleSavePlace(@Param("id") id: string) {
    return this.placesService.toggleSavePlace(id);
  }
}
