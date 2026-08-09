import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';

enum InsightSeverity {
  info,
  suggestion,
  warning,
  critical,
}

class InsightSeverityConfig {
  final InsightSeverity severity;
  final String label;
  final IconData icon;
  final Color color;

  const InsightSeverityConfig({
    required this.severity,
    required this.label,
    required this.icon,
    required this.color,
  });

  static const Map<InsightSeverity, InsightSeverityConfig> _configs = {
    InsightSeverity.info: InsightSeverityConfig(
      severity: InsightSeverity.info,
      label: 'INFO',
      icon: PhosphorIconsRegular.info,
      color: Color(0xFF2563EB),
    ),
    InsightSeverity.suggestion: InsightSeverityConfig(
      severity: InsightSeverity.suggestion,
      label: 'SUGGESTION',
      icon: PhosphorIconsRegular.lightbulb,
      color: Color(0xFF0D9488),
    ),
    InsightSeverity.warning: InsightSeverityConfig(
      severity: InsightSeverity.warning,
      label: 'WARNING',
      icon: PhosphorIconsBold.warningCircle,
      color: Color(0xFFD97706),
    ),
    InsightSeverity.critical: InsightSeverityConfig(
      severity: InsightSeverity.critical,
      label: 'CRITICAL',
      icon: PhosphorIconsBold.warningCircle,
      color: AppColors.error,
    ),
  };

  static InsightSeverityConfig getConfig(InsightSeverity s) {
    return _configs[s] ?? _configs[InsightSeverity.info]!;
  }
}

class RouteInsight {
  final String id;
  final String type;
  final InsightSeverity severity;
  final String title;
  final String description;
  final int? estimatedTimeSavedMins;
  final double? estimatedDistanceSavedKm;
  final String? recommendedAction;

  const RouteInsight({
    required this.id,
    required this.type,
    required this.severity,
    required this.title,
    required this.description,
    this.estimatedTimeSavedMins,
    this.estimatedDistanceSavedKm,
    this.recommendedAction,
  });

  factory RouteInsight.fromJson(Map<String, dynamic> json) {
    InsightSeverity severityVal = InsightSeverity.info;
    final sevStr = (json['severity'] as String? ?? 'info').toLowerCase();
    if (sevStr == 'warning') severityVal = InsightSeverity.warning;
    if (sevStr == 'critical') severityVal = InsightSeverity.critical;
    if (sevStr == 'suggestion') severityVal = InsightSeverity.suggestion;

    return RouteInsight(
      id: json['id'] as String? ?? 'ins-1',
      type: json['type'] as String? ?? 'general',
      severity: severityVal,
      title: json['title'] as String? ?? 'Route Insight',
      description: json['description'] as String? ?? '',
      estimatedTimeSavedMins: json['estimatedTimeSavedMins'] as int?,
      estimatedDistanceSavedKm: (json['estimatedDistanceSavedKm'] as num?)?.toDouble(),
      recommendedAction: json['recommendedAction'] as String?,
    );
  }
}
