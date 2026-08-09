import { Injectable } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";

@Injectable()
export class MapsService {
  constructor(private readonly configService: ConfigService) {}

  async getMapConfig() {
    return {
      mapboxPublicToken:
        this.configService.get<string>("MAPBOX_PUBLIC_TOKEN") || "",
      defaultStyle: "mapbox://styles/mapbox/streets-v12",
      defaultCenter: { latitude: 15.2993, longitude: 74.124 }, // Goa coordinates default
      defaultZoom: 11,
    };
  }

  async geocode(query: string) {
    // Geocoding fallback mock data
    return [
      {
        id: "geo-1",
        name: query,
        latitude: 15.4989,
        longitude: 73.8278,
        address: `${query}, Goa, India`,
      },
    ];
  }

  async reverseGeocode(lat: number, lng: number) {
    return {
      latitude: lat,
      longitude: lng,
      address: "Panaji, North Goa, Goa, India",
      city: "Panaji",
      country: "India",
    };
  }
}
