import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Param,
  Body,
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
import { CreateItineraryItemDto } from "../dto/create-itinerary-item.dto";
import { UpdateItineraryItemDto } from "../dto/update-itinerary-item.dto";
import { ReorderItineraryItemsDto } from "../dto/reorder-itinerary-items.dto";
import { MoveItineraryItemDto } from "../dto/move-itinerary-item.dto";
import { UpdateTripDayDto } from "../dto/update-trip-day.dto";
import { ItineraryService } from "../services/itinerary.service";

@ApiTags("itinerary")
@Controller("trips/:tripId")
@UseGuards(SupabaseAuthGuard)
@ApiBearerAuth()
export class ItineraryController {
  constructor(private readonly itineraryService: ItineraryService) {}

  @Get("itinerary")
  @ApiOperation({
    summary: "Get full trip itinerary with days and activity items",
  })
  async getItinerary(
    @Param("tripId") tripId: string,
    @CurrentUser() user: UserContext,
  ) {
    return this.itineraryService.getItinerary(tripId, user);
  }

  @Post("days/:dayId/items")
  @ApiOperation({ summary: "Create a new itinerary activity item" })
  async createItineraryItem(
    @Param("tripId") tripId: string,
    @Param("dayId") dayId: string,
    @Body() dto: CreateItineraryItemDto,
    @CurrentUser() user: UserContext,
  ) {
    return this.itineraryService.createItineraryItem(tripId, dayId, dto, user);
  }

  @Patch("items/:itemId")
  @ApiOperation({ summary: "Update an itinerary activity item" })
  async updateItineraryItem(
    @Param("tripId") tripId: string,
    @Param("itemId") itemId: string,
    @Body() dto: UpdateItineraryItemDto,
    @CurrentUser() user: UserContext,
  ) {
    return this.itineraryService.updateItineraryItem(tripId, itemId, dto, user);
  }

  @Delete("items/:itemId")
  @ApiOperation({ summary: "Delete an itinerary activity item" })
  async deleteItineraryItem(
    @Param("tripId") tripId: string,
    @Param("itemId") itemId: string,
    @CurrentUser() user: UserContext,
  ) {
    return this.itineraryService.deleteItineraryItem(tripId, itemId, user);
  }

  @Patch("items/reorder")
  @ApiOperation({ summary: "Batch reorder itinerary activity items" })
  async reorderItineraryItems(
    @Param("tripId") tripId: string,
    @Body() dto: ReorderItineraryItemsDto,
    @CurrentUser() user: UserContext,
  ) {
    return this.itineraryService.reorderItineraryItems(tripId, dto, user);
  }

  @Patch("items/:itemId/move")
  @ApiOperation({ summary: "Move itinerary activity item to another day" })
  async moveItineraryItem(
    @Param("tripId") tripId: string,
    @Param("itemId") itemId: string,
    @Body() dto: MoveItineraryItemDto,
    @CurrentUser() user: UserContext,
  ) {
    return this.itineraryService.moveItineraryItem(tripId, itemId, dto, user);
  }

  @Patch("days/:dayId")
  @ApiOperation({ summary: "Update trip day title or notes" })
  async updateTripDay(
    @Param("tripId") tripId: string,
    @Param("dayId") dayId: string,
    @Body() dto: UpdateTripDayDto,
    @CurrentUser() user: UserContext,
  ) {
    return this.itineraryService.updateTripDay(tripId, dayId, dto, user);
  }
}
