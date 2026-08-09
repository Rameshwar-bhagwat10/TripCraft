import {
  Controller,
  Get,
  Post,
  Delete,
  Param,
  Query,
  UseGuards,
} from "@nestjs/common";
import {
  ApiBearerAuth,
  ApiOperation,
  ApiResponse,
  ApiTags,
} from "@nestjs/swagger";
import { CurrentUser, UserContext } from "../../auth/decorators/user.decorator";
import { SupabaseAuthGuard } from "../../auth/guards/supabase_auth.guard";
import { SearchDestinationDto } from "../dto/search-destination.dto";
import { DestinationsService } from "../services/destinations.service";

@ApiTags("destinations")
@Controller("destinations")
@UseGuards(SupabaseAuthGuard)
@ApiBearerAuth()
export class DestinationsController {
  constructor(private readonly destinationsService: DestinationsService) {}

  @Get()
  @ApiOperation({ summary: "Search & filter destinations" })
  @ApiResponse({
    status: 200,
    description: "Destinations retrieved successfully",
  })
  async getDestinations(
    @Query() query: SearchDestinationDto,
    @CurrentUser() user: UserContext,
  ) {
    return this.destinationsService.getDestinations(query, user);
  }

  @Get("featured")
  @ApiOperation({ summary: "Get featured editorial destinations" })
  async getFeaturedDestinations(@CurrentUser() user: UserContext) {
    return this.destinationsService.getFeaturedDestinations(user);
  }

  @Get("recommended")
  @ApiOperation({ summary: "Get personalized destination recommendations" })
  async getRecommendedDestinations(@CurrentUser() user: UserContext) {
    return this.destinationsService.getRecommendedDestinations(user);
  }

  @Get("trending")
  @ApiOperation({ summary: "Get trending destinations" })
  async getTrendingDestinations(@CurrentUser() user: UserContext) {
    return this.destinationsService.getTrendingDestinations(user);
  }

  @Get("saved")
  @ApiOperation({ summary: "Get user saved destinations" })
  async getSavedDestinations(@CurrentUser() user: UserContext) {
    return this.destinationsService.getSavedDestinations(user);
  }

  @Get(":id")
  @ApiOperation({ summary: "Get destination details by ID or slug" })
  async getDestinationById(
    @Param("id") id: string,
    @CurrentUser() user: UserContext,
  ) {
    return this.destinationsService.getDestinationById(id, user);
  }

  @Post(":id/save")
  @ApiOperation({ summary: "Bookmark / save destination to user collection" })
  async saveDestination(
    @Param("id") id: string,
    @CurrentUser() user: UserContext,
  ) {
    return this.destinationsService.saveDestination(id, user);
  }

  @Delete(":id/save")
  @ApiOperation({ summary: "Remove destination from user saved collection" })
  async unsaveDestination(
    @Param("id") id: string,
    @CurrentUser() user: UserContext,
  ) {
    return this.destinationsService.unsaveDestination(id, user);
  }
}
