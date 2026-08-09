enum TripStatus {
  upcoming,
  ongoing,
  completed,
  draft,
  archived,
}

extension TripStatusX on TripStatus {
  String get label {
    switch (this) {
      case TripStatus.upcoming:
        return 'Upcoming';
      case TripStatus.ongoing:
        return 'Ongoing';
      case TripStatus.completed:
        return 'Completed';
      case TripStatus.draft:
        return 'Draft';
      case TripStatus.archived:
        return 'Archived';
    }
  }

  static TripStatus fromString(String statusStr) {
    switch (statusStr.toLowerCase()) {
      case 'ongoing':
        return TripStatus.ongoing;
      case 'completed':
      case 'past':
        return TripStatus.completed;
      case 'draft':
        return TripStatus.draft;
      case 'archived':
        return TripStatus.archived;
      case 'upcoming':
      default:
        return TripStatus.upcoming;
    }
  }
}

class TripDestination {
  final String id;
  final String name;
  final String city;
  final String country;
  final String heroImage;

  const TripDestination({
    required this.id,
    required this.name,
    required this.city,
    required this.country,
    required this.heroImage,
  });

  factory TripDestination.fromJson(Map<String, dynamic> json) {
    return TripDestination(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Destination',
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
      heroImage: json['heroImage'] as String? ?? json['image'] as String? ?? '',
    );
  }
}

class TripMember {
  final String id;
  final String userId;
  final String role;
  final String status;

  const TripMember({
    required this.id,
    required this.userId,
    this.role = 'Owner',
    this.status = 'Active',
  });

  factory TripMember.fromJson(Map<String, dynamic> json) {
    return TripMember(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      role: json['role'] as String? ?? 'Owner',
      status: json['status'] as String? ?? 'Active',
    );
  }
}

class Trip {
  final String id;
  final String ownerId;
  final String destinationId;
  final String title;
  final String? description;
  final String coverImage;
  final String startDate;
  final String endDate;
  final TripStatus status;
  final int travelersCount;
  final String visibility;
  final TripDestination? destination;
  final List<TripMember> members;
  final String createdAt;
  final String updatedAt;

  const Trip({
    required this.id,
    required this.ownerId,
    required this.destinationId,
    required this.title,
    this.description,
    required this.coverImage,
    required this.startDate,
    required this.endDate,
    this.status = TripStatus.upcoming,
    this.travelersCount = 1,
    this.visibility = 'Private',
    this.destination,
    this.members = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  int get durationDays {
    try {
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);
      final diff = end.difference(start).inDays + 1;
      return diff > 0 ? diff : 1;
    } catch (_) {
      return 1;
    }
  }

  int get daysToGo {
    try {
      final start = DateTime.parse(startDate);
      final now = DateTime.now();
      final diff = start.difference(now).inDays;
      return diff > 0 ? diff : 0;
    } catch (_) {
      return 0;
    }
  }

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String? ?? '',
      destinationId: json['destinationId'] as String? ?? '',
      title: json['title'] as String,
      description: json['description'] as String?,
      coverImage: json['coverImage'] as String? ?? '',
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      status: TripStatusX.fromString(json['status'] as String? ?? 'Upcoming'),
      travelersCount: json['travelersCount'] as int? ?? 1,
      visibility: json['visibility'] as String? ?? 'Private',
      destination: json['destination'] != null
          ? TripDestination.fromJson(json['destination'] as Map<String, dynamic>)
          : null,
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => TripMember.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      updatedAt: json['updatedAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Trip copyWith({
    String? title,
    String? description,
    String? startDate,
    String? endDate,
    TripStatus? status,
    int? travelersCount,
    String? coverImage,
  }) {
    return Trip(
      id: id,
      ownerId: ownerId,
      destinationId: destinationId,
      title: title ?? this.title,
      description: description ?? this.description,
      coverImage: coverImage ?? this.coverImage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      travelersCount: travelersCount ?? this.travelersCount,
      visibility: visibility,
      destination: destination,
      members: members,
      createdAt: createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );
  }
}

class TripFilter {
  final String? status;
  final int page;
  final int limit;

  const TripFilter({
    this.status,
    this.page = 1,
    this.limit = 20,
  });
}
