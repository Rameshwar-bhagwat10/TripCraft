import 'geo_point.dart';

enum MarkerType {
  itinerary,
  searchResult,
  savedPlace,
  currentLocation,
}

class MapMarker {
  final String id;
  final String title;
  final GeoPoint position;
  final MarkerType type;
  final int? sequenceNumber;
  final String? category;
  final bool isSelected;

  const MapMarker({
    required this.id,
    required this.title,
    required this.position,
    this.type = MarkerType.itinerary,
    this.sequenceNumber,
    this.category,
    this.isSelected = false,
  });

  MapMarker copyWith({
    bool? isSelected,
  }) {
    return MapMarker(
      id: id,
      title: title,
      position: position,
      type: type,
      sequenceNumber: sequenceNumber,
      category: category,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
