import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from "@nestjs/common";
import { PrismaService } from "../../../database/prisma/prisma.service";
import { UserContext } from "../../auth/decorators/user.decorator";
import { CreateItineraryItemDto } from "../dto/create-itinerary-item.dto";
import { UpdateItineraryItemDto } from "../dto/update-itinerary-item.dto";
import { ReorderItineraryItemsDto } from "../dto/reorder-itinerary-items.dto";
import { MoveItineraryItemDto } from "../dto/move-itinerary-item.dto";
import { UpdateTripDayDto } from "../dto/update-trip-day.dto";

const INITIAL_DAY_1_ITEMS = [
  {
    id: "item-1",
    tripDayId: "day-1",
    placeId: "place-breakfast",
    title: "Breakfast at Cafe Bodega",
    description: "Fresh pastries and south Indian filter coffee",
    type: "food",
    startTime: "09:00",
    endTime: "10:00",
    duration: "1h",
    orderIndex: 0,
    notes: "Try the avocado sourdough toast",
    imageUrl:
      "https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=800",
    isAllDay: false,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  },
  {
    id: "item-2",
    tripDayId: "day-1",
    placeId: "place-fort",
    title: "Explore Fort Aguada",
    description: "17th-century Portuguese lighthouse and fort",
    type: "sightseeing",
    startTime: "10:30",
    endTime: "12:30",
    duration: "2h",
    orderIndex: 1,
    notes: "Great views over the Arabian Sea",
    imageUrl:
      "https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800",
    isAllDay: false,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  },
  {
    id: "item-3",
    tripDayId: "day-1",
    placeId: "place-lunch",
    title: "Seafood Lunch at Brittos",
    description: "Famous beach shack in Baga",
    type: "food",
    startTime: "13:00",
    endTime: "14:30",
    duration: "1h 30m",
    orderIndex: 2,
    notes: "Goan fish curry recommendation",
    imageUrl: "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800",
    isAllDay: false,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  },
];

@Injectable()
export class ItineraryService {
  private inMemoryDays: any[] = [];
  private inMemoryItems: any[] = [...INITIAL_DAY_1_ITEMS];

  constructor(private readonly prisma: PrismaService) {}

  private ensureDaysForTrip(tripId: string) {
    const existingDays = this.inMemoryDays.filter((d) => d.tripId === tripId);
    if (existingDays.length > 0) return existingDays;

    // Generate 5 days for trip-goa-escape by default
    const startDate = new Date();
    startDate.setDate(startDate.getDate() + 7);

    const generated: any[] = [];
    for (let i = 1; i <= 5; i++) {
      const currentDate = new Date(startDate);
      currentDate.setDate(startDate.getDate() + (i - 1));
      const day = {
        id: `day-${i}`,
        tripId,
        date: currentDate.toISOString(),
        dayNumber: i,
        title:
          i === 1
            ? "Old Goa & Heritage"
            : i === 2
              ? "Beach & Watersports"
              : `Day ${i}`,
        notes: i === 1 ? "Carry sunscreen and water" : null,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
      };
      generated.push(day);
      this.inMemoryDays.push(day);
    }
    return generated;
  }

  async getItinerary(tripId: string, userCtx: UserContext) {
    const days = this.ensureDaysForTrip(tripId);

    const resultDays = days.map((day) => {
      const items = this.inMemoryItems
        .filter((item) => item.tripDayId === day.id)
        .sort((a, b) => a.orderIndex - b.orderIndex);
      return {
        ...day,
        items,
      };
    });

    return {
      tripId,
      days: resultDays,
    };
  }

  async createItineraryItem(
    tripId: string,
    dayId: string,
    dto: CreateItineraryItemDto,
    userCtx: UserContext,
  ) {
    const days = this.ensureDaysForTrip(tripId);
    const day = days.find((d) => d.id === dayId);
    if (!day) {
      throw new NotFoundException(`Trip day with ID "${dayId}" not found`);
    }

    const dayItems = this.inMemoryItems.filter((i) => i.tripDayId === dayId);
    const orderIndex = dto.orderIndex ?? dayItems.length;

    const newItem = {
      id: `item-${Date.now()}`,
      tripDayId: dayId,
      placeId: dto.placeId,
      title: dto.title,
      description: dto.description ?? "",
      type: dto.type ?? "sightseeing",
      startTime: dto.startTime ?? "10:00",
      endTime: dto.endTime ?? "11:30",
      duration: dto.duration ?? "1h 30m",
      orderIndex,
      notes: dto.notes ?? "",
      imageUrl:
        dto.imageUrl ??
        "https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800",
      isAllDay: dto.isAllDay ?? false,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };

    this.inMemoryItems.push(newItem);
    return newItem;
  }

  async updateItineraryItem(
    tripId: string,
    itemId: string,
    dto: UpdateItineraryItemDto,
    userCtx: UserContext,
  ) {
    const index = this.inMemoryItems.findIndex((i) => i.id === itemId);
    if (index === -1) {
      throw new NotFoundException(
        `Itinerary item with ID "${itemId}" not found`,
      );
    }

    const existing = this.inMemoryItems[index];
    const updated = {
      ...existing,
      ...dto,
      updatedAt: new Date().toISOString(),
    };

    this.inMemoryItems[index] = updated;
    return updated;
  }

  async deleteItineraryItem(
    tripId: string,
    itemId: string,
    userCtx: UserContext,
  ) {
    const index = this.inMemoryItems.findIndex((i) => i.id === itemId);
    if (index === -1) {
      throw new NotFoundException(
        `Itinerary item with ID "${itemId}" not found`,
      );
    }
    this.inMemoryItems.splice(index, 1);
    return { success: true, id: itemId };
  }

  async reorderItineraryItems(
    tripId: string,
    dto: ReorderItineraryItemsDto,
    userCtx: UserContext,
  ) {
    for (const payloadItem of dto.items) {
      const idx = this.inMemoryItems.findIndex((i) => i.id === payloadItem.id);
      if (idx !== -1) {
        this.inMemoryItems[idx].orderIndex = payloadItem.orderIndex;
      }
    }
    return { success: true, dayId: dto.dayId };
  }

  async moveItineraryItem(
    tripId: string,
    itemId: string,
    dto: MoveItineraryItemDto,
    userCtx: UserContext,
  ) {
    const idx = this.inMemoryItems.findIndex((i) => i.id === itemId);
    if (idx === -1) {
      throw new NotFoundException(
        `Itinerary item with ID "${itemId}" not found`,
      );
    }

    this.inMemoryItems[idx].tripDayId = dto.targetDayId;
    this.inMemoryItems[idx].orderIndex = dto.newOrderIndex;
    this.inMemoryItems[idx].updatedAt = new Date().toISOString();

    return this.inMemoryItems[idx];
  }

  async updateTripDay(
    tripId: string,
    dayId: string,
    dto: UpdateTripDayDto,
    userCtx: UserContext,
  ) {
    const days = this.ensureDaysForTrip(tripId);
    const dayIdx = days.findIndex((d) => d.id === dayId);
    if (dayIdx === -1) {
      throw new NotFoundException(`Trip day with ID "${dayId}" not found`);
    }

    const updated = {
      ...days[dayIdx],
      title: dto.title ?? days[dayIdx].title,
      notes: dto.notes ?? days[dayIdx].notes,
      updatedAt: new Date().toISOString(),
    };

    const globalIdx = this.inMemoryDays.findIndex((d) => d.id === dayId);
    if (globalIdx !== -1) {
      this.inMemoryDays[globalIdx] = updated;
    }

    return updated;
  }
}
