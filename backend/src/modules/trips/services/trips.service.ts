import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ForbiddenException,
} from "@nestjs/common";
import { PrismaService } from "../../../database/prisma/prisma.service";
import { UserContext } from "../../auth/decorators/user.decorator";
import { CreateTripDto } from "../dto/create-trip.dto";
import { UpdateTripDto } from "../dto/update-trip.dto";
import { TripQueryDto } from "../dto/trip-query.dto";

const INITIAL_TRIPS_SEED = [
  {
    id: "trip-goa-escape",
    ownerId: "user-123",
    destinationId: "dest-goa",
    title: "Goa Coastal Escape",
    description: "A 5-day relaxation and beach hopping trip along South Goa.",
    coverImage:
      "https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=1200",
    startDate: new Date(Date.now() + 86400000 * 12).toISOString(), // 12 days from now
    endDate: new Date(Date.now() + 86400000 * 17).toISOString(),
    status: "Upcoming",
    travelersCount: 2,
    visibility: "Private",
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
    destination: {
      id: "dest-goa",
      name: "Goa",
      city: "Goa",
      country: "India",
      heroImage:
        "https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=1200",
    },
  },
];

@Injectable()
export class TripsService {
  private inMemoryTrips = [...INITIAL_TRIPS_SEED];

  constructor(private readonly prisma: PrismaService) {}

  private deriveStatusFromDates(
    startDateStr: string,
    endDateStr: string,
    currentStatus?: string,
  ): string {
    if (currentStatus === "Archived" || currentStatus === "Draft") {
      return currentStatus;
    }
    const start = new Date(startDateStr).getTime();
    const end = new Date(endDateStr).getTime();
    const now = Date.now();

    if (start > now) return "Upcoming";
    if (start <= now && now <= end) return "Ongoing";
    return "Completed";
  }

  async createTrip(dto: CreateTripDto, userCtx: UserContext) {
    const start = new Date(dto.startDate);
    const end = new Date(dto.endDate);
    if (start > end) {
      throw new BadRequestException("Start date cannot be after end date");
    }

    const coverImage =
      dto.coverImage ??
      "https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=1200";

    const status = this.deriveStatusFromDates(dto.startDate, dto.endDate);

    const newTrip = {
      id: `trip-${Date.now()}`,
      ownerId: userCtx.id,
      destinationId: dto.destinationId,
      title: dto.title,
      description: dto.description ?? "",
      coverImage,
      startDate: dto.startDate,
      endDate: dto.endDate,
      status,
      travelersCount: dto.travelersCount ?? 1,
      visibility: "Private",
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
      destination: {
        id: dto.destinationId,
        name: dto.title.split(" ")[0] ?? "Destination",
        city: dto.title.split(" ")[0] ?? "City",
        country: "India",
        heroImage: coverImage,
      },
    };

    this.inMemoryTrips.unshift(newTrip);
    return newTrip;
  }

  async getTrips(query: TripQueryDto, userCtx: UserContext) {
    let userTrips = this.inMemoryTrips.filter(
      (t) => t.ownerId === userCtx.id || t.ownerId === "user-123",
    );

    if (query.status) {
      const s = query.status.toLowerCase();
      if (s === "upcoming") {
        userTrips = userTrips.filter(
          (t) => t.status === "Upcoming" || t.status === "Ongoing",
        );
      } else if (s === "past" || s === "completed") {
        userTrips = userTrips.filter((t) => t.status === "Completed");
      } else if (s === "archived") {
        userTrips = userTrips.filter((t) => t.status === "Archived");
      }
    }

    const page = query.page ?? 1;
    const limit = query.limit ?? 20;
    const startIndex = (page - 1) * limit;
    const items = userTrips.slice(startIndex, startIndex + limit);

    return {
      items,
      total: userTrips.length,
      page,
      limit,
    };
  }

  async getTripById(id: string, userCtx: UserContext) {
    const trip = this.inMemoryTrips.find((t) => t.id === id);
    if (!trip) {
      throw new NotFoundException(`Trip with ID "${id}" not found`);
    }
    return trip;
  }

  async updateTrip(id: string, dto: UpdateTripDto, userCtx: UserContext) {
    const index = this.inMemoryTrips.findIndex((t) => t.id === id);
    if (index === -1) {
      throw new NotFoundException(`Trip with ID "${id}" not found`);
    }

    const existing = this.inMemoryTrips[index];
    const startDate = dto.startDate ?? existing.startDate;
    const endDate = dto.endDate ?? existing.endDate;

    if (new Date(startDate) > new Date(endDate)) {
      throw new BadRequestException("Start date cannot be after end date");
    }

    const status =
      dto.status ??
      this.deriveStatusFromDates(startDate, endDate, existing.status);

    const updated = {
      ...existing,
      title: dto.title ?? existing.title,
      description: dto.description ?? existing.description,
      startDate,
      endDate,
      travelersCount: dto.travelersCount ?? existing.travelersCount,
      coverImage: dto.coverImage ?? existing.coverImage,
      status,
      updatedAt: new Date().toISOString(),
    };

    this.inMemoryTrips[index] = updated;
    return updated;
  }

  async archiveTrip(id: string, userCtx: UserContext) {
    return this.updateTrip(id, { status: "Archived" }, userCtx);
  }

  async restoreTrip(id: string, userCtx: UserContext) {
    const existing = await this.getTripById(id, userCtx);
    const restoredStatus = this.deriveStatusFromDates(
      existing.startDate,
      existing.endDate,
    );
    return this.updateTrip(id, { status: restoredStatus }, userCtx);
  }

  async deleteTrip(id: string, userCtx: UserContext) {
    const index = this.inMemoryTrips.findIndex((t) => t.id === id);
    if (index === -1) {
      throw new NotFoundException(`Trip with ID "${id}" not found`);
    }
    this.inMemoryTrips.splice(index, 1);
    return { success: true, id };
  }
}
