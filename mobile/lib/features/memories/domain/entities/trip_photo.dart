class TripPhoto {
  final String id;
  final String tripId;
  final String userId;
  final String storagePath;
  final String thumbnailPath;
  final String previewPath;
  final String fileName;
  final int fileSizeBytes;
  final int width;
  final int height;
  final String? caption;
  final double? latitude;
  final double? longitude;
  final String? locationName;
  final String takenAt;
  final String uploadedAt;
  final String? itineraryActivityId;
  final String? placeId;
  final int? tripDay;
  final bool isFavorite;
  final List<String> albumIds;

  const TripPhoto({
    required this.id,
    required this.tripId,
    required this.userId,
    required this.storagePath,
    required this.thumbnailPath,
    required this.previewPath,
    required this.fileName,
    required this.fileSizeBytes,
    required this.width,
    required this.height,
    this.caption,
    this.latitude,
    this.longitude,
    this.locationName,
    required this.takenAt,
    required this.uploadedAt,
    this.itineraryActivityId,
    this.placeId,
    this.tripDay,
    this.isFavorite = false,
    this.albumIds = const [],
  });

  factory TripPhoto.fromJson(Map<String, dynamic> json) {
    return TripPhoto(
      id: json['id'] as String? ?? '',
      tripId: json['tripId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      storagePath: json['storagePath'] as String? ?? '',
      thumbnailPath: json['thumbnailPath'] as String? ?? 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400',
      previewPath: json['previewPath'] as String? ?? 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200',
      fileName: json['fileName'] as String? ?? 'photo.jpg',
      fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt() ?? 2500000,
      width: (json['width'] as num?)?.toInt() ?? 3840,
      height: (json['height'] as num?)?.toInt() ?? 2160,
      caption: json['caption'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      locationName: json['locationName'] as String?,
      takenAt: json['takenAt'] as String? ?? DateTime.now().toIso8601String(),
      uploadedAt: json['uploadedAt'] as String? ?? DateTime.now().toIso8601String(),
      itineraryActivityId: json['itineraryActivityId'] as String?,
      placeId: json['placeId'] as String?,
      tripDay: (json['tripDay'] as num?)?.toInt() ?? 1,
      isFavorite: json['isFavorite'] as bool? ?? false,
      albumIds: (json['albumIds'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }
}

class PhotoAlbum {
  final String id;
  final String tripId;
  final String userId;
  final String title;
  final String? description;
  final String coverPhotoUrl;
  final int photoCount;
  final String createdAt;

  const PhotoAlbum({
    required this.id,
    required this.tripId,
    required this.userId,
    required this.title,
    this.description,
    required this.coverPhotoUrl,
    required this.photoCount,
    required this.createdAt,
  });

  factory PhotoAlbum.fromJson(Map<String, dynamic> json) {
    return PhotoAlbum(
      id: json['id'] as String? ?? '',
      tripId: json['tripId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String? ?? 'Photo Album',
      description: json['description'] as String?,
      coverPhotoUrl: json['coverPhotoUrl'] as String? ?? 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600',
      photoCount: (json['photoCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }
}

class MemoryTimelineDay {
  final int dayNumber;
  final String dateTitle;
  final String locationTitle;
  final List<TripPhoto> photos;

  const MemoryTimelineDay({
    required this.dayNumber,
    required this.dateTitle,
    required this.locationTitle,
    required this.photos,
  });

  factory MemoryTimelineDay.fromJson(Map<String, dynamic> json) {
    return MemoryTimelineDay(
      dayNumber: (json['dayNumber'] as num?)?.toInt() ?? 1,
      dateTitle: json['dateTitle'] as String? ?? 'Day 1',
      locationTitle: json['locationTitle'] as String? ?? 'Location',
      photos: (json['photos'] as List<dynamic>?)?.map((e) => TripPhoto.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }
}

class MemoryMapPoint {
  final String id;
  final String locationName;
  final double latitude;
  final double longitude;
  final int photoCount;
  final String coverPhotoUrl;

  const MemoryMapPoint({
    required this.id,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.photoCount,
    required this.coverPhotoUrl,
  });

  factory MemoryMapPoint.fromJson(Map<String, dynamic> json) {
    return MemoryMapPoint(
      id: json['id'] as String? ?? '',
      locationName: json['locationName'] as String? ?? 'Location',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 15.5551,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 73.7512,
      photoCount: (json['photoCount'] as num?)?.toInt() ?? 1,
      coverPhotoUrl: json['coverPhotoUrl'] as String? ?? 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400',
    );
  }
}

class TripMemorySummary {
  final String tripId;
  final int totalPhotosCount;
  final int totalAlbumsCount;
  final int totalPlacesPhotographed;
  final int favoritePhotosCount;
  final String mostPhotographedPlace;
  final int mostActiveDayNumber;

  const TripMemorySummary({
    required this.tripId,
    required this.totalPhotosCount,
    required this.totalAlbumsCount,
    required this.totalPlacesPhotographed,
    required this.favoritePhotosCount,
    required this.mostPhotographedPlace,
    required this.mostActiveDayNumber,
  });

  factory TripMemorySummary.fromJson(Map<String, dynamic> json) {
    return TripMemorySummary(
      tripId: json['tripId'] as String? ?? '',
      totalPhotosCount: (json['totalPhotosCount'] as num?)?.toInt() ?? 0,
      totalAlbumsCount: (json['totalAlbumsCount'] as num?)?.toInt() ?? 0,
      totalPlacesPhotographed: (json['totalPlacesPhotographed'] as num?)?.toInt() ?? 0,
      favoritePhotosCount: (json['favoritePhotosCount'] as num?)?.toInt() ?? 0,
      mostPhotographedPlace: json['mostPhotographedPlace'] as String? ?? 'Baga Beach',
      mostActiveDayNumber: (json['mostActiveDayNumber'] as num?)?.toInt() ?? 1,
    );
  }
}
