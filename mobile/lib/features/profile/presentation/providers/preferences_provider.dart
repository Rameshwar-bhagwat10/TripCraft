import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_preferences_domain.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_provider.dart';

class PreferencesState {
  final bool isLoading;
  final bool isSaving;
  final UserPreferencesDomain preferences;
  final String? errorMessage;

  const PreferencesState({
    this.isLoading = false,
    this.isSaving = false,
    this.preferences = const UserPreferencesDomain(),
    this.errorMessage,
  });

  PreferencesState copyWith({
    bool? isLoading,
    bool? isSaving,
    UserPreferencesDomain? preferences,
    String? errorMessage,
  }) {
    return PreferencesState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      preferences: preferences ?? this.preferences,
      errorMessage: errorMessage,
    );
  }
}

class UserPreferencesNotifier extends StateNotifier<PreferencesState> {
  final ProfileRepository _repository;
  final Ref _ref;

  UserPreferencesNotifier(this._repository, this._ref) : super(const PreferencesState()) {
    initFromProfile();
  }

  void initFromProfile() {
    final profileState = _ref.read(profileProvider);
    if (profileState.profile?.preferences != null) {
      state = state.copyWith(preferences: profileState.profile!.preferences!);
    }
  }

  Future<bool> savePreferences(UserPreferencesDomain updated) async {
    state = state.copyWith(isSaving: true, errorMessage: null);
    try {
      final updatedProfile = await _repository.updatePreferences(updated);
      state = state.copyWith(
        isSaving: false,
        preferences: updatedProfile.preferences ?? updated,
      );
      _ref.read(profileProvider.notifier).fetchProfile();
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Unable to save preferences while offline. Reconnect and try again.',
      );
      return false;
    }
  }

  Future<bool> updateAccessibility({
    bool? reducedMotion,
    bool? largerText,
    bool? highContrast,
  }) async {
    final updated = state.preferences.copyWith(
      reducedMotion: reducedMotion ?? state.preferences.reducedMotion,
      largerText: largerText ?? state.preferences.largerText,
      highContrast: highContrast ?? state.preferences.highContrast,
    );
    return savePreferences(updated);
  }

  Future<bool> updatePersonalization({
    bool? personalizedRecommendations,
    bool? aiPersonalization,
    bool? contextualSuggestions,
  }) async {
    final updated = state.preferences.copyWith(
      personalizedRecommendations: personalizedRecommendations ?? state.preferences.personalizedRecommendations,
      aiPersonalization: aiPersonalization ?? state.preferences.aiPersonalization,
      contextualSuggestions: contextualSuggestions ?? state.preferences.contextualSuggestions,
    );
    return savePreferences(updated);
  }
}

final userPreferencesProvider = StateNotifierProvider<UserPreferencesNotifier, PreferencesState>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return UserPreferencesNotifier(repository, ref);
});
