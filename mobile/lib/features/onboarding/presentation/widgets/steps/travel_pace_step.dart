import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../app/app_dimensions.dart';
import '../../../../../app/app_typography.dart';
import '../../../../../shared/widgets/cards/app_card.dart';
import '../../providers/onboarding_provider.dart';

class TravelPaceStep extends ConsumerWidget {
  const TravelPaceStep({super.key});

  static const options = [
    {
      'title': 'Relaxed',
      'desc': 'More downtime and fewer activities per day.',
    },
    {
      'title': 'Balanced',
      'desc': 'A healthy mix of planned activities and free time.',
    },
    {
      'title': 'Packed',
      'desc': 'Make the absolute most of every day with non-stop exploration.',
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("What's your ideal travel pace?", style: AppTypography.headlineMedium),
        const SizedBox(height: AppDimensions.space8),
        Text(
          'Select the itinerary pace that feels best for you.',
          style: AppTypography.bodyMedium,
        ),
        const SizedBox(height: AppDimensions.space24),
        ...options.map((item) {
          final isSelected = state.travelPace == item['title'];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.space12),
            child: AppCard(
              isSelected: isSelected,
              onTap: () => notifier.setPace(item['title']!),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['title']!, style: AppTypography.titleMedium),
                  const SizedBox(height: AppDimensions.space4),
                  Text(item['desc']!, style: AppTypography.bodyMedium),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
