import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../domain/entities/settlement.dart';

class TravelerBalanceCard extends StatelessWidget {
  final TravelerBalance balance;

  const TravelerBalanceCard({
    super.key,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    final isOwed = balance.netBalance >= 0;
    final balanceColor = isOwed ? const Color(0xFF10B981) : AppColors.error;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.space14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primarySurface,
                child: Text(balance.travelerName[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: AppDimensions.space12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(balance.travelerName, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700)),
                  Text(
                    'Paid ₹${balance.totalPaid.toStringAsFixed(0)} · Share ₹${balance.totalShare.toStringAsFixed(0)}',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Icon(isOwed ? PhosphorIconsFill.arrowDownLeft : PhosphorIconsFill.arrowUpRight, size: 16, color: balanceColor),
              const SizedBox(width: 4),
              Text(
                '${isOwed ? '+' : ''}₹${balance.netBalance.abs().toStringAsFixed(0)}',
                style: AppTypography.titleMedium.copyWith(color: balanceColor, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
