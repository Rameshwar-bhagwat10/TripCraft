import 'user_preferences_domain.dart';

/// User Profile Entity for TripCraft.
class UserProfile {
  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;
  final String language;
  final String currency;
  final bool onboardingCompleted;
  final UserPreferencesDomain? preferences;

  const UserProfile({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
    this.language = 'en',
    this.currency = 'USD',
    this.onboardingCompleted = false,
    this.preferences,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      language: json['language'] as String? ?? 'en',
      currency: json['currency'] as String? ?? 'USD',
      onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
      preferences: json['preferences'] != null
          ? UserPreferencesDomain.fromJson(json['preferences'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'avatarUrl': avatarUrl,
      'language': language,
      'currency': currency,
      'onboardingCompleted': onboardingCompleted,
      'preferences': preferences?.toJson(),
    };
  }

  UserProfile copyWith({
    String? id,
    String? email,
    String? fullName,
    String? avatarUrl,
    String? language,
    String? currency,
    bool? onboardingCompleted,
    UserPreferencesDomain? preferences,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      language: language ?? this.language,
      currency: currency ?? this.currency,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      preferences: preferences ?? this.preferences,
    );
  }
}
