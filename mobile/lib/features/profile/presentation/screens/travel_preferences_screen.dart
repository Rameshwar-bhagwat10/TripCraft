import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../../../shared/widgets/chips/app_chip.dart';
import '../../../../shared/widgets/feedback/app_snackbar.dart';
import '../../../onboarding/presentation/widgets/steps/activities_step.dart';
import '../../../onboarding/presentation/widgets/steps/budget_step.dart';
import '../../../onboarding/presentation/widgets/steps/companions_step.dart';
import '../../../onboarding/presentation/widgets/steps/interests_step.dart';
import '../../../onboarding/presentation/widgets/steps/travel_pace_step.dart';
import '../../../onboarding/presentation/widgets/steps/travel_style_step.dart';
import '../../domain/entities/user_preferences_domain.dart';
import '../providers/preferences_provider.dart';

class TravelPreferencesScreen extends ConsumerStatefulWidget {
  const TravelPreferencesScreen({super.key});

  @override
  ConsumerState<TravelPreferencesScreen> createState() => _TravelPreferencesScreenState();
}

class _TravelPreferencesScreenState extends ConsumerState<TravelPreferencesScreen> {
  late UserPreferencesDomain _draftPreferences;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final initial = ref.read(userPreferencesProvider).preferences;
      _draftPreferences = initial;
      _isInitialized = true;
    }
  }

  Future<void> _handleSave() async {
    final success = await ref
        .read(userPreferencesProvider.notifier)
        .savePreferences(_draftPreferences);

    if (success && mounted) {
      AppSnackBar.show(
        context,
        message: 'Travel preferences saved successfully',
        variant: AppSnackBarVariant.success,
      );
      context.pop();
    } else if (mounted) {
      AppSnackBar.show(
        context,
        message: 'Failed to save travel preferences',
        variant: AppSnackBarVariant.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final prefState = ref.watch(userPreferencesProvider);

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.caretLeft, color: AppColors.textPrimary, size: 24),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Travel Preferences',
          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppDimensions.space16),
                    Text('Travel Personalization', style: AppTypography.displaySmall),
                    const SizedBox(height: AppDimensions.space6),
                    Text(
                      'Personalize Tripcraft around how you love to experience destinations.',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppDimensions.space24),

                    // Travel Style Section
                    _buildSectionHeader('TRAVEL STYLES'),
                    Wrap(
                      spacing: AppDimensions.space10,
                      runSpacing: AppDimensions.space12,
                      children: TravelStyleStep.styleIcons.entries.map((entry) {
                        final style = entry.key;
                        final icon = entry.value;
                        final isSelected = _draftPreferences.travelStyles.contains(style);
                        return AppChip(
                          label: style,
                          isSelected: isSelected,
                          icon: Icon(icon),
                          onTap: () {
                            setState(() {
                              final updated = List<String>.from(_draftPreferences.travelStyles);
                              if (isSelected) {
                                updated.remove(style);
                              } else {
                                updated.add(style);
                              }
                              _draftPreferences = _draftPreferences.copyWith(travelStyles: updated);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppDimensions.space28),

                    // Interests Section
                    _buildSectionHeader('INTERESTS'),
                    Wrap(
                      spacing: AppDimensions.space10,
                      runSpacing: AppDimensions.space12,
                      children: InterestsStep.interestIcons.entries.map((entry) {
                        final interest = entry.key;
                        final icon = entry.value;
                        final isSelected = _draftPreferences.interests.contains(interest);
                        return AppChip(
                          label: interest,
                          isSelected: isSelected,
                          icon: Icon(icon),
                          onTap: () {
                            setState(() {
                              final updated = List<String>.from(_draftPreferences.interests);
                              if (isSelected) {
                                updated.remove(interest);
                              } else {
                                updated.add(interest);
                              }
                              _draftPreferences = _draftPreferences.copyWith(interests: updated);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppDimensions.space28),

                    // Budget Level Section
                    _buildSectionHeader('BUDGET LEVEL'),
                    ...BudgetStep.options.map((item) {
                      final title = item['title'] as String;
                      final subtitle = item['subtitle'] as String;
                      final iconData = item['icon'] as IconData;
                      final isSelected = _draftPreferences.budgetLevel == title;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppDimensions.space10),
                        child: AppCard(
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _draftPreferences = _draftPreferences.copyWith(budgetLevel: title);
                            });
                          },
                          child: Row(
                            children: [
                              Icon(iconData, size: 20, color: isSelected ? AppColors.primary : AppColors.textSecondary),
                              const SizedBox(width: AppDimensions.space12),
                              Expanded(
                                child: Text(
                                  '$title — $subtitle',
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  ),
                                ),
                              ),
                              if (isSelected) const Icon(PhosphorIconsBold.check, size: 18, color: AppColors.primary),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: AppDimensions.space28),

                    // Travel Pace Section
                    _buildSectionHeader('TRAVEL PACE'),
                    ...TravelPaceStep.options.map((item) {
                      final title = item['title'] as String;
                      final desc = item['desc'] as String;
                      final iconData = item['icon'] as IconData;
                      final isSelected = _draftPreferences.travelPace == title;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppDimensions.space10),
                        child: AppCard(
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _draftPreferences = _draftPreferences.copyWith(travelPace: title);
                            });
                          },
                          child: Row(
                            children: [
                              Icon(iconData, size: 20, color: isSelected ? AppColors.primary : AppColors.textSecondary),
                              const SizedBox(width: AppDimensions.space12),
                              Expanded(
                                child: Text(
                                  '$title — $desc',
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  ),
                                ),
                              ),
                              if (isSelected) const Icon(PhosphorIconsBold.check, size: 18, color: AppColors.primary),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: AppDimensions.space28),

                    // Companions Section
                    _buildSectionHeader('COMPANIONS'),
                    Wrap(
                      spacing: AppDimensions.space10,
                      runSpacing: AppDimensions.space12,
                      children: CompanionsStep.companionIcons.entries.map((entry) {
                        final companion = entry.key;
                        final icon = entry.value;
                        final isSelected = _draftPreferences.companionTypes.contains(companion);
                        return AppChip(
                          label: companion,
                          isSelected: isSelected,
                          icon: Icon(icon),
                          onTap: () {
                            setState(() {
                              final updated = List<String>.from(_draftPreferences.companionTypes);
                              if (isSelected) {
                                updated.remove(companion);
                              } else {
                                updated.add(companion);
                              }
                              _draftPreferences = _draftPreferences.copyWith(companionTypes: updated);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppDimensions.space28),

                    // Activities Section
                    _buildSectionHeader('ACTIVITIES'),
                    Wrap(
                      spacing: AppDimensions.space10,
                      runSpacing: AppDimensions.space12,
                      children: ActivitiesStep.activityIcons.entries.map((entry) {
                        final activity = entry.key;
                        final icon = entry.value;
                        final isSelected = _draftPreferences.activityPreferences.contains(activity);
                        return AppChip(
                          label: activity,
                          isSelected: isSelected,
                          icon: Icon(icon),
                          onTap: () {
                            setState(() {
                              final updated = List<String>.from(_draftPreferences.activityPreferences);
                              if (isSelected) {
                                updated.remove(activity);
                              } else {
                                updated.add(activity);
                              }
                              _draftPreferences = _draftPreferences.copyWith(activityPreferences: updated);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppDimensions.space32),
                  ],
                ),
              ),
            ),

            // Bottom Sticky CTA
            Container(
              padding: const EdgeInsets.all(AppDimensions.pageMargin),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border, width: 1.0)),
              ),
              child: PrimaryButton(
                label: 'Save Preferences',
                onPressed: prefState.isSaving ? null : _handleSave,
                isLoading: prefState.isSaving,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.space12),
      child: Text(
        title,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.textTertiary,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
