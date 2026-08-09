import '../entities/itinerary.dart';

abstract class ItineraryRepository {
  Future<Itinerary> getItinerary(String tripId);
  Future<ItineraryItem> createItineraryItem(String tripId, String dayId, Map<String, dynamic> body);
  Future<ItineraryItem> updateItineraryItem(String tripId, String itemId, Map<String, dynamic> body);
  Future<bool> deleteItineraryItem(String tripId, String itemId);
  Future<bool> reorderItineraryItems(String tripId, String dayId, List<Map<String, dynamic>> items);
  Future<ItineraryItem> moveItineraryItem(String tripId, String itemId, String targetDayId, int newOrderIndex);
  Future<TripDay> updateTripDay(String tripId, String dayId, Map<String, dynamic> body);
}
