import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../app/app_dimensions.dart';
import '../../../../../app/app_typography.dart';
import '../../../../../shared/widgets/cards/app_card.dart';
import '../../providers/onboarding_provider.dart';

class BudgetStep extends ConsumerWidget {
  const BudgetStep({super.key});

  static const options = [
    {'title': 'Budget', 'subtitle': 'Mindful spending & hostels'},
    {'title': 'Moderate', 'subtitle': 'Smart choices & 3-star comfort'},
    {'title': 'Comfortable', 'subtitle': 'Boutique hotels & nice dining'},
    {'title': 'Premium', 'subtitle': 'First class travel & 5-star stays'},
    {'title': 'Luxury', 'subtitle': 'Bespoke experiences & no limits'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("What's your usual travel budget?", style: AppTypography.headlineMedium),
        const SizedBox(height: AppDimensions.space8),
        Text(
          'This helps tailor pricing recommendations.',
          style: AppTypography.bodyMedium,
        ),
        const SizedBox(height: AppDimensions.space24),
        ...options.map((item) {
          final isSelected = state.budgetLevel == item['title'];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.space12),
            child: AppCard(
              isSelected: isSelected,
              onTap: () => notifier.setBudget(item['title']!),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['title']!, style: AppTypography.titleMedium),
                        const SizedBox(height: 2),
                        Text(item['subtitle']!, style: AppTypography.bodySmall),
                      ],
                    ),
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
