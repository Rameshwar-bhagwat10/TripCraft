import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../app/app_colors.dart';
import '../../../../../app/app_dimensions.dart';
import '../../../../../app/app_typography.dart';
import '../../../../../shared/widgets/cards/app_card.dart';
import '../../providers/onboarding_provider.dart';

class BudgetStep extends ConsumerWidget {
  const BudgetStep({super.key});

  static const options = [
    {'title': 'Budget', 'subtitle': 'Mindful spending & hostels', 'icon': PhosphorIconsRegular.coin},
    {'title': 'Moderate', 'subtitle': 'Smart choices & 3-star comfort', 'icon': PhosphorIconsRegular.wallet},
    {'title': 'Comfortable', 'subtitle': 'Boutique hotels & nice dining', 'icon': PhosphorIconsRegular.creditCard},
    {'title': 'Premium', 'subtitle': 'First class travel & 5-star stays', 'icon': PhosphorIconsRegular.airplaneTilt},
    {'title': 'Luxury', 'subtitle': 'Bespoke experiences & no limits', 'icon': PhosphorIconsRegular.crown},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("What's your usual travel budget?", style: AppTypography.displaySmall),
        const SizedBox(height: AppDimensions.space6),
        Text(
          'This helps tailor pricing recommendations and accommodation choices.',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppDimensions.space24),
        ...options.map((item) {
          final isSelected = state.budgetLevel == item['title'];
          final IconData iconData = item['icon'] as IconData;

          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.space12),
            child: AppCard(
              isSelected: isSelected,
              onTap: () => notifier.setBudget(item['title'] as String),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      iconData,
                      size: 22,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.space14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String,
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['subtitle'] as String,
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isSelected ? PhosphorIconsBold.checkCircle : PhosphorIconsRegular.circle,
                    size: 22,
                    color: isSelected ? AppColors.primary : AppColors.textDisabled,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
