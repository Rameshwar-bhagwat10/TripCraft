import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../domain/entities/ai_conversation.dart';

class AiConfirmationSheet extends StatelessWidget {
  final AiActionProposal proposal;
  final VoidCallback onApply;
  final VoidCallback onReject;

  const AiConfirmationSheet({
    super.key,
    required this.proposal,
    required this.onApply,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final riskConfig = ActionRiskLevelConfig.getConfig(proposal.riskLevel);

    return Container(
      padding: EdgeInsets.only(
        top: AppDimensions.space16,
        left: AppDimensions.pageMargin,
        right: AppDimensions.pageMargin,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppDimensions.space24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: AppDimensions.space16),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: riskConfig.color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(riskConfig.icon, color: riskConfig.color, size: 20),
              ),
              const SizedBox(width: AppDimensions.space12),
              Expanded(
                child: Text('Confirm Itinerary Action', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space16),

          Text(proposal.title, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(proposal.description, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppDimensions.space16),

          // Side by Side comparison banner
          Container(
            padding: const EdgeInsets.all(AppDimensions.space14),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(PhosphorIconsRegular.clock, size: 16, color: AppColors.textTertiary),
                    const SizedBox(width: 6),
                    Text('CURRENT SCHEDULE: ', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary)),
                    Expanded(child: Text(proposal.currentValue, style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w700))),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(height: 1, color: AppColors.border),
                ),
                Row(
                  children: [
                    const Icon(PhosphorIconsFill.sparkle, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text('PROPOSED SCHEDULE: ', style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800)),
                    Expanded(child: Text(proposal.proposedValue, style: AppTypography.labelMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.space16),

          Text(
            'Reason: ${proposal.reason}',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: AppDimensions.space24),

          PrimaryButton(
            label: 'Apply Confirmed Action',
            icon: const Icon(PhosphorIconsBold.check, size: 18),
            onPressed: () {
              Navigator.pop(context);
              onApply();
            },
          ),
          const SizedBox(height: AppDimensions.space8),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                onReject();
              },
              child: Text('Keep Current Itinerary', style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary)),
            ),
          ),
        ],
      ),
    );
  }
}
