import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';

class OnboardingState {
  final int currentStep;
  final List<String> travelStyles;
  final List<String> interests;
  final String budgetLevel;
  final String travelPace;
  final List<String> companionTypes;
  final List<String> activityPreferences;
  final bool isSubmitting;
  final String? error;

  const OnboardingState({
    this.currentStep = 1,
    this.travelStyles = const [],
    this.interests = const [],
    this.budgetLevel = 'Moderate',
    this.travelPace = 'Balanced',
    this.companionTypes = const [],
    this.activityPreferences = const [],
    this.isSubmitting = false,
    this.error,
  });

  OnboardingState copyWith({
    int? currentStep,
    List<String>? travelStyles,
    List<String>? interests,
    String? budgetLevel,
    String? travelPace,
    List<String>? companionTypes,
    List<String>? activityPreferences,
    bool? isSubmitting,
    String? error,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      travelStyles: travelStyles ?? this.travelStyles,
      interests: interests ?? this.interests,
      budgetLevel: budgetLevel ?? this.budgetLevel,
      travelPace: travelPace ?? this.travelPace,
      companionTypes: companionTypes ?? this.companionTypes,
      activityPreferences: activityPreferences ?? this.activityPreferences,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier(ref);
});

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final Ref _ref;

  OnboardingNotifier(this._ref) : super(const OnboardingState());

  void setStep(int step) {
    if (step >= 1 && step <= 8) {
      state = state.copyWith(currentStep: step);
    }
  }

  void nextStep() {
    if (state.currentStep < 8) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void toggleTravelStyle(String style) {
    final list = List<String>.from(state.travelStyles);
    if (list.contains(style)) {
      list.remove(style);
    } else {
      list.add(style);
    }
    state = state.copyWith(travelStyles: list);
  }

  void toggleInterest(String interest) {
    final list = List<String>.from(state.interests);
    if (list.contains(interest)) {
      list.remove(interest);
    } else {
      list.add(interest);
    }
    state = state.copyWith(interests: list);
  }

  void setBudget(String budget) {
    state = state.copyWith(budgetLevel: budget);
  }

  void setPace(String pace) {
    state = state.copyWith(travelPace: pace);
  }

  void toggleCompanion(String companion) {
    final list = List<String>.from(state.companionTypes);
    if (list.contains(companion)) {
      list.remove(companion);
    } else {
      list.add(companion);
    }
    state = state.copyWith(companionTypes: list);
  }

  void toggleActivity(String activity) {
    final list = List<String>.from(state.activityPreferences);
    if (list.contains(activity)) {
      list.remove(activity);
    } else {
      list.add(activity);
    }
    state = state.copyWith(activityPreferences: list);
  }

  Future<bool> completeOnboarding() async {
    state = state.copyWith(isSubmitting: true, error: null);
    try {
      final repository = _ref.read(authRepositoryProvider);
      await repository.saveUserPreferences(
        travelStyles: state.travelStyles,
        interests: state.interests,
        budgetLevel: state.budgetLevel,
        travelPace: state.travelPace,
        companionTypes: state.companionTypes,
        activityPreferences: state.activityPreferences,
      );

      _ref.read(authProvider.notifier).markOnboardingComplete();
      state = state.copyWith(isSubmitting: false);
      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Error completing onboarding', e, stackTrace);
      // Fallback if NestJS endpoint offline
      _ref.read(authProvider.notifier).markOnboardingComplete();
      state = state.copyWith(isSubmitting: false);
      return true;
    }
  }
}