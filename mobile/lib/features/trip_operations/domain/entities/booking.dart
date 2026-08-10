import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';

enum BookingType {
  flight,
  hotel,
  train,
  bus,
  carRental,
  activity,
  restaurant,
  other,
}

class BookingTypeConfig {
  final BookingType type;
  final String label;
  final IconData icon;
  final Color color;

  const BookingTypeConfig({
    required this.type,
    required this.label,
    required this.icon,
    required this.color,
  });

  static const Map<BookingType, BookingTypeConfig> _configs = {
    BookingType.flight: BookingTypeConfig(type: BookingType.flight, label: 'Flight', icon: PhosphorIconsFill.airplaneTilt, color: Colors.indigo),
    BookingType.hotel: BookingTypeConfig(type: BookingType.hotel, label: 'Hotel & Stay', icon: PhosphorIconsFill.buildings, color: Colors.blue),
    BookingType.train: BookingTypeConfig(type: BookingType.train, label: 'Train', icon: PhosphorIconsFill.train, color: Colors.teal),
    BookingType.bus: BookingTypeConfig(type: BookingType.bus, label: 'Bus', icon: PhosphorIconsFill.bus, color: Colors.amber),
    BookingType.carRental: BookingTypeConfig(type: BookingType.carRental, label: 'Car Rental', icon: PhosphorIconsFill.car, color: Colors.deepOrange),
    BookingType.activity: BookingTypeConfig(type: BookingType.activity, label: 'Activity', icon: PhosphorIconsFill.ticket, color: Colors.purple),
    BookingType.restaurant: BookingTypeConfig(type: BookingType.restaurant, label: 'Dining', icon: PhosphorIconsFill.forkKnife, color: Colors.pink),
    BookingType.other: BookingTypeConfig(type: BookingType.other, label: 'Other', icon: PhosphorIconsFill.bookmarkSimple, color: AppColors.primary),
  };

  static BookingTypeConfig getConfig(BookingType type) {
    return _configs[type] ?? _configs[BookingType.other]!;
  }

  static BookingType fromString(String str) {
    switch (str.toLowerCase()) {
      case 'flight':
        return BookingType.flight;
      case 'hotel':
        return BookingType.hotel;
      case 'train':
        return BookingType.train;
      case 'bus':
        return BookingType.bus;
      case 'car_rental':
      case 'carrental':
        return BookingType.carRental;
      case 'activity':
        return BookingType.activity;
      case 'restaurant':
        return BookingType.restaurant;
      case 'other':
      default:
        return BookingType.other;
    }
  }
}

enum BookingStatus {
  draft,
  pending,
  confirmed,
  cancelled,
  completed,
}

class BookingStatusConfig {
  final BookingStatus status;
  final String label;
  final IconData icon;
  final Color color;

  const BookingStatusConfig({
    required this.status,
    required this.label,
    required this.icon,
    required this.color,
  });

  static const Map<BookingStatus, BookingStatusConfig> _configs = {
    BookingStatus.confirmed: BookingStatusConfig(status: BookingStatus.confirmed, label: 'Confirmed', icon: PhosphorIconsFill.checkCircle, color: Color(0xFF10B981)),
    BookingStatus.pending: BookingStatusConfig(status: BookingStatus.pending, label: 'Pending', icon: PhosphorIconsFill.clock, color: Colors.orange),
    BookingStatus.cancelled: BookingStatusConfig(status: BookingStatus.cancelled, label: 'Cancelled', icon: PhosphorIconsFill.xCircle, color: AppColors.error),
    BookingStatus.completed: BookingStatusConfig(status: BookingStatus.completed, label: 'Completed', icon: PhosphorIconsFill.checkSquare, color: AppColors.textTertiary),
    BookingStatus.draft: BookingStatusConfig(status: BookingStatus.draft, label: 'Draft', icon: PhosphorIconsFill.pencilSimple, color: AppColors.primary),
  };

  static BookingStatusConfig getConfig(BookingStatus status) {
    return _configs[status] ?? _configs[BookingStatus.pending]!;
  }

  static BookingStatus fromString(String str) {
    switch (str.toLowerCase()) {
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'cancelled':
        return BookingStatus.cancelled;
      case 'completed':
        return BookingStatus.completed;
      case 'draft':
        return BookingStatus.draft;
      case 'pending':
      default:
        return BookingStatus.pending;
    }
  }
}

class Booking {
  final String id;
  final String tripId;
  final BookingType type;
  final String title;
  final String providerName;
  final String confirmationNumber;
  final BookingStatus status;
  final String startDateTime;
  final String? endDateTime;
  final String? location;
  final Map<String, dynamic>? details;
  final List<String> linkedDocumentIds;
  final String createdAt;

  const Booking({
    required this.id,
    required this.tripId,
    required this.type,
    required this.title,
    required this.providerName,
    required this.confirmationNumber,
    required this.status,
    required this.startDateTime,
    this.endDateTime,
    this.location,
    this.details,
    this.linkedDocumentIds = const [],
    required this.createdAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String? ?? '',
      tripId: json['tripId'] as String? ?? '',
      type: BookingTypeConfig.fromString(json['type'] as String? ?? 'other'),
      title: json['title'] as String? ?? 'Travel Reservation',
      providerName: json['providerName'] as String? ?? 'Provider',
      confirmationNumber: json['confirmationNumber'] as String? ?? '',
      status: BookingStatusConfig.fromString(json['status'] as String? ?? 'pending'),
      startDateTime: json['startDateTime'] as String? ?? DateTime.now().toIso8601String(),
      endDateTime: json['endDateTime'] as String?,
      location: json['location'] as String?,
      details: json['details'] as Map<String, dynamic>?,
      linkedDocumentIds: (json['linkedDocumentIds'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }
}
