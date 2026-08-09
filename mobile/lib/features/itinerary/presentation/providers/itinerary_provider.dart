import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_providers.dart';
import '../../data/datasources/itinerary_remote_datasource.dart';
import '../../data/repositories/itinerary_repository_impl.dart';
import '../../domain/entities/itinerary.dart';
import '../../domain/repositories/itinerary_repository.dart';

class ItineraryState {
  final bool isLoading;
  final bool isRefreshing;
  final Itinerary? itinerary;
  final int selectedDayIndex;
  final bool isOverviewMode;
  final String? errorMessage;

  const ItineraryState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.itinerary,
    this.selectedDayIndex = 0,
    this.isOverviewMode = false,
    this.errorMessage,
  });

  TripDay? get activeDay {
    if (itinerary == null || itinerary!.days.isEmpty) return null;
    if (selectedDayIndex >= 0 && selectedDayIndex < itinerary!.days.length) {
      return itinerary!.days[selectedDayIndex];
    }
    return itinerary!.days.first;
  }

  List<ItineraryConflict> get activeDayConflicts {
    final day = activeDay;
    if (day == null || day.items.length < 2) return [];

    final timedItems = day.items.where((i) => !i.isAllDay && i.startTime != null && i.endTime != null).toList();
    final conflicts = <ItineraryConflict>[];

    for (int i = 0; i < timedItems.length; i++) {
      for (int j = i + 1; j < timedItems.length; j++) {
        final a = timedItems[i];
        final b = timedItems[j];
        if (_isOverlapping(a.startTime!, a.endTime!, b.startTime!, b.endTime!)) {
          conflicts.add(ItineraryConflict(item1: a, item2: b));
        }
      }
    }
    return conflicts;
  }

  static bool _isOverlapping(String startA, String endA, String startB, String endB) {
    int toMins(String timeStr) {
      final parts = timeStr.split(':');
      if (parts.length < 2) return 0;
      final h = int.tryParse(parts[0]) ?? 0;
      final m = int.tryParse(parts[1]) ?? 0;
      return h * 60 + m;
    }

    final sA = toMins(startA);
    final eA = toMins(endA);
    final sB = toMins(startB);
    final eB = toMins(endB);

    return sA < eB && eA > sB;
  }

  ItineraryState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    Itinerary? itinerary,
    int? selectedDayIndex,
    bool? isOverviewMode,
    String? errorMessage,
  }) {
    return ItineraryState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      itinerary: itinerary ?? this.itinerary,
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
      isOverviewMode: isOverviewMode ?? this.isOverviewMode,
      errorMessage: errorMessage,
    );
  }
}

final itineraryRepositoryProvider = Provider<ItineraryRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final dataSource = ItineraryRemoteDataSourceImpl(apiClient.client);
  return ItineraryRepositoryImpl(dataSource);
});

class ItineraryNotifier extends StateNotifier<ItineraryState> {
  final ItineraryRepository _repository;
  final String tripId;

  ItineraryNotifier(this._repository, this.tripId, [ItineraryState? initialState])
      : super(initialState ?? const ItineraryState()) {
    if (initialState == null) {
      loadItinerary();
    }
  }

  Future<void> loadItinerary({bool isRefresh = false}) async {
    if (isRefresh) {
      state = state.copyWith(isRefreshing: true, errorMessage: null);
    } else {
      state = state.copyWith(isLoading: true, errorMessage: null);
    }

    try {
      final itinerary = await _repository.getItinerary(tripId);
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        itinerary: itinerary,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        errorMessage: 'Unable to load trip itinerary.',
      );
    }
  }

  void selectDay(int index) {
    state = state.copyWith(selectedDayIndex: index);
  }

  void toggleOverviewMode() {
    state = state.copyWith(isOverviewMode: !state.isOverviewMode);
  }

  Future<bool> createActivity(String dayId, Map<String, dynamic> body) async {
    try {
      final newItem = await _repository.createItineraryItem(tripId, dayId, body);
      if (state.itinerary != null) {
        final updatedDays = state.itinerary!.days.map((day) {
          if (day.id == dayId) {
            final updatedItems = [...day.items, newItem];
            return day.copyWith(items: updatedItems);
          }
          return day;
        }).toList();
        state = state.copyWith(itinerary: Itinerary(tripId: tripId, days: updatedDays));
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateActivity(String itemId, Map<String, dynamic> body) async {
    try {
      final updatedItem = await _repository.updateItineraryItem(tripId, itemId, body);
      if (state.itinerary != null) {
        final updatedDays = state.itinerary!.days.map((day) {
          final idx = day.items.indexWhere((i) => i.id == itemId);
          if (idx != -1) {
            final items = [...day.items];
            items[idx] = updatedItem;
            return day.copyWith(items: items);
          }
          return day;
        }).toList();
        state = state.copyWith(itinerary: Itinerary(tripId: tripId, days: updatedDays));
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteActivity(String itemId) async {
    try {
      await _repository.deleteItineraryItem(tripId, itemId);
      if (state.itinerary != null) {
        final updatedDays = state.itinerary!.days.map((day) {
          final items = day.items.where((i) => i.id != itemId).toList();
          return day.copyWith(items: items);
        }).toList();
        state = state.copyWith(itinerary: Itinerary(tripId: tripId, days: updatedDays));
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> moveActivity(String itemId, String targetDayId) async {
    try {
      final movedItem = await _repository.moveItineraryItem(tripId, itemId, targetDayId, 0);
      if (state.itinerary != null) {
        final updatedDays = state.itinerary!.days.map((day) {
          final itemsWithout = day.items.where((i) => i.id != itemId).toList();
          if (day.id == targetDayId) {
            itemsWithout.add(movedItem);
          }
          return day.copyWith(items: itemsWithout);
        }).toList();
        state = state.copyWith(itinerary: Itinerary(tripId: tripId, days: updatedDays));
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> reorderActivities(String dayId, int oldIndex, int newIndex) async {
    final day = state.activeDay;
    if (day == null) return false;

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final items = [...day.items];
    final moved = items.removeAt(oldIndex);
    items.insert(newIndex, moved);

    // Update orderIndex
    final reorderedItems = items.asMap().entries.map((e) => e.value.copyWith(orderIndex: e.key)).toList();

    // Optimistic state update
    final updatedDays = state.itinerary!.days.map((d) {
      if (d.id == dayId) {
        return d.copyWith(items: reorderedItems);
      }
      return d;
    }).toList();
    state = state.copyWith(itinerary: Itinerary(tripId: tripId, days: updatedDays));

    // Async backend save
    final payload = reorderedItems.map((i) => {'id': i.id, 'orderIndex': i.orderIndex}).toList();
    return _repository.reorderItineraryItems(tripId, dayId, payload);
  }

  Future<bool> updateDayTitle(String dayId, String title) async {
    try {
      await _repository.updateTripDay(tripId, dayId, {'title': title});
      if (state.itinerary != null) {
        final updatedDays = state.itinerary!.days.map((d) => d.id == dayId ? d.copyWith(title: title) : d).toList();
        state = state.copyWith(itinerary: Itinerary(tripId: tripId, days: updatedDays));
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}

final itineraryProvider = StateNotifierProvider.family<ItineraryNotifier, ItineraryState, String>((ref, tripId) {
  final repository = ref.watch(itineraryRepositoryProvider);
  return ItineraryNotifier(repository, tripId);
});