import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_providers.dart';
import '../../../../features/maps/domain/providers/routing_provider.dart';
import '../../domain/services/route_intelligence_service.dart';

class RouteIntelligenceState {
  final bool isLoading;
  final RouteAnalysisData? analysis;
  final OptimizationResultData? optimization;
  final TransportMode selectedTransportMode;
  final String? errorMessage;

  const RouteIntelligenceState({
    this.isLoading = false,
    this.analysis,
    this.optimization,
    this.selectedTransportMode = TransportMode.driving,
    this.errorMessage,
  });

  RouteIntelligenceState copyWith({
    bool? isLoading,
    RouteAnalysisData? analysis,
    OptimizationResultData? optimization,
    TransportMode? selectedTransportMode,
    String? errorMessage,
  }) {
    return RouteIntelligenceState(
      isLoading: isLoading ?? this.isLoading,
      analysis: analysis ?? this.analysis,
      optimization: optimization ?? this.optimization,
      selectedTransportMode: selectedTransportMode ?? this.selectedTransportMode,
      errorMessage: errorMessage,
    );
  }
}

final routeIntelligenceServiceProvider = Provider<RouteIntelligenceService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return RouteIntelligenceService(apiClient.client);
});

class RouteIntelligenceNotifier extends StateNotifier<RouteIntelligenceState> {
  final RouteIntelligenceService _service;
  final String tripId;
  final String dayId;

  RouteIntelligenceNotifier(this._service, this.tripId, this.dayId)
      : super(const RouteIntelligenceState()) {
    analyzeRoute();
  }

  Future<void> analyzeRoute({TransportMode? mode}) async {
    final targetMode = mode ?? state.selectedTransportMode;
    state = state.copyWith(isLoading: true, selectedTransportMode: targetMode, errorMessage: null);

    try {
      final data = await _service.analyzeRoute(tripId, dayId, mode: targetMode);
      final opt = await _service.optimizeRoute(tripId, dayId, mode: targetMode);
      state = state.copyWith(isLoading: false, analysis: data, optimization: opt);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Could not analyze route');
    }
  }

  void setTransportMode(TransportMode mode) {
    analyzeRoute(mode: mode);
  }
}

final routeIntelligenceProvider = StateNotifierProvider.family<RouteIntelligenceNotifier, RouteIntelligenceState, String>((ref, key) {
  final parts = key.split(':');
  final tripId = parts[0];
  final dayId = parts.length > 1 ? parts[1] : 'day-1';
  final service = ref.watch(routeIntelligenceServiceProvider);
  return RouteIntelligenceNotifier(service, tripId, dayId);
});
