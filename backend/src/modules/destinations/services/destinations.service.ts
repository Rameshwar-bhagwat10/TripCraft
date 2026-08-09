import { Injectable, NotFoundException } from "@nestjs/common";
import { PrismaService } from "../../../database/prisma/prisma.service";
import { UserContext } from "../../auth/decorators/user.decorator";
import { SearchDestinationDto } from "../dto/search-destination.dto";

const INITIAL_DESTINATIONS_SEED = [
  {
    id: "dest-goa",
    name: "Goa",
    slug: "goa-india",
    city: "Goa",
    country: "India",
    region: "South Asia",
    description:
      "A relaxed coastal paradise famous for its golden beaches, seafood, palm trees, Portuguese heritage, and vibrant nightlife.",
    heroImage:
      "https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=1200",
    images: [
      "https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800",
      "https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800",
      "https://images.unsplash.com/photo-1587922546307-776227941871?w=800",
    ],
    categories: ["Beach", "Relaxation", "Food", "Nightlife"],
    travelStyles: ["Relaxation", "Nature", "Culinary"],
    activities: [
      "Scuba Diving",
      "Beach Hopping",
      "Portuguese Fort Visit",
      "Seafood Cruise",
    ],
    highlights: [
      "Baga & Palolem Beaches",
      "Fontainhas Latin Quarter",
      "Dudhsagar Waterfalls",
      "Spicy Goan Fish Curry",
    ],
    bestTimeToVisit: "October — March",
    budgetRange: "Moderate",
    latitude: 15.2993,
    longitude: 74.124,
    rating: 4.8,
    reviewCount: 340,
    isFeatured: true,
    isTrending: true,
  },
  {
    id: "dest-munnar",
    name: "Munnar Tea Hills",
    slug: "munnar-kerala-india",
    city: "Munnar",
    country: "India",
    region: "South Asia",
    description:
      "Rolling green tea plantations, misty hilltops, cool mountain breeze, and rare wildlife in God’s Own Country.",
    heroImage:
      "https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=1200",
    images: [
      "https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=800",
      "https://images.unsplash.com/photo-1593693397690-362cb9666fc2?w=800",
    ],
    categories: ["Mountains", "Nature", "Adventure"],
    travelStyles: ["Nature", "Adventure", "Wellness"],
    activities: [
      "Tea Garden Walking",
      "Anamudi Peak Trekking",
      "Spice Plantation Tour",
      "Waterfall Trail",
    ],
    highlights: [
      "Tea Museum",
      "Eravikulam National Park",
      "Mattupetty Dam",
      "Echo Point",
    ],
    bestTimeToVisit: "September — May",
    budgetRange: "Budget",
    latitude: 10.0889,
    longitude: 77.0595,
    rating: 4.9,
    reviewCount: 215,
    isFeatured: true,
    isTrending: false,
  },
  {
    id: "dest-dubai",
    name: "Dubai",
    slug: "dubai-uae",
    city: "Dubai",
    country: "United Arab Emirates",
    region: "Middle East",
    description:
      "Futuristic architecture, ultra-luxury shopping, desert safaris, and world-class culinary experiences.",
    heroImage:
      "https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=1200",
    images: [
      "https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=800",
      "https://images.unsplash.com/photo-1580674684081-7617fbf3d745?w=800",
    ],
    categories: ["Luxury", "Culture", "Food"],
    travelStyles: ["Luxury", "Shopping", "Culinary"],
    activities: [
      "Burj Khalifa View",
      "Desert Dune Bashing",
      "Dubai Mall Tour",
      "Marina Sunset Cruise",
    ],
    highlights: [
      "Burj Khalifa",
      "Museum of the Future",
      "Palm Jumeirah",
      "Gold Souk",
    ],
    bestTimeToVisit: "November — March",
    budgetRange: "Luxury",
    latitude: 25.2048,
    longitude: 55.2708,
    rating: 4.7,
    reviewCount: 512,
    isFeatured: false,
    isTrending: true,
  },
  {
    id: "dest-manali",
    name: "Manali",
    slug: "manali-india",
    city: "Manali",
    country: "India",
    region: "South Asia",
    description:
      "Snow-capped Himalayan peaks, pine forests, adventure sports, and scenic mountain valleys.",
    heroImage:
      "https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?w=1200",
    images: [
      "https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?w=800",
    ],
    categories: ["Mountains", "Adventure", "Nature"],
    travelStyles: ["Adventure", "Nature", "Backpacking"],
    activities: [
      "Solang Valley Paragliding",
      "Atal Tunnel Drive",
      "Old Manali Cafe Crawl",
      "Rohtang Pass Snow Tour",
    ],
    highlights: [
      "Solang Valley",
      "Hadimba Temple",
      "Jogini Waterfalls",
      "Mall Road",
    ],
    bestTimeToVisit: "October — June",
    budgetRange: "Moderate",
    latitude: 32.2432,
    longitude: 77.1892,
    rating: 4.8,
    reviewCount: 289,
    isFeatured: false,
    isTrending: true,
  },
  {
    id: "dest-kyoto",
    name: "Kyoto",
    slug: "kyoto-japan",
    city: "Kyoto",
    country: "Japan",
    region: "East Asia",
    description:
      "Classical Buddhist temples, traditional wooden houses, bamboo groves, and serene tea ceremonies.",
    heroImage:
      "https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=1200",
    images: [
      "https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=800",
    ],
    categories: ["Culture", "Nature", "Food"],
    travelStyles: ["Culture", "History", "Nature"],
    activities: [
      "Fushimi Inari Shrine Walk",
      "Arashiyama Bamboo Forest",
      "Gion Geisha District Tour",
    ],
    highlights: [
      "Kinkaku-ji (Golden Pavilion)",
      "Fushimi Inari Taisha",
      "Bamboo Grove",
      "Kiyomizu-dera",
    ],
    bestTimeToVisit: "March — May & October — November",
    budgetRange: "Premium",
    latitude: 35.0116,
    longitude: 135.7681,
    rating: 4.9,
    reviewCount: 430,
    isFeatured: true,
    isTrending: false,
  },
  {
    id: "dest-amalfi",
    name: "Amalfi Coast",
    slug: "amalfi-coast-italy",
    city: "Positano",
    country: "Italy",
    region: "Europe",
    description:
      "Dramatic cliffside villages, turquoise Mediterranean waters, lemon groves, and classic Italian gastronomy.",
    heroImage:
      "https://images.unsplash.com/photo-1533105079780-92b9be482077?w=1200",
    images: [
      "https://images.unsplash.com/photo-1533105079780-92b9be482077?w=800",
    ],
    categories: ["Beach", "Luxury", "Culture", "Food"],
    travelStyles: ["Luxury", "Romantic", "Culinary"],
    activities: [
      "Path of the Gods Hike",
      "Positano Cliff Walk",
      "Capri Island Boat Tour",
    ],
    highlights: [
      "Positano Cliff Village",
      "Ravello Gardens",
      "Amalfi Cathedral",
      "Limoncello Tasting",
    ],
    bestTimeToVisit: "May — September",
    budgetRange: "Luxury",
    latitude: 40.634,
    longitude: 14.6027,
    rating: 4.9,
    reviewCount: 388,
    isFeatured: true,
    isTrending: true,
  },
];

