import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';

enum DocumentCategory {
  transport,
  accommodation,
  activities,
  insurance,
  identification,
  other,
}

class DocumentCategoryConfig {
  final DocumentCategory category;
  final String label;
  final IconData icon;
  final Color color;

  const DocumentCategoryConfig({
    required this.category,
    required this.label,
    required this.icon,
    required this.color,
  });

  static const Map<DocumentCategory, DocumentCategoryConfig> _configs = {
    DocumentCategory.transport: DocumentCategoryConfig(category: DocumentCategory.transport, label: 'Transport', icon: PhosphorIconsFill.airplaneTilt, color: Colors.indigo),
    DocumentCategory.accommodation: DocumentCategoryConfig(category: DocumentCategory.accommodation, label: 'Hotel & Stay', icon: PhosphorIconsFill.buildings, color: Colors.blue),
    DocumentCategory.activities: DocumentCategoryConfig(category: DocumentCategory.activities, label: 'Activity Ticket', icon: PhosphorIconsFill.ticket, color: Colors.purple),
    DocumentCategory.insurance: DocumentCategoryConfig(category: DocumentCategory.insurance, label: 'Insurance', icon: PhosphorIconsFill.shieldCheck, color: Colors.teal),
    DocumentCategory.identification: DocumentCategoryConfig(category: DocumentCategory.identification, label: 'Passport & ID', icon: PhosphorIconsFill.identificationCard, color: Colors.amber),
    DocumentCategory.other: DocumentCategoryConfig(category: DocumentCategory.other, label: 'Other', icon: PhosphorIconsFill.fileText, color: AppColors.primary),
  };

  static DocumentCategoryConfig getConfig(DocumentCategory category) {
    return _configs[category] ?? _configs[DocumentCategory.other]!;
  }

  static DocumentCategory fromString(String str) {
    switch (str.toLowerCase()) {
      case 'transport':
        return DocumentCategory.transport;
      case 'accommodation':
        return DocumentCategory.accommodation;
      case 'activities':
        return DocumentCategory.activities;
      case 'insurance':
        return DocumentCategory.insurance;
      case 'identification':
        return DocumentCategory.identification;
      case 'other':
      default:
        return DocumentCategory.other;
    }
  }
}

class TravelDocument {
  final String id;
  final String tripId;
  final String? bookingId;
  final String title;
  final DocumentCategory category;
  final String fileType;
  final int fileSizeBytes;
  final String storagePath;
  final String uploadedAt;
  final bool isPrivate;

  const TravelDocument({
    required this.id,
    required this.tripId,
    this.bookingId,
    required this.title,
    required this.category,
    required this.fileType,
    required this.fileSizeBytes,
    required this.storagePath,
    required this.uploadedAt,
    this.isPrivate = true,
  });

  factory TravelDocument.fromJson(Map<String, dynamic> json) {
    return TravelDocument(
      id: json['id'] as String? ?? '',
      tripId: json['tripId'] as String? ?? '',
      bookingId: json['bookingId'] as String?,
      title: json['title'] as String? ?? 'Travel Document.pdf',
      category: DocumentCategoryConfig.fromString(json['category'] as String? ?? 'other'),
      fileType: json['fileType'] as String? ?? 'pdf',
      fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt() ?? 250000,
      storagePath: json['storagePath'] as String? ?? '',
      uploadedAt: json['uploadedAt'] as String? ?? DateTime.now().toIso8601String(),
      isPrivate: json['isPrivate'] as bool? ?? true,
    );
  }

  String get formattedFileSize {
    if (fileSizeBytes < 1024) return '$fileSizeBytes B';
    if (fileSizeBytes < 1024 * 1024) return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

class TripOperationsSummary {
  final String tripId;
  final int readinessScore;
  final String readinessStatus;
  final String summary;
  final int totalBookings;
  final int confirmedBookingsCount;
  final int totalDocumentsCount;
  final List<dynamic> attentionItems;

  const TripOperationsSummary({
    required this.tripId,
    required this.readinessScore,
    required this.readinessStatus,
    required this.summary,
    required this.totalBookings,
    required this.confirmedBookingsCount,
    required this.totalDocumentsCount,
    required this.attentionItems,
  });

  factory TripOperationsSummary.fromJson(Map<String, dynamic> json) {
    return TripOperationsSummary(
      tripId: json['tripId'] as String? ?? '',
      readinessScore: (json['readinessScore'] as num?)?.toInt() ?? 85,
      readinessStatus: json['readinessStatus'] as String? ?? 'mostly_ready',
      summary: json['summary'] as String? ?? 'Trip operations initialized.',
      totalBookings: (json['totalBookings'] as num?)?.toInt() ?? 0,
      confirmedBookingsCount: (json['confirmedBookingsCount'] as num?)?.toInt() ?? 0,
      totalDocumentsCount: (json['totalDocumentsCount'] as num?)?.toInt() ?? 0,
      attentionItems: json['attentionItems'] as List<dynamic>? ?? const [],
    );
  }
}
