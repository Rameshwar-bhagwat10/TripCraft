import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../features/maps/domain/entities/geo_point.dart';

enum PlaceCategory {
  all,
  sightseeing,
  food,
  hotel,
  shopping,
  nature,
  entertainment,
  cafe,
  experience,
}

class PlaceCategoryConfig {
  final PlaceCategory category;
  final String label;
  final IconData icon;

  const PlaceCategoryConfig({
    required this.category,
    required this.label,
    required this.icon,
  });

  static const Map<PlaceCategory, PlaceCategoryConfig> _configs = {
    PlaceCategory.all: PlaceCategoryConfig(category: PlaceCategory.all, label: 'All Places', icon: PhosphorIconsRegular.squaresFour),
    PlaceCategory.sightseeing: PlaceCategoryConfig(category: PlaceCategory.sightseeing, label: 'Sightseeing', icon: PhosphorIconsRegular.binoculars),
    PlaceCategory.food: PlaceCategoryConfig(category: PlaceCategory.food, label: 'Food & Dining', icon: PhosphorIconsRegular.forkKnife),
    PlaceCategory.hotel: PlaceCategoryConfig(category: PlaceCategory.hotel, label: 'Hotels & Stay', icon: PhosphorIconsRegular.bed),
    PlaceCategory.shopping: PlaceCategoryConfig(category: PlaceCategory.shopping, label: 'Shopping', icon: PhosphorIconsRegular.shoppingBag),
    PlaceCategory.nature: PlaceCategoryConfig(category: PlaceCategory.nature, label: 'Nature & Beaches', icon: PhosphorIconsRegular.tree),
    PlaceCategory.entertainment: PlaceCategoryConfig(category: PlaceCategory.entertainment, label: 'Entertainment', icon: PhosphorIconsRegular.ticket),
    PlaceCategory.cafe: PlaceCategoryConfig(category: PlaceCategory.cafe, label: 'Cafes', icon: PhosphorIconsRegular.coffee),
    PlaceCategory.experience: PlaceCategoryConfig(category: PlaceCategory.experience, label: 'Experiences', icon: PhosphorIconsRegular.sparkle),
  };

  static PlaceCategoryConfig getConfig(PlaceCategory cat) {
    return _configs[cat] ?? _configs[PlaceCategory.all]!;
  }

  static PlaceCategory fromString(String str) {
    switch (str.toLowerCase()) {
      case 'sightseeing':
      case 'attractions':
        return PlaceCategory.sightseeing;
      case 'food':
      case 'dining':
        return PlaceCategory.food;
      case 'hotel':
      case 'stay':
        return PlaceCategory.hotel;
      case 'shopping':
        return PlaceCategory.shopping;
      case 'nature':
      case 'beach':
        return PlaceCategory.nature;
      case 'entertainment':
        return PlaceCategory.entertainment;
      case 'cafe':
        return PlaceCategory.cafe;
      case 'experience':
        return PlaceCategory.experience;
      case 'all':
      default:
        return PlaceCategory.all;
    }
  }
}

class Place {
  final String id;
  final String name;
  final PlaceCategory category;
  final String address;
  final GeoPoint location;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final String description;
  final String? openingHours;
  final String? website;
  final String? phone;
  final String? estimatedDuration;
  final bool isSaved;

  const Place({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.description,
    this.openingHours,
    this.website,
    this.phone,
    this.estimatedDuration,
    this.isSaved = false,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] as String,
      name: json['name'] as String,
      category: PlaceCategoryConfig.fromString(json['category'] as String? ?? 'sightseeing'),
      address: json['address'] as String? ?? '',
      location: GeoPoint(
        latitude: (json['latitude'] as num? ?? 15.4989).toDouble(),
        longitude: (json['longitude'] as num? ?? 73.7725).toDouble(),
      ),
      rating: (json['rating'] as num? ?? 4.5).toDouble(),
      reviewCount: json['reviewCount'] as int? ?? 100,
      imageUrl: json['imageUrl'] as String? ?? 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800',
      description: json['description'] as String? ?? '',
      openingHours: json['openingHours'] as String?,
      website: json['website'] as String?,
      phone: json['phone'] as String?,
      estimatedDuration: json['estimatedDuration'] as String?,
      isSaved: json['isSaved'] as bool? ?? false,
    );
  }

  Place copyWith({
    bool? isSaved,
  }) {
    return Place(
      id: id,
      name: name,
      category: category,
      address: address,
      location: location,
      rating: rating,
      reviewCount: reviewCount,
      imageUrl: imageUrl,
      description: description,
      openingHours: openingHours,
      website: website,
      phone: phone,
      estimatedDuration: estimatedDuration,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
