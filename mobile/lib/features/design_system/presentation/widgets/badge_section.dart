import 'package:flutter/material.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../shared/layouts/section_layout.dart';
import '../../../../shared/widgets/badges/ai_badge.dart';
import '../../../../shared/widgets/badges/app_badge.dart';
import '../../../../shared/widgets/cards/app_card.dart';

class BadgeSection extends StatelessWidget {
  const BadgeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionLayout(
      title: 'Badges & Avatars',
      subtitle: 'Status indicators, AI tags, and user avatars',
      child: AppCard(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Wrap(
          spacing: AppDimensions.space12,
          runSpacing: AppDimensions.space12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: const [
            AppBadge(label: 'Confirmed', variant: AppBadgeVariant.success),
            AppBadge(label: 'Pending', variant: AppBadgeVariant.warning),
            AppBadge(label: 'Cancelled', variant: AppBadgeVariant.error),
            AppBadge(label: 'Upcoming', variant: AppBadgeVariant.info),
            AppBadge(label: 'Pro Plan', variant: AppBadgeVariant.premium),
            AIBadge(label: 'AI Suggestion'),
          ],
        ),
      ),
    );
  }
}
