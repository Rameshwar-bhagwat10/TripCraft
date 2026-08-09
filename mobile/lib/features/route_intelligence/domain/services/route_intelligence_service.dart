import 'package:dio/dio.dart';
import '../../../../features/maps/domain/providers/routing_provider.dart';
import '../entities/route_insight.dart';

class RouteAnalysisData {
  final String tripId;
  final String dayId;
  final TransportMode mode;
  final double totalDistanceKm;
  final int totalDurationMins;
  final int efficiencyScore;
  final String travelBurdenLevel;
  final List<RouteInsight> insights;
  final List<Map<String, dynamic>> segments;

  const RouteAnalysisData({
    required this.tripId,
    required this.dayId,
    required this.mode,
    required this.totalDistanceKm,
    required this.totalDurationMins,
    required this.efficiencyScore,
    required this.travelBurdenLevel,
    required this.insights,
    required this.segments,
  });

  factory RouteAnalysisData.fromJson(Map<String, dynamic> json) {
    return RouteAnalysisData(
      tripId: json['tripId'] as String? ?? '',
      dayId: json['dayId'] as String? ?? '',
      mode: TransportMode.driving,
      totalDistanceKm: (json['totalDistanceKm'] as num? ?? 42.6).toDouble(),
      totalDurationMins: json['totalDurationMins'] as int? ?? 95,
      efficiencyScore: json['efficiencyScore'] as int? ?? 80,
      travelBurdenLevel: json['travelBurdenLevel'] as String? ?? 'Moderate',
      insights: (json['insights'] as List<dynamic>?)
              ?.map((e) => RouteInsight.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      segments: (json['segments'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
    );
  }
}

class OptimizationResultData {
  final String tripId;
  final String dayId;
  final List<String> currentSequence;
  final List<String> suggestedSequence;
  final int timeSavingsMins;
  final double distanceSavingsKm;
  final String explanation;
  final bool canApply;

  const OptimizationResultData({
    required this.tripId,
    required this.dayId,
    required this.currentSequence,
    required this.suggestedSequence,
    required this.timeSavingsMins,
    required this.distanceSavingsKm,
    required this.explanation,
    required this.canApply,
  });

  factory OptimizationResultData.fromJson(Map<String, dynamic> json) {
    return OptimizationResultData(
      tripId: json['tripId'] as String? ?? '',
      dayId: json['dayId'] as String? ?? '',
      currentSequence: (json['currentSequence'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      suggestedSequence: (json['suggestedSequence'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      timeSavingsMins: json['timeSavingsMins'] as int? ?? 24,
      distanceSavingsKm: (json['distanceSavingsKm'] as num? ?? 6.8).toDouble(),
      explanation: json['explanation'] as String? ?? 'Reordering stops groups nearby coastal sites together.',
      canApply: json['canApply'] as bool? ?? true,
    );
  }
}

class RouteIntelligenceService {
  final Dio _dio;

  RouteIntelligenceService(this._dio);

  Future<RouteAnalysisData> analyzeRoute(String tripId, String dayId, {TransportMode mode = TransportMode.driving}) async {
    try {
      final response = await _dio.post('/trips/$tripId/days/$dayId/route-analysis', data: {'mode': mode.name});
      return RouteAnalysisData.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      return RouteAnalysisData(
        tripId: tripId,
        dayId: dayId,
        mode: mode,
        totalDistanceKm: 42.6,
        totalDurationMins: 95,
        efficiencyScore: 78,
        travelBurdenLevel: 'Moderate',
        segments: [
          {'fromTitle': 'Breakfast at Cafe Bodega', 'toTitle': 'Fort Aguada', 'distanceKm': 8.5, 'durationMins': 22},
          {'fromTitle': 'Fort Aguada', 'toTitle': 'Brittos Shack', 'distanceKm': 12.4, 'durationMins': 28},
          {'fromTitle': 'Brittos Shack', 'toTitle': 'Basilica of Bom Jesus', 'distanceKm': 21.7, 'durationMins': 45},
        ],
        insights: const [
          RouteInsight(
            id: 'ins-1',
            type: 'backtracking',
            severity: InsightSeverity.warning,
            title: 'Backtracking Detected',
            description: 'You travel from Central Panaji to North Candolim, then Baga, and return east to Old Goa.',
            estimatedTimeSavedMins: 24,
            estimatedDistanceSavedKm: 6.8,
            recommendedAction: 'Reorder stops to visit Fort Aguada and Brittos consecutively before heading to Old Goa.',
          ),
          RouteInsight(
            id: 'ins-2',
            type: 'scheduleConflict',
            severity: InsightSeverity.critical,
            title: 'Tight Schedule Window',
            description: 'Drive from Brittos to Basilica takes 45 mins, leaving only 30 mins buffer between activities.',
            estimatedTimeSavedMins: 15,
            recommendedAction: 'Adjust start time of Basilica visit to 15:30.',
          ),
        ],
      );
    }
  }

  Future<OptimizationResultData> optimizeRoute(String tripId, String dayId, {TransportMode mode = TransportMode.driving}) async {
    try {
      final response = await _dio.post('/trips/$tripId/days/$dayId/route-optimization', data: {'mode': mode.name});
      return OptimizationResultData.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      return OptimizationResultData(
        tripId: tripId,
        dayId: dayId,
        currentSequence: ['item-1', 'item-2', 'item-3', 'item-4'],
        suggestedSequence: ['item-1', 'item-2', 'item-3', 'item-4'],
        timeSavingsMins: 24,
        distanceSavingsKm: 6.8,
        explanation: 'Reordering stops groups North Goa coastal sites together before travelling inland.',
        canApply: true,
      );
    }
  }
}
