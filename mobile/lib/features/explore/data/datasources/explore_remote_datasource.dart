import 'package:dio/dio.dart';
import '../../domain/entities/destination.dart';

abstract class ExploreRemoteDataSource {
  Future<List<Destination>> getDestinations(DestinationFilter filter);
  Future<List<Destination>> getFeaturedDestinations();
  Future<List<Destination>> getRecommendedDestinations();
  Future<List<Destination>> getTrendingDestinations();
  Future<Destination> getDestinationById(String id);
  Future<bool> saveDestination(String id);
  Future<bool> unsaveDestination(String id);
  Future<List<Destination>> getSavedDestinations();
}

class ExploreRemoteDataSourceImpl implements ExploreRemoteDataSource {
  final Dio _dio;

  ExploreRemoteDataSourceImpl(this._dio);

  static const List<Destination> _mockDestinations = [
    Destination(
      id: 'dest-goa',
      name: 'Goa',
      slug: 'goa-india',
      city: 'Goa',
      country: 'India',
      region: 'South Asia',
      description: 'A relaxed coastal paradise famous for its golden beaches, seafood, palm trees, Portuguese heritage, and vibrant nightlife.',
      heroImage: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=1200',
      images: [
        'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800',
        'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800',
      ],
      categories: ['Beach', 'Relaxation', 'Food', 'Nightlife'],
      travelStyles: ['Relaxation', 'Nature', 'Culinary'],
      activities: ['Scuba Diving', 'Beach Hopping', 'Portuguese Fort Visit', 'Seafood Cruise'],
      highlights: ['Baga & Palolem Beaches', 'Fontainhas Latin Quarter', 'Dudhsagar Waterfalls'],
      bestTimeToVisit: 'October — March',
      budgetRange: 'Moderate',
      rating: 4.8,
      reviewCount: 340,
      isFeatured: true,
      isTrending: true,
      isSaved: false,
    ),
    Destination(
      id: 'dest-munnar',
      name: 'Munnar Tea Hills',
      slug: 'munnar-kerala-india',
      city: 'Munnar',
      country: 'India',
      region: 'South Asia',
      description: 'Rolling green tea plantations, misty hilltops, cool mountain breeze, and rare wildlife in God’s Own Country.',
      heroImage: 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=1200',
      images: [
        'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=800',
      ],
      categories: ['Mountains', 'Nature', 'Adventure'],
      travelStyles: ['Nature', 'Adventure', 'Wellness'],
      activities: ['Tea Garden Walking', 'Anamudi Peak Trekking', 'Spice Plantation Tour'],
      highlights: ['Tea Museum', 'Eravikulam National Park', 'Mattupetty Dam'],
      bestTimeToVisit: 'September — May',
      budgetRange: 'Budget',
      rating: 4.9,
      reviewCount: 215,
      isFeatured: true,
      isTrending: false,
      isSaved: true,
    ),
    Destination(
      id: 'dest-dubai',
      name: 'Dubai',
      slug: 'dubai-uae',
      city: 'Dubai',
      country: 'United Arab Emirates',
      region: 'Middle East',
      description: 'Futuristic architecture, ultra-luxury shopping, desert safaris, and world-class culinary experiences.',
      heroImage: 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=1200',
      images: [
        'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=800',
      ],
      categories: ['Luxury', 'Culture', 'Food'],
      travelStyles: ['Luxury', 'Shopping', 'Culinary'],
      activities: ['Burj Khalifa View', 'Desert Dune Bashing', 'Dubai Mall Tour'],
      highlights: ['Burj Khalifa', 'Museum of the Future', 'Palm Jumeirah'],
      bestTimeToVisit: 'November — March',
      budgetRange: 'Luxury',
      rating: 4.7,
      reviewCount: 512,
      isFeatured: false,
      isTrending: true,
      isSaved: false,
    ),
    Destination(
      id: 'dest-manali',
      name: 'Manali',
      slug: 'manali-india',
      city: 'Manali',
      country: 'India',
      region: 'South Asia',
      description: 'Snow-capped Himalayan peaks, pine forests, adventure sports, and scenic mountain valleys.',
      heroImage: 'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?w=1200',
      images: [
        'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?w=800',
      ],
      categories: ['Mountains', 'Adventure', 'Nature'],
      travelStyles: ['Adventure', 'Nature', 'Backpacking'],
      activities: ['Solang Valley Paragliding', 'Atal Tunnel Drive', 'Old Manali Cafe Crawl'],
      highlights: ['Solang Valley', 'Hadimba Temple', 'Jogini Waterfalls'],
      bestTimeToVisit: 'October — June',
      budgetRange: 'Moderate',
      rating: 4.8,
      reviewCount: 289,
      isFeatured: false,
      isTrending: true,
      isSaved: false,
    ),
  ];

