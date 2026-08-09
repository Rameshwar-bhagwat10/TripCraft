import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../domain/entities/app_preferences.dart';
import '../providers/preferences_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_row.dart';
import '../widgets/profile_section.dart';
import '../widgets/searchable_selection_sheet.dart';

class AppPreferencesScreen extends ConsumerWidget {
  const AppPreferencesScreen({super.key});

  void _showLanguageSheet(BuildContext context, WidgetRef ref, String currentCode) async {
    final selectedCode = await SearchableSelectionSheet.show<String>(
      context: context,
      title: 'Select Language',
      items: Language.supportedLanguages.map((lang) {
        return SelectionItem<String>(
          value: lang.code,
          title: lang.name,
          subtitle: lang.nativeName,
          leadingText: lang.code.toUpperCase(),
        );
      }).toList(),
      selectedValue: currentCode,
    );

    if (selectedCode != null && selectedCode != currentCode) {
      await ref.read(profileProvider.notifier).updateProfile(language: selectedCode);
    }
  }

  void _showCurrencySheet(BuildContext context, WidgetRef ref, String currentCode) async {
    final selectedCode = await SearchableSelectionSheet.show<String>(
      context: context,
      title: 'Select Currency',
      items: Currency.supportedCurrencies.map((curr) {
        return SelectionItem<String>(
          value: curr.code,
          title: curr.code,
          subtitle: curr.name,
          leadingText: curr.symbol,
        );
      }).toList(),
      selectedValue: currentCode,
    );

    if (selectedCode != null && selectedCode != currentCode) {
      await ref.read(profileProvider.notifier).updateProfile(currency: selectedCode);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final prefState = ref.watch(userPreferencesProvider);
    final prefNotifier = ref.read(userPreferencesProvider.notifier);

    final currentLang = Language.fromCode(profileState.profile?.language ?? 'en');
    final currentCurr = Currency.fromCode(profileState.profile?.currency ?? 'USD');
    final prefs = prefState.preferences;

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.caretLeft, color: AppColors.textPrimary, size: 24),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'App & Personalization',
          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimensions.space16),
              Text('Application Settings', style: AppTypography.displaySmall),
              const SizedBox(height: AppDimensions.space6),
              Text(
                'Configure language, currency, accessibility, and AI personalization.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppDimensions.space24),

              // REGIONAL SECTION
              ProfileSection(
                title: 'REGIONAL & CURRENCY',
                children: [
                  ProfileRow(
                    icon: PhosphorIconsRegular.globe,
                    title: 'Language',
                    value: '${currentLang.name} (${currentLang.code.toUpperCase()})',
                    onTap: () => _showLanguageSheet(context, ref, currentLang.code),
                  ),
                  ProfileRow(
                    icon: PhosphorIconsRegular.currencyDollar,
                    title: 'Currency',
                    value: '${currentCurr.code} (${currentCurr.symbol})',
                    onTap: () => _showCurrencySheet(context, ref, currentCurr.code),
                  ),
                ],
              ),

              // ACCESSIBILITY SECTION
              ProfileSection(
                title: 'ACCESSIBILITY',
                children: [
                  ProfileRow(
                    icon: PhosphorIconsRegular.sparkle,
                    title: 'Reduced Motion',
                    showChevron: false,
                    trailing: Switch(
                      value: prefs.reducedMotion,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) => prefNotifier.updateAccessibility(reducedMotion: val),
                    ),
                  ),
                  ProfileRow(
                    icon: PhosphorIconsRegular.textT,
                    title: 'Larger Text Support',
                    showChevron: false,
                    trailing: Switch(
                      value: prefs.largerText,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) => prefNotifier.updateAccessibility(largerText: val),
                    ),
                  ),
                  ProfileRow(
                    icon: PhosphorIconsRegular.eye,
                    title: 'High Contrast Mode',
                    showChevron: false,
                    trailing: Switch(
                      value: prefs.highContrast,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) => prefNotifier.updateAccessibility(highContrast: val),
                    ),
                  ),
                ],
              ),

              // PERSONALIZATION SECTION
              ProfileSection(
                title: 'PERSONALIZATION & AI',
                children: [
                  ProfileRow(
                    icon: PhosphorIconsRegular.compass,
                    title: 'Personalized Recommendations',
                    showChevron: false,
                    trailing: Switch(
                      value: prefs.personalizedRecommendations,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) => prefNotifier.updatePersonalization(personalizedRecommendations: val),
                    ),
                  ),
                  ProfileRow(
                    icon: PhosphorIconsRegular.magicWand,
                    iconColor: AppColors.aiAccent,
                    title: 'AI Trip Personalization',
                    showChevron: false,
                    trailing: Switch(
                      value: prefs.aiPersonalization,
                      activeThumbColor: AppColors.aiAccent,
                      onChanged: (val) => prefNotifier.updatePersonalization(aiPersonalization: val),
                    ),
                  ),
                  ProfileRow(
                    icon: PhosphorIconsRegular.lightbulb,
                    title: 'Contextual Suggestions',
                    showChevron: false,
                    trailing: Switch(
                      value: prefs.contextualSuggestions,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) => prefNotifier.updatePersonalization(contextualSuggestions: val),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.space24),
            ],
          ),
        ),
      ),
    );
  }
}
