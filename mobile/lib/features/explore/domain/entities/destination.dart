class ActivityItem {
  final String id;
  final String title;
  final String category;
  final String? imageUrl;

  const ActivityItem({
    required this.id,
    required this.title,
    required this.category,
    this.imageUrl,
  });

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    return ActivityItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      imageUrl: json['imageUrl'] as String?,
    );
  }
}

class Destination {
  final String id;
  final String name;
  final String slug;
  final String city;
  final String country;
  final String region;
  final String description;
  final String heroImage;
  final List<String> images;
  final List<String> categories;
  final List<String> travelStyles;
  final List<String> activities;
  final List<String> highlights;
  final String? bestTimeToVisit;
  final String budgetRange;
  final double? latitude;
  final double? longitude;
  final double rating;
  final int reviewCount;
  final bool isFeatured;
  final bool isTrending;
  final bool isSaved;

  const Destination({
    required this.id,
    required this.name,
    required this.slug,
    required this.city,
    required this.country,
    required this.region,
    required this.description,
    required this.heroImage,
    this.images = const [],
    this.categories = const [],
    this.travelStyles = const [],
    this.activities = const [],
    this.highlights = const [],
    this.bestTimeToVisit,
    this.budgetRange = 'Moderate',
    this.latitude,
    this.longitude,
    this.rating = 4.8,
    this.reviewCount = 120,
    this.isFeatured = false,
    this.isTrending = false,
    this.isSaved = false,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String? ?? json['id'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      region: json['region'] as String? ?? '',
      description: json['description'] as String? ?? '',
      heroImage: json['heroImage'] as String? ?? '',
      images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      categories: (json['categories'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      travelStyles: (json['travelStyles'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      activities: (json['activities'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      highlights: (json['highlights'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      bestTimeToVisit: json['bestTimeToVisit'] as String?,
      budgetRange: json['budgetRange'] as String? ?? 'Moderate',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      reviewCount: json['reviewCount'] as int? ?? 120,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isTrending: json['isTrending'] as bool? ?? false,
      isSaved: json['isSaved'] as bool? ?? false,
    );
  }

  Destination copyWith({bool? isSaved}) {
    return Destination(
      id: id,
      name: name,
      slug: slug,
      city: city,
      country: country,
      region: region,
      description: description,
      heroImage: heroImage,
      images: images,
      categories: categories,
      travelStyles: travelStyles,
      activities: activities,
      highlights: highlights,
      bestTimeToVisit: bestTimeToVisit,
      budgetRange: budgetRange,
      latitude: latitude,
      longitude: longitude,
      rating: rating,
      reviewCount: reviewCount,
      isFeatured: isFeatured,
      isTrending: isTrending,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

class DestinationFilter {
  final String? search;
  final String? category;
  final String? budget;
  final String? travelStyle;
  final String? sort;
  final int page;
  final int limit;

  const DestinationFilter({
    this.search,
    this.category,
    this.budget,
    this.travelStyle,
    this.sort,
    this.page = 1,
    this.limit = 20,
  });

  DestinationFilter copyWith({
    String? search,
    String? category,
    String? budget,
    String? travelStyle,
    String? sort,
    int? page,
    int? limit,
  }) {
    return DestinationFilter(
      search: search ?? this.search,
      category: category ?? this.category,
      budget: budget ?? this.budget,
      travelStyle: travelStyle ?? this.travelStyle,
      sort: sort ?? this.sort,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  bool get hasActiveFilters =>
      (category != null && category!.isNotEmpty) ||
      (budget != null && budget!.isNotEmpty) ||
      (travelStyle != null && travelStyle!.isNotEmpty) ||
      (sort != null && sort!.isNotEmpty);
}