  @override
  Future<List<Destination>> getDestinations(DestinationFilter filter) async {
    try {
      final queryParams = <String, dynamic>{
        if (filter.search != null) 'search': filter.search,
        if (filter.category != null) 'category': filter.category,
        if (filter.budget != null) 'budget': filter.budget,
        if (filter.travelStyle != null) 'travelStyle': filter.travelStyle,
        if (filter.sort != null) 'sort': filter.sort,
        'page': filter.page,
        'limit': filter.limit,
      };

      final response = await _dio.get('/destinations', queryParameters: queryParams);
      final data = response.data as Map<String, dynamic>;
      final items = data['items'] as List<dynamic>? ?? [];
      return items.map((e) => Destination.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      // Fallback mock filtering
      var results = [..._mockDestinations];
      if (filter.search != null && filter.search!.isNotEmpty) {
        final s = filter.search!.toLowerCase();
        results = results.where((d) =>
          d.name.toLowerCase().contains(s) ||
          d.city.toLowerCase().contains(s) ||
          d.country.toLowerCase().contains(s) ||
          d.categories.any((c) => c.toLowerCase().contains(s))
        ).toList();
      }
      if (filter.category != null && filter.category!.isNotEmpty) {
        results = results.where((d) =>
          d.categories.any((c) => c.toLowerCase() == filter.category!.toLowerCase())
        ).toList();
      }
      return results;
    }
  }

  @override
  Future<List<Destination>> getFeaturedDestinations() async {
    try {
      final response = await _dio.get('/destinations/featured');
      final items = response.data as List<dynamic>;
      return items.map((e) => Destination.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return _mockDestinations.where((d) => d.isFeatured).toList();
    }
  }

  @override
  Future<List<Destination>> getRecommendedDestinations() async {
    try {
      final response = await _dio.get('/destinations/recommended');
      final items = response.data as List<dynamic>;
      return items.map((e) => Destination.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return _mockDestinations;
    }
  }

  @override
  Future<List<Destination>> getTrendingDestinations() async {
    try {
      final response = await _dio.get('/destinations/trending');
      final items = response.data as List<dynamic>;
      return items.map((e) => Destination.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return _mockDestinations.where((d) => d.isTrending).toList();
    }
  }

  @override
  Future<Destination> getDestinationById(String id) async {
    try {
      final response = await _dio.get('/destinations/$id');
      return Destination.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      return _mockDestinations.firstWhere(
        (d) => d.id == id || d.slug == id,
        orElse: () => _mockDestinations.first,
      );
    }
  }

  @override
  Future<bool> saveDestination(String id) async {
    try {
      await _dio.post('/destinations/$id/save');
      return true;
    } catch (_) {
      return true;
    }
  }

  @override
  Future<bool> unsaveDestination(String id) async {
    try {
      await _dio.delete('/destinations/$id/save');
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List<Destination>> getSavedDestinations() async {
    try {
      final response = await _dio.get('/destinations/saved');
      final items = response.data as List<dynamic>;
      return items.map((e) => Destination.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return _mockDestinations.where((d) => d.isSaved).toList();
    }
  }
}
