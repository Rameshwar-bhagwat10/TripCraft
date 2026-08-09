/// User Preferences Domain Entity for TripCraft.
class UserPreferencesDomain {
  final List<String> travelStyles;
  final List<String> interests;
  final String budgetLevel;
  final String travelPace;
  final List<String> companionTypes;
  final List<String> activityPreferences;
  final bool reducedMotion;
  final bool largerText;
  final bool highContrast;
  final bool personalizedRecommendations;
  final bool aiPersonalization;
  final bool contextualSuggestions;

  const UserPreferencesDomain({
    this.travelStyles = const [],
    this.interests = const [],
    this.budgetLevel = 'Moderate',
    this.travelPace = 'Balanced',
    this.companionTypes = const [],
    this.activityPreferences = const [],
    this.reducedMotion = false,
    this.largerText = false,
    this.highContrast = false,
    this.personalizedRecommendations = true,
    this.aiPersonalization = true,
    this.contextualSuggestions = true,
  });

  factory UserPreferencesDomain.fromJson(Map<String, dynamic> json) {
    return UserPreferencesDomain(
      travelStyles: (json['travelStyles'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      interests: (json['interests'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      budgetLevel: json['budgetLevel'] as String? ?? 'Moderate',
      travelPace: json['travelPace'] as String? ?? 'Balanced',
      companionTypes: (json['companionTypes'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      activityPreferences: (json['activityPreferences'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      reducedMotion: json['reducedMotion'] as bool? ?? false,
      largerText: json['largerText'] as bool? ?? false,
      highContrast: json['highContrast'] as bool? ?? false,
      personalizedRecommendations: json['personalizedRecommendations'] as bool? ?? true,
      aiPersonalization: json['aiPersonalization'] as bool? ?? true,
      contextualSuggestions: json['contextualSuggestions'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'travelStyles': travelStyles,
      'interests': interests,
      'budgetLevel': budgetLevel,
      'travelPace': travelPace,
      'companionTypes': companionTypes,
      'activityPreferences': activityPreferences,
      'reducedMotion': reducedMotion,
      'largerText': largerText,
      'highContrast': highContrast,
      'personalizedRecommendations': personalizedRecommendations,
      'aiPersonalization': aiPersonalization,
      'contextualSuggestions': contextualSuggestions,
    };
  }

  UserPreferencesDomain copyWith({
    List<String>? travelStyles,
    List<String>? interests,
    String? budgetLevel,
    String? travelPace,
    List<String>? companionTypes,
    List<String>? activityPreferences,
    bool? reducedMotion,
    bool? largerText,
    bool? highContrast,
    bool? personalizedRecommendations,
    bool? aiPersonalization,
    bool? contextualSuggestions,
  }) {
    return UserPreferencesDomain(
      travelStyles: travelStyles ?? this.travelStyles,
      interests: interests ?? this.interests,
      budgetLevel: budgetLevel ?? this.budgetLevel,
      travelPace: travelPace ?? this.travelPace,
      companionTypes: companionTypes ?? this.companionTypes,
      activityPreferences: activityPreferences ?? this.activityPreferences,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      largerText: largerText ?? this.largerText,
      highContrast: highContrast ?? this.highContrast,
      personalizedRecommendations: personalizedRecommendations ?? this.personalizedRecommendations,
      aiPersonalization: aiPersonalization ?? this.aiPersonalization,
      contextualSuggestions: contextualSuggestions ?? this.contextualSuggestions,
    );
  }
}
