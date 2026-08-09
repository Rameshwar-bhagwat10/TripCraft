import 'package:dio/dio.dart';
import '../../../../features/maps/domain/entities/geo_point.dart';
import '../../domain/entities/place.dart';

abstract class PlacesRemoteDataSource {
  Future<List<Place>> searchPlaces({String? query, String? category});
  Future<Place> getPlaceDetails(String id);
  Future<bool> toggleSavePlace(String id);
}

class PlacesRemoteDataSourceImpl implements PlacesRemoteDataSource {
  final Dio _dio;

  PlacesRemoteDataSourceImpl(this._dio);

  static final List<Place> _mockPlaces = [
    Place(
      id: 'place-fort',
      name: 'Fort Aguada',
      category: PlaceCategory.sightseeing,
      address: 'Sinquerim, Candolim, Goa 403515',
      location: const GeoPoint(latitude: 15.4989, longitude: 73.7725),
      rating: 4.7,
      reviewCount: 3420,
      imageUrl: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800',
      description: '17th-century Portuguese lighthouse and fort overlooking the Arabian Sea.',
      openingHours: '09:30 AM - 06:00 PM',
      website: 'https://goatourism.gov.in',
      phone: '+91 832 243 8593',
      estimatedDuration: '2h',
      isSaved: true,
    ),
    Place(
      id: 'place-brittos',
      name: 'Brittos Restaurant & Shack',
      category: PlaceCategory.food,
      address: 'Baga Beach, Calangute, Goa 403516',
      location: const GeoPoint(latitude: 15.5553, longitude: 73.7517),
      rating: 4.5,
      reviewCount: 2890,
      imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
      description: 'Iconic beach shack offering fresh seafood, Goan curries, and live music.',
      openingHours: '08:30 AM - 11:30 PM',
      website: 'https://brittosgoa.com',
      phone: '+91 832 227 7339',
      estimatedDuration: '1h 30m',
      isSaved: false,
    ),
    Place(
      id: 'place-basilica',
      name: 'Basilica of Bom Jesus',
      category: PlaceCategory.sightseeing,
      address: 'Old Goa Road, Bainguinim, Goa 403402',
      location: const GeoPoint(latitude: 15.5009, longitude: 73.9116),
      rating: 4.8,
      reviewCount: 4120,
      imageUrl: 'https://images.unsplash.com/photo-1548013146-72479768bada?w=800',
      description: 'UNESCO World Heritage Site holding the mortal remains of St. Francis Xavier.',
      openingHours: '09:00 AM - 06:30 PM',
      website: 'https://bomjesus.org',
      phone: '+91 832 228 5790',
      estimatedDuration: '1h 30m',
      isSaved: true,
    ),
    Place(
      id: 'place-baga-beach',
      name: 'Baga Beach Watersports',
      category: PlaceCategory.nature,
      address: 'Baga, North Goa 403516',
      location: const GeoPoint(latitude: 15.5528, longitude: 73.7523),
      rating: 4.6,
      reviewCount: 1980,
      imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
      description: 'Vibrant beach famous for parasailing, banana rides, and sunset views.',
      openingHours: '24 Hours',
      website: 'https://goatourism.gov.in',
      estimatedDuration: '3h',
      isSaved: false,
    ),
  ];

  @override
  Future<List<Place>> searchPlaces({String? query, String? category}) async {
    try {
      final response = await _dio.get('/places/search', queryParameters: {
        if (query != null && query.isNotEmpty) 'query': query,
        if (category != null && category != 'all') 'category': category,
      });
      return (response.data as List<dynamic>).map((e) => Place.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      var list = [..._mockPlaces];
      if (category != null && category.toLowerCase() != 'all') {
        list = list.where((p) => p.category.name.toLowerCase() == category.toLowerCase()).toList();
      }
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        list = list.where((p) => p.name.toLowerCase().contains(q) || p.description.toLowerCase().contains(q)).toList();
      }
      return list;
    }
  }

  @override
  Future<Place> getPlaceDetails(String id) async {
    try {
      final response = await _dio.get('/places/$id');
      return Place.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      final found = _mockPlaces.firstWhere((p) => p.id == id, orElse: () => _mockPlaces.first);
      return found;
    }
  }

  @override
  Future<bool> toggleSavePlace(String id) async {
    try {
      final response = await _dio.post('/places/$id/save');
      return response.data['isSaved'] as bool? ?? true;
    } catch (_) {
      return true;
    }
  }
}
