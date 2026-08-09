import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../app/app_colors.dart';
import '../../../../../app/app_dimensions.dart';
import '../../../../../app/app_typography.dart';
import '../../../../../shared/widgets/cards/app_card.dart';
import '../../providers/onboarding_provider.dart';

class TravelPaceStep extends ConsumerWidget {
  const TravelPaceStep({super.key});

  static const options = [
    {
      'title': 'Relaxed',
      'desc': 'More downtime, long meals, and fewer activities per day.',
      'icon': PhosphorIconsRegular.coffee,
    },
    {
      'title': 'Balanced',
      'desc': 'A healthy mix of planned highlights and spontaneous free time.',
      'icon': PhosphorIconsRegular.scales,
    },
    {
      'title': 'Packed',
      'desc': 'Make the absolute most of every hour with non-stop exploration.',
      'icon': PhosphorIconsRegular.lightning,
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("What's your ideal travel pace?", style: AppTypography.displaySmall),
        const SizedBox(height: AppDimensions.space6),
        Text(
          'Select the itinerary pace that matches how you love to experience a destination.',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppDimensions.space24),
        ...options.map((item) {
          final isSelected = state.travelPace == item['title'];
          final IconData iconData = item['icon'] as IconData;

          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.space12),
            child: AppCard(
              isSelected: isSelected,
              onTap: () => notifier.setPace(item['title'] as String),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        const SizedBox(height: 4),
                        Text(
                          item['desc'] as String,
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppDimensions.space8),
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