@Injectable()
export class DestinationsService {
  constructor(private readonly prisma: PrismaService) {}

  private transformWithSaveStatus(dest: any, savedDestIds: Set<string>) {
    return {
      ...dest,
      isSaved: savedDestIds.has(dest.id),
    };
  }

  private async getSavedDestinationIds(userId?: string): Promise<Set<string>> {
    if (!userId) return new Set();
    const saved = await this.prisma.savedDestination.findMany({
      where: { userId },
      select: { destinationId: true },
    });
    return new Set(saved.map((s) => s.destinationId));
  }

  async getDestinations(query: SearchDestinationDto, userCtx?: UserContext) {
    const savedIds = await this.getSavedDestinationIds(userCtx?.id);
    let items = [...INITIAL_DESTINATIONS_SEED];

    if (query.search && query.search.trim() !== "") {
      const s = query.search.trim().toLowerCase();
      items = items.filter(
        (d) =>
          d.name.toLowerCase().includes(s) ||
          d.city.toLowerCase().includes(s) ||
          d.country.toLowerCase().includes(s) ||
          d.region.toLowerCase().includes(s) ||
          d.categories.some((c) => c.toLowerCase().includes(s)),
      );
    }

    if (query.category) {
      items = items.filter((d) =>
        d.categories.some(
          (c) => c.toLowerCase() === query.category?.toLowerCase(),
        ),
      );
    }

    if (query.budget) {
      items = items.filter(
        (d) => d.budgetRange.toLowerCase() === query.budget?.toLowerCase(),
      );
    }

    if (query.travelStyle) {
      items = items.filter((d) =>
        d.travelStyles.some(
          (ts) => ts.toLowerCase() === query.travelStyle?.toLowerCase(),
        ),
      );
    }

    if (query.sort === "Alphabetical") {
      items.sort((a, b) => a.name.localeCompare(b.name));
    } else if (query.sort === "Popular") {
      items.sort((a, b) => b.reviewCount - a.reviewCount);
    } else if (query.sort === "Trending") {
      items = items.filter((d) => d.isTrending);
    }

    const page = query.page ?? 1;
    const limit = query.limit ?? 20;
    const startIndex = (page - 1) * limit;
    const paginatedItems = items.slice(startIndex, startIndex + limit);

    return {
      items: paginatedItems.map((d) =>
        this.transformWithSaveStatus(d, savedIds),
      ),
      total: items.length,
      page,
      limit,
    };
  }

