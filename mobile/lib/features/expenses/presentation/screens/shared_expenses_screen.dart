import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/feedback/app_snackbar.dart';
import '../providers/trip_finance_provider.dart';
import '../widgets/traveler_balance_card.dart';

class SharedExpensesScreen extends ConsumerWidget {
  final String tripId;

  const SharedExpensesScreen({
    super.key,
    required this.tripId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tripFinanceProvider(tripId));

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Shared Balances & Settlements', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.pageMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TRAVELER NET BALANCES', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
              const SizedBox(height: AppDimensions.space10),

              ...state.balances.map((b) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.space10),
                  child: TravelerBalanceCard(balance: b),
                );
              }),

              const SizedBox(height: AppDimensions.space24),

              Text('SUGGESTED SETTLEMENT TRANSACTIONS', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
              const SizedBox(height: AppDimensions.space10),

              if (state.settlements.isEmpty)
                Text('All travelers are currently settled.', style: AppTypography.bodyMedium)
              else
                ...state.settlements.map((s) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.space10),
                    child: Container(
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
                              const Icon(PhosphorIconsFill.arrowRight, size: 18, color: AppColors.primary),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${s.payerName} → ${s.receiverName}', style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700)),
                                  Text(
                                    s.isSettled ? 'Settled' : 'Pending transfer',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: s.isSettled ? const Color(0xFF10B981) : Colors.orange,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('₹${s.amount.toStringAsFixed(0)}', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800)),
                              const SizedBox(width: 12),
                              if (!s.isSettled)
                                ElevatedButton(
                                  onPressed: () async {
                                    await ref.read(tripFinanceProvider(tripId).notifier).markSettlementComplete(s.id);
                                    if (context.mounted) {
                                      AppSnackBar.show(context, message: 'Settlement marked as complete');
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF10B981),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('Mark Settled', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}
