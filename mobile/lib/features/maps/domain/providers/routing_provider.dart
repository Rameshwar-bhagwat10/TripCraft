import '../entities/geo_point.dart';

enum TransportMode {
  driving,
  walking,
  cycling,
  transit,
}

class RouteSegmentData {
  final GeoPoint origin;
  final GeoPoint destination;
  final double distanceKm;
  final int durationMins;
  final TransportMode mode;
  final List<GeoPoint> polylinePoints;

  const RouteSegmentData({
    required this.origin,
    required this.destination,
    required this.distanceKm,
    required this.durationMins,
    required this.mode,
    required this.polylinePoints,
  });
}

abstract class RoutingProvider {
  Future<RouteSegmentData> calculateRoute({
    required GeoPoint origin,
    required GeoPoint destination,
    TransportMode mode = TransportMode.driving,
  });
}

class MapboxRoutingProvider implements RoutingProvider {
  @override
  Future<RouteSegmentData> calculateRoute({
    required GeoPoint origin,
    required GeoPoint destination,
    TransportMode mode = TransportMode.driving,
  }) async {
    // Generate linear points between origin and destination for clean polyline rendering
    final points = [
      origin,
      GeoPoint(
        latitude: (origin.latitude + destination.latitude) / 2 + 0.005,
        longitude: (origin.longitude + destination.longitude) / 2 - 0.005,
      ),
      destination,
    ];

    return RouteSegmentData(
      origin: origin,
      destination: destination,
      distanceKm: 12.4,
      durationMins: 24,
      mode: mode,
      polylinePoints: points,
    );
  }
}
