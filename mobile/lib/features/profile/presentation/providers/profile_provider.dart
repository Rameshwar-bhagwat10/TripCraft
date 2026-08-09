import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_providers.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileState {
  final bool isLoading;
  final bool isUpdating;
  final bool isAvatarUploading;
  final UserProfile? profile;
  final String? errorMessage;

  const ProfileState({
    this.isLoading = false,
    this.isUpdating = false,
    this.isAvatarUploading = false,
    this.profile,
    this.errorMessage,
  });

  ProfileState copyWith({
    bool? isLoading,
    bool? isUpdating,
    bool? isAvatarUploading,
    UserProfile? profile,
    String? errorMessage,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      isAvatarUploading: isAvatarUploading ?? this.isAvatarUploading,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
    );
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final supabase = ref.watch(supabaseClientProvider);
  final dataSource = ProfileRemoteDataSourceImpl(
    dio: apiClient.client,
    supabaseClient: supabase,
  );
  return ProfileRepositoryImpl(dataSource);
});

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepository _repository;

  ProfileNotifier(this._repository, [ProfileState? initialState])
      : super(initialState ?? const ProfileState()) {
    if (initialState == null) {
      fetchProfile();
    }
  }

  Future<void> fetchProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final profile = await _repository.getProfile();
      state = state.copyWith(isLoading: false, profile: profile);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to load profile. Please check your connection.',
      );
    }
  }

  Future<bool> updateProfile({
    String? fullName,
    String? avatarUrl,
    String? language,
    String? currency,
  }) async {
    state = state.copyWith(isUpdating: true, errorMessage: null);
    try {
      final updated = await _repository.updateProfile(
        fullName: fullName,
        avatarUrl: avatarUrl,
        language: language,
        currency: currency,
      );
      state = state.copyWith(isUpdating: false, profile: updated);
      return true;
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        errorMessage: 'Failed to update profile. Please try again.',
      );
      return false;
    }
  }

  Future<bool> uploadAvatar(File imageFile) async {
    if (state.profile == null) return false;
    state = state.copyWith(isAvatarUploading: true, errorMessage: null);
    try {
      final publicUrl = await _repository.uploadAvatar(
        imageFile: imageFile,
        userId: state.profile!.id,
      );
      final updated = await _repository.updateProfile(avatarUrl: publicUrl);
      state = state.copyWith(isAvatarUploading: false, profile: updated);
      return true;
    } catch (e) {
      state = state.copyWith(
        isAvatarUploading: false,
        errorMessage: "Couldn't update your profile photo. Please try again.",
      );
      return false;
    }
  }

  Future<bool> removeAvatar() async {
    if (state.profile == null) return false;
    state = state.copyWith(isAvatarUploading: true, errorMessage: null);
    try {
      await _repository.removeAvatar(userId: state.profile!.id);
      final updated = await _repository.updateProfile(avatarUrl: '');
      state = state.copyWith(isAvatarUploading: false, profile: updated);
      return true;
    } catch (e) {
      state = state.copyWith(
        isAvatarUploading: false,
        errorMessage: 'Failed to remove photo. Please try again.',
      );
      return false;
    }
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return ProfileNotifier(repository);
});