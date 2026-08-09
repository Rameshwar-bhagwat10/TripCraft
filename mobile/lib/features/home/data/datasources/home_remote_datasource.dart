import 'package:dio/dio.dart';
import '../../domain/entities/home_data.dart';

abstract class HomeRemoteDataSource {
  Future<HomeData> getHomeData();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio _dio;

  HomeRemoteDataSourceImpl(this._dio);

  @override
  Future<HomeData> getHomeData() async {
    try {
      final response = await _dio.get('/home');
      return HomeData.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      // Fallback fixture if server is unreachable
      return const HomeData(
        upcomingTrip: null,
        recommendations: [
          RecommendedDestination(
            id: 'rec-1',
            title: 'Goa Coastline',
            location: 'Goa, India',
            category: 'Beach & Relaxation',
            imageUrl: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800',
            isSaved: false,
          ),
          RecommendedDestination(
            id: 'rec-2',
            title: 'Munnar Tea Hills',
            location: 'Kerala, India',
            category: 'Nature & Adventure',
            imageUrl: 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=800',
            isSaved: true,
          ),
          RecommendedDestination(
            id: 'rec-3',
            title: 'Manali Valleys',
            location: 'Himachal Pradesh, India',
            category: 'Mountains & Treks',
            imageUrl: 'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?w=800',
            isSaved: false,
          ),
        ],
        inspiration: [
          InspirationCategory(id: 'insp-1', title: 'Weekend Escapes', icon: 'compass'),
          InspirationCategory(id: 'insp-2', title: 'Beach Getaways', icon: 'sun'),
          InspirationCategory(id: 'insp-3', title: 'Mountain Retreats', icon: 'mountains'),
          InspirationCategory(id: 'insp-4', title: 'Cultural Journeys', icon: 'buildings'),
        ],
        weather: WeatherPreviewData(
          location: 'Mumbai, India',
          temperature: 28,
          condition: 'Partly Cloudy',
          feelsLike: 30,
          icon: 'cloud-sun',
        ),
        recentActivity: [
          RecentActivityItem(
            id: 'act-1',
            title: 'Goa Trip Planning',
            subtitle: 'Draft itinerary created',
            updatedAt: '2026-08-09T10:00:00Z',
          ),
        ],
      );
    }
  }
}
