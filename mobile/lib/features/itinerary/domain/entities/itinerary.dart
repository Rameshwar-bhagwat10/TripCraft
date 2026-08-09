import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';

enum ActivityType {
  sightseeing,
  food,
  hotel,
  transport,
  shopping,
  entertainment,
  nature,
  experience,
  event,
  custom,
}

class ActivityTypeConfig {
  final ActivityType type;
  final String label;
  final IconData icon;
  final Color tintColor;

  const ActivityTypeConfig({
    required this.type,
    required this.label,
    required this.icon,
    required this.tintColor,
  });

  static const Map<ActivityType, ActivityTypeConfig> _configs = {
    ActivityType.sightseeing: ActivityTypeConfig(
      type: ActivityType.sightseeing,
      label: 'Sightseeing',
      icon: PhosphorIconsRegular.binoculars,
      tintColor: Color(0xFF0284C7), // Sky blue
    ),
    ActivityType.food: ActivityTypeConfig(
      type: ActivityType.food,
      label: 'Food & Dining',
      icon: PhosphorIconsRegular.forkKnife,
      tintColor: Color(0xFFD97706), // Amber/Orange
    ),
    ActivityType.hotel: ActivityTypeConfig(
      type: ActivityType.hotel,
      label: 'Hotel & Stay',
      icon: PhosphorIconsRegular.bed,
      tintColor: Color(0xFF7C3AED), // Purple
    ),
    ActivityType.transport: ActivityTypeConfig(
      type: ActivityType.transport,
      label: 'Transport',
      icon: PhosphorIconsRegular.car,
      tintColor: Color(0xFF2563EB), // Blue
    ),
    ActivityType.shopping: ActivityTypeConfig(
      type: ActivityType.shopping,
      label: 'Shopping',
      icon: PhosphorIconsRegular.shoppingBag,
      tintColor: Color(0xFFDB2777), // Pink
    ),
    ActivityType.entertainment: ActivityTypeConfig(
      type: ActivityType.entertainment,
      label: 'Entertainment',
      icon: PhosphorIconsRegular.ticket,
      tintColor: Color(0xFFEA580C), // Orange
    ),
    ActivityType.nature: ActivityTypeConfig(
      type: ActivityType.nature,
      label: 'Nature & Outdoors',
      icon: PhosphorIconsRegular.tree,
      tintColor: Color(0xFF16A34A), // Green
    ),
    ActivityType.experience: ActivityTypeConfig(
      type: ActivityType.experience,
      label: 'Experience',
      icon: PhosphorIconsRegular.sparkle,
      tintColor: Color(0xFF0D9488), // Teal
    ),
    ActivityType.event: ActivityTypeConfig(
      type: ActivityType.event,
      label: 'Event',
      icon: PhosphorIconsRegular.calendarCheck,
      tintColor: Color(0xFF4F46E5), // Indigo
    ),
    ActivityType.custom: ActivityTypeConfig(
      type: ActivityType.custom,
      label: 'Custom Activity',
      icon: PhosphorIconsRegular.pinwheel,
      tintColor: AppColors.textSecondary,
    ),
  };

  static ActivityTypeConfig getConfig(ActivityType type) {
    return _configs[type] ?? _configs[ActivityType.custom]!;
  }

  static ActivityType fromString(String str) {
    switch (str.toLowerCase()) {
      case 'sightseeing':
        return ActivityType.sightseeing;
      case 'food':
      case 'dining':
        return ActivityType.food;
      case 'hotel':
      case 'stay':
        return ActivityType.hotel;
      case 'transport':
        return ActivityType.transport;
      case 'shopping':
        return ActivityType.shopping;
      case 'entertainment':
        return ActivityType.entertainment;
      case 'nature':
        return ActivityType.nature;
      case 'experience':
        return ActivityType.experience;
      case 'event':
        return ActivityType.event;
      case 'custom':
      default:
        return ActivityType.custom;
    }
  }
}

class ItineraryItem {
  final String id;
  final String tripDayId;
  final String? placeId;
  final String title;
  final String? description;
  final ActivityType type;
  final String? startTime;
  final String? endTime;
  final String? duration;
  final int orderIndex;
  final String? notes;
  final String? imageUrl;
  final bool isAllDay;
  final String createdAt;
  final String updatedAt;

  const ItineraryItem({
    required this.id,
    required this.tripDayId,
    this.placeId,
    required this.title,
    this.description,
    this.type = ActivityType.sightseeing,
    this.startTime,
    this.endTime,
    this.duration,
    this.orderIndex = 0,
    this.notes,
    this.imageUrl,
    this.isAllDay = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ItineraryItem.fromJson(Map<String, dynamic> json) {
    return ItineraryItem(
      id: json['id'] as String,
      tripDayId: json['tripDayId'] as String? ?? '',
      placeId: json['placeId'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      type: ActivityTypeConfig.fromString(json['type'] as String? ?? 'sightseeing'),
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      duration: json['duration'] as String?,
      orderIndex: json['orderIndex'] as int? ?? 0,
      notes: json['notes'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isAllDay: json['isAllDay'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      updatedAt: json['updatedAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  ItineraryItem copyWith({
    String? title,
    String? description,
    ActivityType? type,
    String? startTime,
    String? endTime,
    String? duration,
    int? orderIndex,
    String? notes,
    String? imageUrl,
    bool? isAllDay,
    String? tripDayId,
  }) {
    return ItineraryItem(
      id: id,
      tripDayId: tripDayId ?? this.tripDayId,
      placeId: placeId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      orderIndex: orderIndex ?? this.orderIndex,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
      isAllDay: isAllDay ?? this.isAllDay,
      createdAt: createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );
  }
}

class TripDay {
  final String id;
  final String tripId;
  final String date;
  final int dayNumber;
  final String? title;
  final String? notes;
  final List<ItineraryItem> items;
  final String createdAt;
  final String updatedAt;

  const TripDay({
    required this.id,
    required this.tripId,
    required this.date,
    required this.dayNumber,
    this.title,
    this.notes,
    this.items = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory TripDay.fromJson(Map<String, dynamic> json) {
    return TripDay(
      id: json['id'] as String,
      tripId: json['tripId'] as String? ?? '',
      date: json['date'] as String,
      dayNumber: json['dayNumber'] as int? ?? 1,
      title: json['title'] as String?,
      notes: json['notes'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ItineraryItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      updatedAt: json['updatedAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  TripDay copyWith({
    String? title,
    String? notes,
    List<ItineraryItem>? items,
  }) {
    return TripDay(
      id: id,
      tripId: tripId,
      date: date,
      dayNumber: dayNumber,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      items: items ?? this.items,
      createdAt: createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );
  }
}

class Itinerary {
  final String tripId;
  final List<TripDay> days;

  const Itinerary({
    required this.tripId,
    this.days = const [],
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      tripId: json['tripId'] as String,
      days: (json['days'] as List<dynamic>?)
              ?.map((e) => TripDay.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ItineraryConflict {
  final ItineraryItem item1;
  final ItineraryItem item2;

  const ItineraryConflict({
    required this.item1,
    required this.item2,
  });
}
