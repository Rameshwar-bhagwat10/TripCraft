class GreetingData {
  final String greetingText;
  final String userName;

  const GreetingData({
    required this.greetingText,
    required this.userName,
  });
}

class UpcomingTrip {
  final String id;
  final String destination;
  final String location;
  final String startDate;
  final String endDate;
  final int daysToGo;
  final String imageUrl;

  const UpcomingTrip({
    required this.id,
    required this.destination,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.daysToGo,
    required this.imageUrl,
  });

  factory UpcomingTrip.fromJson(Map<String, dynamic> json) {
    return UpcomingTrip(
      id: json['id'] as String,
      destination: json['destination'] as String,
      location: json['location'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      daysToGo: json['daysToGo'] as int? ?? 0,
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }
}

class RecommendedDestination {
  final String id;
  final String title;
  final String location;
  final String category;
  final String imageUrl;
  final bool isSaved;

  const RecommendedDestination({
    required this.id,
    required this.title,
    required this.location,
    required this.category,
    required this.imageUrl,
    this.isSaved = false,
  });

  factory RecommendedDestination.fromJson(Map<String, dynamic> json) {
    return RecommendedDestination(
      id: json['id'] as String,
      title: json['title'] as String,
      location: json['location'] as String,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String? ?? '',
      isSaved: json['isSaved'] as bool? ?? false,
    );
  }

  RecommendedDestination copyWith({bool? isSaved}) {
    return RecommendedDestination(
      id: id,
      title: title,
      location: location,
      category: category,
      imageUrl: imageUrl,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

class InspirationCategory {
  final String id;
  final String title;
  final String icon;

  const InspirationCategory({
    required this.id,
    required this.title,
    required this.icon,
  });

  factory InspirationCategory.fromJson(Map<String, dynamic> json) {
    return InspirationCategory(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String? ?? 'compass',
    );
  }
}

class WeatherPreviewData {
  final String location;
  final int temperature;
  final String condition;
  final int feelsLike;
  final String icon;

  const WeatherPreviewData({
    required this.location,
    required this.temperature,
    required this.condition,
    required this.feelsLike,
    required this.icon,
  });

  factory WeatherPreviewData.fromJson(Map<String, dynamic> json) {
    return WeatherPreviewData(
      location: json['location'] as String,
      temperature: json['temperature'] as int? ?? 25,
      condition: json['condition'] as String? ?? 'Sunny',
      feelsLike: json['feelsLike'] as int? ?? 26,
      icon: json['icon'] as String? ?? 'sun',
    );
  }
}

class RecentActivityItem {
  final String id;
  final String title;
  final String subtitle;
  final String updatedAt;

  const RecentActivityItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.updatedAt,
  });

  factory RecentActivityItem.fromJson(Map<String, dynamic> json) {
    return RecentActivityItem(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }
}

class HomeData {
  final UpcomingTrip? upcomingTrip;
  final List<RecommendedDestination> recommendations;
  final List<InspirationCategory> inspiration;
  final WeatherPreviewData? weather;
  final List<RecentActivityItem> recentActivity;

  const HomeData({
    this.upcomingTrip,
    this.recommendations = const [],
    this.inspiration = const [],
    this.weather,
    this.recentActivity = const [],
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      upcomingTrip: json['upcomingTrip'] != null
          ? UpcomingTrip.fromJson(json['upcomingTrip'] as Map<String, dynamic>)
          : null,
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map((e) => RecommendedDestination.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      inspiration: (json['inspiration'] as List<dynamic>?)
              ?.map((e) => InspirationCategory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      weather: json['weather'] != null
          ? WeatherPreviewData.fromJson(json['weather'] as Map<String, dynamic>)
          : null,
      recentActivity: (json['recentActivity'] as List<dynamic>?)
              ?.map((e) => RecentActivityItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
