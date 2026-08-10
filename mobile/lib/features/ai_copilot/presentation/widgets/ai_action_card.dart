import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../domain/entities/ai_conversation.dart';

class AiActionCard extends StatelessWidget {
  final AiActionProposal proposal;
  final VoidCallback? onConfirm;

  const AiActionCard({
    super.key,
    required this.proposal,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    const emeraldColor = Color(0xFF10B981);
    final riskConfig = ActionRiskLevelConfig.getConfig(proposal.riskLevel);
    final isApplied = proposal.status == 'applied';

    return Container(
      padding: const EdgeInsets.all(AppDimensions.space14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isApplied ? emeraldColor : riskConfig.color.withValues(alpha: 0.3)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.03),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: (isApplied ? emeraldColor : riskConfig.color).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(isApplied ? PhosphorIconsFill.checkCircle : riskConfig.icon, color: isApplied ? emeraldColor : riskConfig.color, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  proposal.title,
                  style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: (isApplied ? emeraldColor : riskConfig.color).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isApplied ? 'Applied' : riskConfig.label,
                  style: AppTypography.labelSmall.copyWith(
                    color: isApplied ? emeraldColor : riskConfig.color,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space10),

          // Current vs Proposed comparison
          Container(
            padding: const EdgeInsets.all(AppDimensions.space10),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Current: ', style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary, fontSize: 11)),
                    Expanded(child: Text(proposal.currentValue, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600, fontSize: 11))),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('Proposed: ', style: AppTypography.bodySmall.copyWith(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w700)),
                    Expanded(child: Text(proposal.proposedValue, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700, fontSize: 11, color: AppColors.primary))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.space8),

          Text(
            proposal.reason,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11),
          ),
          const SizedBox(height: AppDimensions.space12),

          if (!isApplied)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onConfirm,
                icon: const Icon(PhosphorIconsBold.check, size: 14),
                label: const Text('Review & Apply Changes', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}