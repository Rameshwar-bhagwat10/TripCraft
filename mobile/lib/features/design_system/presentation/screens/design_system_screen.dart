import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../widgets/badge_section.dart';
import '../widgets/button_section.dart';
import '../widgets/card_section.dart';
import '../widgets/chip_section.dart';
import '../widgets/color_section.dart';
import '../widgets/dialog_section.dart';
import '../widgets/explore_components_section.dart';
import '../widgets/home_components_section.dart';
import '../widgets/icon_section.dart';
import '../widgets/input_section.dart';
import '../widgets/itinerary_components_section.dart';
import '../widgets/motion_section.dart';
import '../widgets/profile_components_section.dart';
import '../widgets/spacing_section.dart';
import '../widgets/state_section.dart';
import '../widgets/trip_components_section.dart';
import '../widgets/typography_section.dart';

/// Development-only Design System Showcase Screen for TripCraft.
class DesignSystemScreen extends StatelessWidget {
  const DesignSystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('TripCraft Design System'),
            Text(
              'Development Showcase & Component Reference',
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.pageMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ColorSection(),
            TypographySection(),
            ButtonSection(),
            InputSection(),
            CardSection(),
            ChipSection(),
            ItineraryComponentsSection(),
            TripComponentsSection(),
            ExploreComponentsSection(),
            HomeComponentsSection(),
            ProfileComponentsSection(),
            BadgeSection(),
            StateSection(),
            DialogSection(),
            SpacingSection(),
            IconSection(),
            MotionSection(),
            SizedBox(height: AppDimensions.space48),
          ],
        ),
      ),
    );
  }
}
