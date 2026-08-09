import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/feedback/app_snackbar.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../domain/entities/app_preferences.dart';
import '../providers/preferences_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_row.dart';
import '../widgets/profile_section.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showAvatarOptionsSheet(BuildContext context, WidgetRef ref) {
    final profileNotifier = ref.read(profileProvider.notifier);
    final hasAvatar = ref.read(profileProvider).profile?.avatarUrl != null &&
        ref.read(profileProvider).profile!.avatarUrl!.trim().isNotEmpty;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: AppDimensions.space12),
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderStrong,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: AppDimensions.space16),
                Text(
                  'Profile Photo',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppDimensions.space16),
                ListTile(
                  leading: const Icon(PhosphorIconsRegular.image, color: AppColors.primary),
                  title: const Text('Choose from Gallery'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final picker = ImagePicker();
                    final picked = await picker.pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 800,
                      maxHeight: 800,
                      imageQuality: 85,
                    );
                    if (picked != null) {
                      final file = File(picked.path);
                      final success = await profileNotifier.uploadAvatar(file);
                      if (context.mounted && success) {
                        AppSnackBar.show(
                          context,
                          message: 'Profile photo updated!',
                          variant: AppSnackBarVariant.success,
                        );
                      }
                    }
                  },
                ),
                if (hasAvatar)
                  ListTile(
                    leading: const Icon(PhosphorIconsRegular.trash, color: AppColors.error),
                    title: const Text('Remove Photo', style: TextStyle(color: AppColors.error)),
                    onTap: () async {
                      Navigator.of(context).pop();
                      final success = await profileNotifier.removeAvatar();
                      if (context.mounted && success) {
                        AppSnackBar.show(
                          context,
                          message: 'Profile photo removed',
                          variant: AppSnackBarVariant.info,
                        );
                      }
                    },
                  ),
                const SizedBox(height: AppDimensions.space8),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final prefState = ref.watch(userPreferencesProvider);
    final user = profileState.profile;

    final lang = Language.fromCode(user?.language ?? 'en');
    final curr = Currency.fromCode(user?.currency ?? 'USD');
    final prefs = prefState.preferences;

    final travelStyleSummary = prefs.travelStyles.isNotEmpty
        ? prefs.travelStyles.take(2).join(', ')
        : 'Not set';

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Profile',
          style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(profileProvider.notifier).fetchProfile(),
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.space16),

                // Header
                ProfileHeader(
                  avatarUrl: user?.avatarUrl,
                  fullName: user?.fullName ?? 'Traveler',
                  email: user?.email ?? '',
                  isAvatarUploading: profileState.isAvatarUploading,
                  onAvatarTap: () => _showAvatarOptionsSheet(context, ref),
                  onEditProfileTap: () => context.push('/profile/edit'),
                ),
                const SizedBox(height: AppDimensions.space28),

                // Personal Info Section
                ProfileSection(
                  title: 'PERSONAL INFORMATION',
                  children: [
                    ProfileRow(
                      icon: PhosphorIconsRegular.user,
                      title: 'Personal Details',
                      value: user?.fullName ?? 'Set Name',
                      onTap: () => context.push('/profile/edit'),
                    ),
                  ],
                ),

                // Travel Preferences Section
                ProfileSection(
                  title: 'TRAVEL PREFERENCES',
                  children: [
                    ProfileRow(
                      icon: PhosphorIconsRegular.compass,
                      title: 'Travel Styles & Interests',
                      value: travelStyleSummary,
                      onTap: () => context.push('/profile/travel-preferences'),
                    ),
                    ProfileRow(
                      icon: PhosphorIconsRegular.wallet,
                      title: 'Budget Level',
                      value: prefs.budgetLevel,
                      onTap: () => context.push('/profile/travel-preferences'),
                    ),
                    ProfileRow(
                      icon: PhosphorIconsRegular.scales,
                      title: 'Travel Pace',
                      value: prefs.travelPace,
                      onTap: () => context.push('/profile/travel-preferences'),
                    ),
                  ],
                ),

                // App Preferences Section
                ProfileSection(
                  title: 'APPLICATION & PERSONALIZATION',
                  children: [
                    ProfileRow(
                      icon: PhosphorIconsRegular.globe,
                      title: 'Language',
                      value: lang.name,
                      onTap: () => context.push('/profile/app-preferences'),
                    ),
                    ProfileRow(
                      icon: PhosphorIconsRegular.currencyDollar,
                      title: 'Currency',
                      value: '${curr.code} (${curr.symbol})',
                      onTap: () => context.push('/profile/app-preferences'),
                    ),
                    ProfileRow(
                      icon: PhosphorIconsRegular.sliders,
                      title: 'Accessibility & AI Settings',
                      value: 'Configured',
                      onTap: () => context.push('/profile/app-preferences'),
                    ),
                  ],
                ),

                // Account Section
                ProfileSection(
                  title: 'ACCOUNT',
                  children: [
                    ProfileRow(
                      icon: PhosphorIconsRegular.signOut,
                      iconColor: AppColors.error,
                      title: 'Sign Out',
                      showChevron: false,
                      onTap: () => ref.read(authProvider.notifier).logout(),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.space32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}