import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';

enum ReadinessStatus {
  ready,
  good,
  needsReview,
  highRisk,
}

class ReadinessStatusConfig {
  final ReadinessStatus status;
  final String label;
  final IconData icon;
  final Color color;

  const ReadinessStatusConfig({
    required this.status,
    required this.label,
    required this.icon,
    required this.color,
  });

  static const Map<ReadinessStatus, ReadinessStatusConfig> _configs = {
    ReadinessStatus.ready: ReadinessStatusConfig(status: ReadinessStatus.ready, label: 'Fully Ready', icon: PhosphorIconsFill.checkCircle, color: Color(0xFF10B981)),
    ReadinessStatus.good: ReadinessStatusConfig(status: ReadinessStatus.good, label: 'Good Shape', icon: PhosphorIconsFill.thumbsUp, color: AppColors.primary),
    ReadinessStatus.needsReview: ReadinessStatusConfig(status: ReadinessStatus.needsReview, label: 'Needs Review', icon: PhosphorIconsFill.warning, color: Colors.orange),
    ReadinessStatus.highRisk: ReadinessStatusConfig(status: ReadinessStatus.highRisk, label: 'High Risk', icon: PhosphorIconsFill.warningOctagon, color: AppColors.error),
  };

  static ReadinessStatusConfig getConfig(ReadinessStatus status) {
    return _configs[status] ?? _configs[ReadinessStatus.good]!;
  }

  static ReadinessStatus fromString(String str) {
    switch (str.toLowerCase()) {
      case 'ready':
        return ReadinessStatus.ready;
      case 'good':
        return ReadinessStatus.good;
      case 'needs_review':
      case 'needsreview':
        return ReadinessStatus.needsReview;
      case 'high_risk':
      case 'highrisk':
        return ReadinessStatus.highRisk;
      default:
        return ReadinessStatus.needsReview;
    }
  }
}

class TripReadiness {
  final ReadinessStatus status;
  final String summary;
  final String weatherFactorLabel;
  final bool isWeatherWarning;
  final String routeFactorLabel;
  final bool isRouteWarning;
  final String scheduleFactorLabel;
  final bool isScheduleWarning;
  final String activityFactorLabel;
  final bool isActivityWarning;

  const TripReadiness({
    required this.status,
    required this.summary,
    required this.weatherFactorLabel,
    this.isWeatherWarning = false,
    required this.routeFactorLabel,
    this.isRouteWarning = false,
    required this.scheduleFactorLabel,
    this.isScheduleWarning = false,
    required this.activityFactorLabel,
    this.isActivityWarning = false,
  });

  factory TripReadiness.fromJson(Map<String, dynamic> json) {
    final weatherObj = json['weatherFactor'] as Map<String, dynamic>? ?? {};
    final routeObj = json['routeFactor'] as Map<String, dynamic>? ?? {};
    final scheduleObj = json['scheduleFactor'] as Map<String, dynamic>? ?? {};
    final activityObj = json['activityFactor'] as Map<String, dynamic>? ?? {};

    return TripReadiness(
      status: ReadinessStatusConfig.fromString(json['status'] as String? ?? 'needs_review'),
      summary: json['summary'] as String? ?? 'Review outdoor weather and schedule feasibility.',
      weatherFactorLabel: weatherObj['label'] as String? ?? 'Good weather forecast',
      isWeatherWarning: weatherObj['status'] == 'warning',
      routeFactorLabel: routeObj['label'] as String? ?? 'Efficient travel route',
      isRouteWarning: routeObj['status'] == 'warning',
      scheduleFactorLabel: scheduleObj['label'] as String? ?? 'Feasible schedule',
      isScheduleWarning: scheduleObj['status'] == 'warning',
      activityFactorLabel: activityObj['label'] as String? ?? 'Well-distributed activities',
      isActivityWarning: activityObj['status'] == 'warning',
    );
  }
}

class AlternativeActivity {
  final String id;
  final String name;
  final String category;
  final String address;
  final double rating;
  final String suitabilityReason;

  const AlternativeActivity({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.rating,
    required this.suitabilityReason,
  });

  factory AlternativeActivity.fromJson(Map<String, dynamic> json) {
    return AlternativeActivity(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? 'sightseeing',
      address: json['address'] as String? ?? '',
      rating: (json['rating'] as num? ?? 4.5).toDouble(),
      suitabilityReason: json['suitabilityReason'] as String? ?? 'Indoor alternative',
    );
  }
}
