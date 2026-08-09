import { Injectable, NotFoundException } from "@nestjs/common";
import { AnalyzeRouteDto } from "../dto/analyze-route.dto";
import { OptimizeRouteDto } from "../dto/optimize-route.dto";

@Injectable()
export class RouteIntelligenceService {
  async analyzeRoute(tripId: string, dayId: string, dto: AnalyzeRouteDto) {
    const mode = dto.mode ?? "driving";

    // Mock itinerary stop sequence for day
    const stops = [
      {
        id: "item-1",
        title: "Breakfast at Cafe Bodega",
        startTime: "09:00",
        endTime: "10:00",
        lat: 15.4962,
        lng: 73.8315,
      },
      {
        id: "item-2",
        title: "Explore Fort Aguada",
        startTime: "10:30",
        endTime: "12:30",
        lat: 15.4989,
        lng: 73.7725,
      },
      {
        id: "item-3",
        title: "Seafood Lunch at Brittos",
        startTime: "13:00",
        endTime: "14:30",
        lat: 15.5553,
        lng: 73.7517,
      },
      {
        id: "item-4",
        title: "Basilica of Bom Jesus",
        startTime: "15:00",
        endTime: "16:30",
        lat: 15.5009,
        lng: 73.9116,
      },
    ];

    const segments = [
      {
        fromId: "item-1",
        fromTitle: "Breakfast at Cafe Bodega",
        toId: "item-2",
        toTitle: "Explore Fort Aguada",
        distanceKm: 8.5,
        durationMins: 22,
        mode,
      },
      {
        fromId: "item-2",
        fromTitle: "Explore Fort Aguada",
        toId: "item-3",
        toTitle: "Seafood Lunch at Brittos",
        distanceKm: 12.4,
        durationMins: 28,
        mode,
      },
      {
        fromId: "item-3",
        fromTitle: "Seafood Lunch at Brittos",
        toId: "item-4",
        toTitle: "Basilica of Bom Jesus",
        distanceKm: 21.7,
        durationMins: 45,
        mode,
      },
    ];

    const totalDistanceKm = 42.6;
    const totalDurationMins = 95; // 1h 35m

    const insights = [
      {
        id: "ins-1",
        type: "backtracking",
        severity: "warning",
        title: "Backtracking Detected",
        description:
          "You travel from Central Panaji to North Candolim, then Baga, and return east to Old Goa.",
        estimatedTimeSavedMins: 24,
        estimatedDistanceSavedKm: 6.8,
        recommendedAction:
          "Reorder stops to visit Fort Aguada and Brittos consecutively before heading to Old Goa.",
      },
      {
        id: "ins-2",
        type: "scheduleConflict",
        severity: "critical",
        title: "Tight Schedule Window",
        description:
          "Drive from Brittos to Basilica takes 45 mins, leaving only 30 mins buffer between activities.",
        estimatedTimeSavedMins: 15,
        recommendedAction: "Adjust start time of Basilica visit to 15:30.",
      },
      {
        id: "ins-3",
        type: "nearbyGrouping",
        severity: "suggestion",
        title: "Nearby Place Opportunity",
        description:
          "Fontainhas Heritage Walk is only 1.2 km from Cafe Bodega.",
        recommendedAction: "Group Fontainhas walk immediately after breakfast.",
      },
    ];

    return {
      tripId,
      dayId,
      mode,
      totalDistanceKm,
      totalDurationMins,
      efficiencyScore: 78,
      travelBurdenLevel: "Moderate",
      segments,
      insights,
    };
  }

  async optimizeRoute(tripId: string, dayId: string, dto: OptimizeRouteDto) {
    const currentOrder = ["item-1", "item-2", "item-3", "item-4"];
    const optimizedOrder = ["item-1", "item-2", "item-3", "item-4"];

    return {
      tripId,
      dayId,
      currentSequence: currentOrder,
      suggestedSequence: optimizedOrder,
      timeSavingsMins: 24,
      distanceSavingsKm: 6.8,
      explanation:
        "Reordering stops groups North Goa coastal sites together before travelling inland.",
      canApply: true,
    };
  }
}
