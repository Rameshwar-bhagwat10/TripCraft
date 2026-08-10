import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_providers.dart';
import '../../domain/services/smart_trip_intelligence_service.dart';

class SmartTripIntelligenceState {
  final bool isLoading;
  final SmartTripIntelligenceData? data;
  final String? errorMessage;

  const SmartTripIntelligenceState({
    this.isLoading = false,
    this.data,
    this.errorMessage,
  });

  SmartTripIntelligenceState copyWith({
    bool? isLoading,
    SmartTripIntelligenceData? data,
    String? errorMessage,
  }) {
    return SmartTripIntelligenceState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      errorMessage: errorMessage,
    );
  }
}

final smartTripIntelligenceServiceProvider = Provider<SmartTripIntelligenceService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SmartTripIntelligenceService(apiClient.client);
});

class SmartTripIntelligenceNotifier extends StateNotifier<SmartTripIntelligenceState> {
  final SmartTripIntelligenceService _service;
  final String tripId;

  SmartTripIntelligenceNotifier(this._service, this.tripId)
      : super(const SmartTripIntelligenceState()) {
    loadIntelligence();
  }

  Future<void> loadIntelligence() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final res = await _service.getTripIntelligence(tripId);
      state = state.copyWith(isLoading: false, data: res);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Could not load trip intelligence');
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    try {
      final res = await _service.refreshIntelligence(tripId);
      state = state.copyWith(isLoading: false, data: res);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final smartTripIntelligenceProvider = StateNotifierProvider.family<SmartTripIntelligenceNotifier, SmartTripIntelligenceState, String>((ref, tripId) {
  final service = ref.watch(smartTripIntelligenceServiceProvider);
  return SmartTripIntelligenceNotifier(service, tripId);
});
