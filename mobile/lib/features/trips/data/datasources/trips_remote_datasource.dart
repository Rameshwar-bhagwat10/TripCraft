import 'package:dio/dio.dart';
import '../../domain/entities/trip.dart';

abstract class TripsRemoteDataSource {
  Future<Trip> createTrip(Map<String, dynamic> body);
  Future<List<Trip>> getTrips(TripFilter filter);
  Future<Trip> getTripById(String id);
  Future<Trip> updateTrip(String id, Map<String, dynamic> body);
  Future<Trip> archiveTrip(String id);
  Future<Trip> restoreTrip(String id);
  Future<bool> deleteTrip(String id);
}

class TripsRemoteDataSourceImpl implements TripsRemoteDataSource {
  final Dio _dio;

  TripsRemoteDataSourceImpl(this._dio);

  static final List<Trip> _mockTrips = [
    Trip(
      id: 'trip-goa-escape',
      ownerId: 'user-123',
      destinationId: 'dest-goa',
      title: 'Goa Coastal Escape',
      description: 'A 5-day relaxation and beach hopping trip along South Goa.',
      coverImage: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=1200',
      startDate: '2026-08-21',
      endDate: '2026-08-25',
      status: TripStatus.upcoming,
      travelersCount: 2,
      destination: const TripDestination(
        id: 'dest-goa',
        name: 'Goa',
        city: 'Goa',
        country: 'India',
        heroImage: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=1200',
      ),
      createdAt: '2026-08-09T10:00:00Z',
      updatedAt: '2026-08-09T10:00:00Z',
    ),
  ];

  @override
  Future<Trip> createTrip(Map<String, dynamic> body) async {
    try {
      final response = await _dio.post('/trips', data: body);
      return Trip.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      final newTrip = Trip(
        id: 'trip-${DateTime.now().millisecondsSinceEpoch}',
        ownerId: 'user-123',
        destinationId: body['destinationId'] as String? ?? 'dest-goa',
        title: body['title'] as String? ?? 'New Trip',
        description: body['description'] as String?,
        coverImage: body['coverImage'] as String? ?? 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=1200',
        startDate: body['startDate'] as String? ?? '2026-08-21',
        endDate: body['endDate'] as String? ?? '2026-08-25',
        status: TripStatus.upcoming,
        travelersCount: body['travelersCount'] as int? ?? 1,
        destination: TripDestination(
          id: body['destinationId'] as String? ?? 'dest-goa',
          name: (body['title'] as String? ?? 'Destination').split(' ')[0],
          city: 'Goa',
          country: 'India',
          heroImage: body['coverImage'] as String? ?? 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=1200',
        ),
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );
      _mockTrips.insert(0, newTrip);
      return newTrip;
    }
  }

  @override
  Future<List<Trip>> getTrips(TripFilter filter) async {
    try {
      final queryParams = <String, dynamic>{
        if (filter.status != null) 'status': filter.status,
        'page': filter.page,
        'limit': filter.limit,
      };

      final response = await _dio.get('/trips', queryParameters: queryParams);
      final data = response.data as Map<String, dynamic>;
      final items = data['items'] as List<dynamic>? ?? [];
      return items.map((e) => Trip.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      var results = [..._mockTrips];
      if (filter.status != null) {
        final s = filter.status!.toLowerCase();
        if (s == 'upcoming') {
          results = results.where((t) => t.status == TripStatus.upcoming || t.status == TripStatus.ongoing).toList();
        } else if (s == 'past' || s == 'completed') {
          results = results.where((t) => t.status == TripStatus.completed).toList();
        } else if (s == 'archived') {
          results = results.where((t) => t.status == TripStatus.archived).toList();
        }
      }
      return results;
    }
  }

  @override
  Future<Trip> getTripById(String id) async {
    try {
      final response = await _dio.get('/trips/$id');
      return Trip.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      return _mockTrips.firstWhere(
        (t) => t.id == id,
        orElse: () => _mockTrips.first,
      );
    }
  }

  @override
  Future<Trip> updateTrip(String id, Map<String, dynamic> body) async {
    try {
      final response = await _dio.patch('/trips/$id', data: body);
      return Trip.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      final index = _mockTrips.indexWhere((t) => t.id == id);
      if (index != -1) {
        final existing = _mockTrips[index];
        final updated = existing.copyWith(
          title: body['title'] as String?,
          description: body['description'] as String?,
          startDate: body['startDate'] as String?,
          endDate: body['endDate'] as String?,
          travelersCount: body['travelersCount'] as int?,
          status: body['status'] != null ? TripStatusX.fromString(body['status'] as String) : null,
          coverImage: body['coverImage'] as String?,
        );
        _mockTrips[index] = updated;
        return updated;
      }
      return _mockTrips.first;
    }
  }

  @override
  Future<Trip> archiveTrip(String id) async {
    try {
      final response = await _dio.post('/trips/$id/archive');
      return Trip.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      return updateTrip(id, {'status': 'Archived'});
    }
  }

  @override
  Future<Trip> restoreTrip(String id) async {
    try {
      final response = await _dio.post('/trips/$id/restore');
      return Trip.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      return updateTrip(id, {'status': 'Upcoming'});
    }
  }

  @override
  Future<bool> deleteTrip(String id) async {
    try {
      await _dio.delete('/trips/$id');
      _mockTrips.removeWhere((t) => t.id == id);
      return true;
    } catch (_) {
      _mockTrips.removeWhere((t) => t.id == id);
      return true;
    }
  }
}
