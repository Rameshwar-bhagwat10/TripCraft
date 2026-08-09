import { Injectable, NotFoundException } from "@nestjs/common";
import { SearchPlacesDto } from "../dto/search-places.dto";

const MOCK_PLACES = [
  {
    id: "place-fort",
    name: "Fort Aguada",
    category: "Sightseeing",
    address: "Sinquerim, Candolim, Goa 403515",
    latitude: 15.4989,
    longitude: 73.7725,
    rating: 4.7,
    reviewCount: 3420,
    imageUrl:
      "https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800",
    description:
      "17th-century Portuguese lighthouse and fort overlooking the Arabian Sea.",
    openingHours: "09:30 AM - 06:00 PM",
    website: "https://goatourism.gov.in",
    phone: "+91 832 243 8593",
    estimatedDuration: "2h",
    isSaved: true,
  },
  {
    id: "place-brittos",
    name: "Brittos Restaurant & Shack",
    category: "Food",
    address: "Baga Beach, Calangute, Goa 403516",
    latitude: 15.5553,
    longitude: 73.7517,
    rating: 4.5,
    reviewCount: 2890,
    imageUrl: "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800",
    description:
      "Iconic beach shack offering fresh seafood, Goan curries, and live music.",
    openingHours: "08:30 AM - 11:30 PM",
    website: "https://brittosgoa.com",
    phone: "+91 832 227 7339",
    estimatedDuration: "1h 30m",
    isSaved: false,
  },
  {
    id: "place-basilica",
    name: "Basilica of Bom Jesus",
    category: "Sightseeing",
    address: "Old Goa Road, Bainguinim, Goa 403402",
    latitude: 15.5009,
    longitude: 73.9116,
    rating: 4.8,
    reviewCount: 4120,
    imageUrl: "https://images.unsplash.com/photo-1548013146-72479768bada?w=800",
    description:
      "UNESCO World Heritage Site holding the mortal remains of St. Francis Xavier.",
    openingHours: "09:00 AM - 06:30 PM",
    website: "https://bomjesus.org",
    phone: "+91 832 228 5790",
    estimatedDuration: "1h 30m",
    isSaved: true,
  },
  {
    id: "place-baga-beach",
    name: "Baga Beach Watersports",
    category: "Nature",
    address: "Baga, North Goa 403516",
    latitude: 15.5528,
    longitude: 73.7523,
    rating: 4.6,
    reviewCount: 1980,
    imageUrl:
      "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800",
    description:
      "Vibrant beach famous for parasailing, banana rides, and sunset views.",
    openingHours: "24 Hours",
    website: "https://goatourism.gov.in",
    estimatedDuration: "3h",
    isSaved: false,
  },
  {
    id: "place-fontainhas",
    name: "Fontainhas Latin Quarter",
    category: "Sightseeing",
    address: "Panaji, Goa 403001",
    latitude: 15.4962,
    longitude: 73.8315,
    rating: 4.7,
    reviewCount: 1540,
    imageUrl:
      "https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800",
    description:
      "Charming Portuguese heritage quarter with colorful narrow winding streets.",
    openingHours: "24 Hours",
    estimatedDuration: "2h",
    isSaved: true,
  },
];

@Injectable()
export class PlacesService {
  private savedPlaceIds = new Set<string>([
    "place-fort",
    "place-basilica",
    "place-fontainhas",
  ]);

  async searchPlaces(dto: SearchPlacesDto) {
    let results = [...MOCK_PLACES];

    if (dto.category && dto.category !== "All") {
      results = results.filter(
        (p) => p.category.toLowerCase() === dto.category!.toLowerCase(),
      );
    }

    if (dto.query && dto.query.trim().length > 0) {
      const q = dto.query.toLowerCase();
      results = results.filter(
        (p) =>
          p.name.toLowerCase().includes(q) ||
          p.description.toLowerCase().includes(q) ||
          p.address.toLowerCase().includes(q),
      );
    }

    return results.map((p) => ({
      ...p,
      isSaved: this.savedPlaceIds.has(p.id),
    }));
  }

  async getPlaceDetails(id: string) {
    const place = MOCK_PLACES.find((p) => p.id === id);
    if (!place) {
      throw new NotFoundException(`Place with ID "${id}" not found`);
    }
    return {
      ...place,
      isSaved: this.savedPlaceIds.has(id),
    };
  }

  async toggleSavePlace(id: string) {
    if (this.savedPlaceIds.has(id)) {
      this.savedPlaceIds.delete(id);
      return { isSaved: false, placeId: id };
    } else {
      this.savedPlaceIds.add(id);
      return { isSaved: true, placeId: id };
    }
  }
}
