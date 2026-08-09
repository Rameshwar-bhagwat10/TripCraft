import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Param,
  Body,
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
import { CreateTripDto } from "../dto/create-trip.dto";
import { UpdateTripDto } from "../dto/update-trip.dto";
import { TripQueryDto } from "../dto/trip-query.dto";
import { TripsService } from "../services/trips.service";

@ApiTags("trips")
@Controller("trips")
@UseGuards(SupabaseAuthGuard)
@ApiBearerAuth()
export class TripsController {
  constructor(private readonly tripsService: TripsService) {}

  @Post()
  @ApiOperation({ summary: "Create a new trip" })
  @ApiResponse({ status: 201, description: "Trip created successfully" })
  async createTrip(
    @Body() dto: CreateTripDto,
    @CurrentUser() user: UserContext,
  ) {
    return this.tripsService.createTrip(dto, user);
  }

  @Get()
  @ApiOperation({ summary: "List user trips with status filtering" })
  async getTrips(
    @Query() query: TripQueryDto,
    @CurrentUser() user: UserContext,
  ) {
    return this.tripsService.getTrips(query, user);
  }

  @Get(":id")
  @ApiOperation({ summary: "Get trip workspace details by ID" })
  async getTripById(@Param("id") id: string, @CurrentUser() user: UserContext) {
    return this.tripsService.getTripById(id, user);
  }

  @Patch(":id")
  @ApiOperation({ summary: "Update trip details" })
  async updateTrip(
    @Param("id") id: string,
    @Body() dto: UpdateTripDto,
    @CurrentUser() user: UserContext,
  ) {
    return this.tripsService.updateTrip(id, dto, user);
  }

  @Post(":id/archive")
  @ApiOperation({ summary: "Archive a trip" })
  async archiveTrip(@Param("id") id: string, @CurrentUser() user: UserContext) {
    return this.tripsService.archiveTrip(id, user);
  }

  @Post(":id/restore")
  @ApiOperation({ summary: "Restore an archived trip" })
  async restoreTrip(@Param("id") id: string, @CurrentUser() user: UserContext) {
    return this.tripsService.restoreTrip(id, user);
  }

  @Delete(":id")
  @ApiOperation({ summary: "Delete a trip" })
  async deleteTrip(@Param("id") id: string, @CurrentUser() user: UserContext) {
    return this.tripsService.deleteTrip(id, user);
  }
}