  async getFeaturedDestinations(userCtx?: UserContext) {
    const savedIds = await this.getSavedDestinationIds(userCtx?.id);
    const featured = INITIAL_DESTINATIONS_SEED.filter((d) => d.isFeatured);
    return featured.map((d) => this.transformWithSaveStatus(d, savedIds));
  }

  async getRecommendedDestinations(userCtx?: UserContext) {
    const savedIds = await this.getSavedDestinationIds(userCtx?.id);
    let userStyles: string[] = ["Relaxation", "Nature"];

    if (userCtx?.id) {
      const profile = await this.prisma.user.findUnique({
        where: { id: userCtx.id },
        include: { preferences: true },
      });
      if (profile?.preferences?.travelStyles?.length) {
        userStyles = profile.preferences.travelStyles;
      }
    }

    const recommended = INITIAL_DESTINATIONS_SEED.filter((d) =>
      d.travelStyles.some((ts) => userStyles.includes(ts)),
    );

    const result =
      recommended.length > 0
        ? recommended
        : INITIAL_DESTINATIONS_SEED.slice(0, 4);
    return result.map((d) => this.transformWithSaveStatus(d, savedIds));
  }

  async getTrendingDestinations(userCtx?: UserContext) {
    const savedIds = await this.getSavedDestinationIds(userCtx?.id);
    const trending = INITIAL_DESTINATIONS_SEED.filter((d) => d.isTrending);
    return trending.map((d) => this.transformWithSaveStatus(d, savedIds));
  }

  async getDestinationById(id: string, userCtx?: UserContext) {
    const dest = INITIAL_DESTINATIONS_SEED.find(
      (d) => d.id === id || d.slug === id,
    );
    if (!dest) {
      throw new NotFoundException(`Destination with ID/slug "${id}" not found`);
    }

    const savedIds = await this.getSavedDestinationIds(userCtx?.id);
    return this.transformWithSaveStatus(dest, savedIds);
  }

  async saveDestination(id: string, userCtx: UserContext) {
    const dest = INITIAL_DESTINATIONS_SEED.find(
      (d) => d.id === id || d.slug === id,
    );
    if (!dest) {
      throw new NotFoundException(`Destination "${id}" not found`);
    }

    try {
      await this.prisma.savedDestination.create({
        data: {
          userId: userCtx.id,
          destinationId: dest.id,
        },
      });
    } catch (_) {
      // Ignore if already saved
    }

    return { saved: true, destinationId: dest.id };
  }

  async unsaveDestination(id: string, userCtx: UserContext) {
    const dest = INITIAL_DESTINATIONS_SEED.find(
      (d) => d.id === id || d.slug === id,
    );
    if (!dest) {
      throw new NotFoundException(`Destination "${id}" not found`);
    }

    try {
      await this.prisma.savedDestination.deleteMany({
        where: {
          userId: userCtx.id,
          destinationId: dest.id,
        },
      });
    } catch (_) {
      // Ignore if not previously saved
    }

    return { saved: false, destinationId: dest.id };
  }

  async getSavedDestinations(userCtx: UserContext) {
    const saved = await this.prisma.savedDestination.findMany({
      where: { userId: userCtx.id },
      select: { destinationId: true },
    });

    const savedIds = new Set(saved.map((s) => s.destinationId));
    const savedDestinations = INITIAL_DESTINATIONS_SEED.filter((d) =>
      savedIds.has(d.id),
    );

    return savedDestinations.map((d) =>
      this.transformWithSaveStatus(d, savedIds),
    );
  }
}
