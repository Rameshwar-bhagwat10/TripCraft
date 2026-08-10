import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_providers.dart';
import '../../data/datasources/trip_operations_remote_datasource.dart';
import '../../data/repositories/trip_operations_repository_impl.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/travel_document.dart';

class TripOperationsState {
  final bool isLoading;
  final TripOperationsSummary? summary;
  final List<Booking> bookings;
  final List<TravelDocument> documents;
  final String? errorMessage;

  const TripOperationsState({
    this.isLoading = false,
    this.summary,
    this.bookings = const [],
    this.documents = const [],
    this.errorMessage,
  });

  TripOperationsState copyWith({
    bool? isLoading,
    TripOperationsSummary? summary,
    List<Booking>? bookings,
    List<TravelDocument>? documents,
    String? errorMessage,
  }) {
    return TripOperationsState(
      isLoading: isLoading ?? this.isLoading,
      summary: summary ?? this.summary,
      bookings: bookings ?? this.bookings,
      documents: documents ?? this.documents,
      errorMessage: errorMessage,
    );
  }
}

final tripOperationsRepositoryProvider = Provider<TripOperationsRepositoryImpl>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final ds = TripOperationsRemoteDataSourceImpl(apiClient.client);
  return TripOperationsRepositoryImpl(ds);
});

class TripOperationsNotifier extends StateNotifier<TripOperationsState> {
  final TripOperationsRepositoryImpl _repository;
  final String tripId;

  TripOperationsNotifier(this._repository, this.tripId) : super(const TripOperationsState()) {
    loadOperations();
  }

  Future<void> loadOperations() async {
    state = state.copyWith(isLoading: true);
    try {
      final [summary, bookings, docs] = await Future.wait([
        _repository.getOperationsSummary(tripId),
        _repository.getBookings(tripId),
        _repository.getDocuments(tripId),
      ]);

      state = state.copyWith(
        isLoading: false,
        summary: summary as TripOperationsSummary,
        bookings: bookings as List<Booking>,
        documents: docs as List<TravelDocument>,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false, errorMessage: 'Failed to load trip operations.');
    }
  }

  Future<void> createBooking(Map<String, dynamic> body) async {
    final newBooking = await _repository.createBooking(tripId, body);
    state = state.copyWith(bookings: [...state.bookings, newBooking]);
    loadOperations();
  }

  Future<void> createDocument(Map<String, dynamic> body) async {
    final newDoc = await _repository.createDocument(tripId, body);
    state = state.copyWith(documents: [...state.documents, newDoc]);
    loadOperations();
  }
}

final tripOperationsProvider = StateNotifierProvider.family<TripOperationsNotifier, TripOperationsState, String>((ref, tripId) {
  final repo = ref.watch(tripOperationsRepositoryProvider);
  return TripOperationsNotifier(repo, tripId);
});
