import 'package:dio/dio.dart';
import '../../domain/entities/itinerary.dart';

abstract class ItineraryRemoteDataSource {
  Future<Itinerary> getItinerary(String tripId);
  Future<ItineraryItem> createItineraryItem(String tripId, String dayId, Map<String, dynamic> body);
  Future<ItineraryItem> updateItineraryItem(String tripId, String itemId, Map<String, dynamic> body);
  Future<bool> deleteItineraryItem(String tripId, String itemId);
  Future<bool> reorderItineraryItems(String tripId, String dayId, List<Map<String, dynamic>> items);
  Future<ItineraryItem> moveItineraryItem(String tripId, String itemId, String targetDayId, int newOrderIndex);
  Future<TripDay> updateTripDay(String tripId, String dayId, Map<String, dynamic> body);
}

class ItineraryRemoteDataSourceImpl implements ItineraryRemoteDataSource {
  final Dio _dio;

  ItineraryRemoteDataSourceImpl(this._dio);

  static final Map<String, List<ItineraryItem>> _mockDayItems = {
    'day-1': [
      ItineraryItem(
        id: 'item-1',
        tripDayId: 'day-1',
        title: 'Breakfast at Cafe Bodega',
        description: 'Fresh pastries and filter coffee',
        type: ActivityType.food,
        startTime: '09:00',
        endTime: '10:00',
        duration: '1h',
        orderIndex: 0,
        notes: 'Try avocado toast',
        imageUrl: 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=800',
        createdAt: '2026-08-09T10:00:00Z',
        updatedAt: '2026-08-09T10:00:00Z',
      ),
      ItineraryItem(
        id: 'item-2',
        tripDayId: 'day-1',
        title: 'Explore Fort Aguada',
        description: '17th-century Portuguese lighthouse and fort',
        type: ActivityType.sightseeing,
        startTime: '10:30',
        endTime: '12:30',
        duration: '2h',
        orderIndex: 1,
        notes: 'Great views over Arabian Sea',
        imageUrl: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800',
        createdAt: '2026-08-09T10:00:00Z',
        updatedAt: '2026-08-09T10:00:00Z',
      ),
    ],
  };

  @override
  Future<Itinerary> getItinerary(String tripId) async {
    try {
      final response = await _dio.get('/trips/$tripId/itinerary');
      return Itinerary.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      final days = List.generate(5, (index) {
        final dayId = 'day-${index + 1}';
        final items = _mockDayItems[dayId] ?? [];
        return TripDay(
          id: dayId,
          tripId: tripId,
          date: DateTime.now().add(Duration(days: index + 7)).toIso8601String().split('T').first,
          dayNumber: index + 1,
          title: index == 0 ? 'Old Goa & Heritage' : index == 1 ? 'Beach & Watersports' : 'Day ${index + 1}',
          notes: index == 0 ? 'Carry sunscreen and water' : null,
          items: items,
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
        );
      });
      return Itinerary(tripId: tripId, days: days);
    }
  }

  @override
  Future<ItineraryItem> createItineraryItem(String tripId, String dayId, Map<String, dynamic> body) async {
    try {
      final response = await _dio.post('/trips/$tripId/days/$dayId/items', data: body);
      return ItineraryItem.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      final newItem = ItineraryItem(
        id: 'item-${DateTime.now().millisecondsSinceEpoch}',
        tripDayId: dayId,
        placeId: body['placeId'] as String?,
        title: body['title'] as String? ?? 'Activity',
        description: body['description'] as String?,
        type: ActivityTypeConfig.fromString(body['type'] as String? ?? 'sightseeing'),
        startTime: body['startTime'] as String?,
        endTime: body['endTime'] as String?,
        duration: body['duration'] as String?,
        orderIndex: body['orderIndex'] as int? ?? 0,
        notes: body['notes'] as String?,
        imageUrl: body['imageUrl'] as String? ?? 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800',
        isAllDay: body['isAllDay'] as bool? ?? false,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );
      _mockDayItems.putIfAbsent(dayId, () => []);
      _mockDayItems[dayId]!.add(newItem);
      return newItem;
    }
  }

  @override
  Future<ItineraryItem> updateItineraryItem(String tripId, String itemId, Map<String, dynamic> body) async {
    try {
      final response = await _dio.patch('/trips/$tripId/items/$itemId', data: body);
      return ItineraryItem.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      for (final dayId in _mockDayItems.keys) {
        final items = _mockDayItems[dayId]!;
        final idx = items.indexWhere((i) => i.id == itemId);
        if (idx != -1) {
          final updated = items[idx].copyWith(
            title: body['title'] as String?,
            description: body['description'] as String?,
            type: body['type'] != null ? ActivityTypeConfig.fromString(body['type'] as String) : null,
            startTime: body['startTime'] as String?,
            endTime: body['endTime'] as String?,
            duration: body['duration'] as String?,
            notes: body['notes'] as String?,
            isAllDay: body['isAllDay'] as bool?,
          );
          items[idx] = updated;
          return updated;
        }
      }
      return ItineraryItem(
        id: itemId,
        tripDayId: 'day-1',
        title: body['title'] as String? ?? 'Updated Activity',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );
    }
  }

  @override
  Future<bool> deleteItineraryItem(String tripId, String itemId) async {
    try {
      await _dio.delete('/trips/$tripId/items/$itemId');
    } catch (_) {}
    for (final dayId in _mockDayItems.keys) {
      _mockDayItems[dayId]!.removeWhere((i) => i.id == itemId);
    }
    return true;
  }

  @override
  Future<bool> reorderItineraryItems(String tripId, String dayId, List<Map<String, dynamic>> items) async {
    try {
      await _dio.patch('/trips/$tripId/items/reorder', data: {'dayId': dayId, 'items': items});
      return true;
    } catch (_) {
      return true;
    }
  }

  @override
  Future<ItineraryItem> moveItineraryItem(String tripId, String itemId, String targetDayId, int newOrderIndex) async {
    try {
      final response = await _dio.patch('/trips/$tripId/items/$itemId/move', data: {
        'targetDayId': targetDayId,
        'newOrderIndex': newOrderIndex,
      });
      return ItineraryItem.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      ItineraryItem? found;
      for (final dayId in _mockDayItems.keys) {
        final idx = _mockDayItems[dayId]!.indexWhere((i) => i.id == itemId);
        if (idx != -1) {
          found = _mockDayItems[dayId]!.removeAt(idx);
          break;
        }
      }
      if (found != null) {
        final moved = found.copyWith(tripDayId: targetDayId, orderIndex: newOrderIndex);
        _mockDayItems.putIfAbsent(targetDayId, () => []);
        _mockDayItems[targetDayId]!.add(moved);
        return moved;
      }
      return ItineraryItem(
        id: itemId,
        tripDayId: targetDayId,
        title: 'Moved Item',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );
    }
  }

  @override
  Future<TripDay> updateTripDay(String tripId, String dayId, Map<String, dynamic> body) async {
    try {
      final response = await _dio.patch('/trips/$tripId/days/$dayId', data: body);
      return TripDay.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      return TripDay(
        id: dayId,
        tripId: tripId,
        date: DateTime.now().toIso8601String(),
        dayNumber: 1,
        title: body['title'] as String?,
        notes: body['notes'] as String?,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );
    }
  }
}
