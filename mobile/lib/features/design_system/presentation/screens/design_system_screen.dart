import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../widgets/ai_copilot_components_section.dart';
import '../widgets/finance_components_section.dart';
import '../widgets/memories_components_section.dart';
import '../widgets/trip_operations_components_section.dart';

class DesignSystemScreen extends StatelessWidget {
  const DesignSystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Tripcraft Design System'),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.pageMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tripcraft UI Kit & Tokens',
              style: AppTypography.displaySmall,
            ),
            const SizedBox(height: AppDimensions.space8),
            Text(
              'Light theme, minimal visual design, soft surfaces, generous whitespace, subtle shadows.',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppDimensions.space24),
            const AiCopilotComponentsSection(),
            const SizedBox(height: AppDimensions.space32),
            const TripOperationsComponentsSection(),
            const SizedBox(height: AppDimensions.space32),
            const FinanceComponentsSection(),
            const SizedBox(height: AppDimensions.space32),
            const MemoriesComponentsSection(),
            const SizedBox(height: AppDimensions.space40),
          ],
        ),
      ),
    );
  }
}
