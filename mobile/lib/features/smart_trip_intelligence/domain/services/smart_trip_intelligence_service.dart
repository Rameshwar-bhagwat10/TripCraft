import 'package:dio/dio.dart';
import '../../../../features/route_intelligence/domain/entities/route_insight.dart';
import '../entities/trip_readiness.dart';

class SmartTripIntelligenceData {
  final String tripId;
  final TripReadiness readiness;
  final List<RouteInsight> insights;
  final List<AlternativeActivity> alternatives;
  final String updatedAt;

  const SmartTripIntelligenceData({
    required this.tripId,
    required this.readiness,
    required this.insights,
    required this.alternatives,
    required this.updatedAt,
  });

  factory SmartTripIntelligenceData.fromJson(Map<String, dynamic> json) {
    final readinessObj = json['readiness'] as Map<String, dynamic>? ?? {};
    final insightsList = (json['insights'] as List<dynamic>?)
            ?.map((e) => RouteInsight.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    final altList = (json['insights'] as List<dynamic>?)
            ?.expand((e) => (e['alternativeSuggestions'] as List<dynamic>? ?? []))
            .map((e) => AlternativeActivity.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return SmartTripIntelligenceData(
      tripId: json['tripId'] as String? ?? '',
      readiness: TripReadiness.fromJson(readinessObj),
      insights: insightsList,
      alternatives: altList,
      updatedAt: json['updatedAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }
}

class SmartTripIntelligenceService {
  final Dio _dio;

  SmartTripIntelligenceService(this._dio);

  static final SmartTripIntelligenceData _mockData = SmartTripIntelligenceData(
    tripId: 'trip-goa-escape',
    readiness: const TripReadiness(
      status: ReadinessStatus.needsReview,
      summary: '2 weather-sensitive outdoor activities overlap with expected afternoon monsoon rain on Day 2.',
      weatherFactorLabel: 'Afternoon rain expected',
      isWeatherWarning: true,
      routeFactorLabel: 'Efficient travel route',
      isRouteWarning: false,
      scheduleFactorLabel: '1 timing conflict',
      isScheduleWarning: true,
      activityFactorLabel: '5 well-distributed activities',
      isActivityWarning: false,
    ),
    insights: const [
      RouteInsight(
        id: 'smart-ins-1',
        type: 'weatherConflict',
        severity: InsightSeverity.warning,
        title: 'Outdoor Rain Risk',
        description: 'Your planned visit to Baga Beach Watersports at 03:00 PM overlaps with expected heavy monsoon rain (85% probability).',
        estimatedTimeSavedMins: 30,
        recommendedAction: 'Move Baga Beach visit to 10:00 AM (sunny window) or substitute with an indoor museum/cafe.',
      ),
      RouteInsight(
        id: 'smart-ins-2',
        type: 'weatherRouteRisk',
        severity: InsightSeverity.suggestion,
        title: 'Rain Travel Buffer',
        description: 'Light rain expected during the 45-minute drive from Calangute to Old Goa. Allow an additional 15 minutes travel buffer.',
        estimatedTimeSavedMins: 15,
        recommendedAction: 'Depart Calangute 15 minutes earlier at 04:15 PM.',
      ),
      RouteInsight(
        id: 'smart-ins-3',
        type: 'backtracking',
        severity: InsightSeverity.suggestion,
        title: 'Route Efficiency Opportunity',
        description: 'Visiting Fort Aguada before Brittos Shack reduces daily travel distance by 6.8 km.',
        estimatedTimeSavedMins: 24,
        recommendedAction: 'Reorder Day 1 stops to group coastal sites consecutively.',
      ),
    ],
    alternatives: const [
      AlternativeActivity(
        id: 'alt-1',
        name: 'Museum of Christian Art',
        category: 'sightseeing',
        address: 'Old Goa Road, Goa',
        rating: 4.6,
        suitabilityReason: 'Indoor museum · Rain safe · 12 min away',
      ),
      AlternativeActivity(
        id: 'alt-2',
        name: 'Cafe Bodega Art Gallery',
        category: 'cafe',
        address: 'Sunaparanta Art Centre, Altinho',
        rating: 4.8,
        suitabilityReason: 'Covered patio & cafe · Rain safe · 8 min away',
      ),
    ],
    updatedAt: '2026-08-10T10:00:00Z',
  );

  Future<SmartTripIntelligenceData> getTripIntelligence(String tripId) async {
    try {
      final response = await _dio.get('/trips/$tripId/intelligence');
      return SmartTripIntelligenceData.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      return _mockData;
    }
  }

  Future<SmartTripIntelligenceData> refreshIntelligence(String tripId) async {
    try {
      final response = await _dio.post('/trips/$tripId/intelligence/refresh');
      return SmartTripIntelligenceData.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      return _mockData;
    }
  }
}
