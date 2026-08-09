import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/states/empty_state.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'My Trips',
          style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.pageMargin),
          child: EmptyState(
            title: 'No Trips Planned Yet',
            description: 'Start planning your next getaway with AI itineraries, custom routes, and companion collaboration.',
            icon: PhosphorIconsRegular.suitcase,
            actionLabel: 'Plan a New Trip',
            onAction: () {},
          ),
        ),
      ),
    );
  }
}