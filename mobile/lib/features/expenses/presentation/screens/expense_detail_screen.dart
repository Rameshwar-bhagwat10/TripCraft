import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/feedback/app_snackbar.dart';
import '../../domain/entities/expense.dart';
import '../providers/trip_finance_provider.dart';

class ExpenseDetailScreen extends ConsumerWidget {
  final String tripId;
  final String expenseId;

  const ExpenseDetailScreen({
    super.key,
    required this.tripId,
    required this.expenseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tripFinanceProvider(tripId));
    final expense = state.expenses.firstWhere(
      (e) => e.id == expenseId,
      orElse: () => Expense(
        id: expenseId,
        tripId: tripId,
        userId: 'user-rameshwar',
        category: ExpenseCategory.accommodation,
        categoryName: 'Accommodation',
        title: 'Taj Fort Aguada Advance Payment',
        amount: 14500.0,
        currency: 'INR',
        baseAmount: 14500.0,
        baseCurrency: 'INR',
        exchangeRate: 1.0,
        expenseDate: '2026-08-02T10:00:00Z',
        payerId: 'user-rameshwar',
        payerName: 'Rameshwar',
        paymentMethod: 'card',
        bookingId: 'book-hotel-1',
        receiptDocumentId: 'doc-hotel-1',
        createdAt: DateTime.now().toIso8601String(),
      ),
    );

    final catConfig = ExpenseCategoryConfig.getConfig(expense.category);

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Expense Details', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsRegular.trash, color: AppColors.error),
            onPressed: () async {
              await ref.read(tripFinanceProvider(tripId).notifier).deleteExpense(expense.id);
              if (context.mounted) {
                AppSnackBar.show(context, message: 'Expense deleted');
                context.pop();
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.pageMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Amount & Title Card
              Container(
                padding: const EdgeInsets.all(AppDimensions.space20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.03),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: catConfig.color.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(catConfig.icon, color: catConfig.color, size: 22),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            catConfig.label.toUpperCase(),
                            style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.space16),
                    Text(
                      '${expense.currency} ${expense.amount.toStringAsFixed(0)}',
                      style: AppTypography.displayLarge.copyWith(fontWeight: FontWeight.w800, color: AppColors.primary),
                    ),
                    const SizedBox(height: 4),
                    Text(expense.title, style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: AppDimensions.space16),

                    _buildDetailRow('Paid By', expense.payerName),
                    const Divider(height: 16),
                    _buildDetailRow('Payment Method', expense.paymentMethod.toUpperCase()),
                    const Divider(height: 16),
                    _buildDetailRow('Date Recorded', expense.expenseDate.split('T')[0]),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.space20),

              // Linked Records Section
              Text('LINKED RECORDS & RECEIPT', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
              const SizedBox(height: AppDimensions.space10),

              if (expense.bookingId != null)
                ListTile(
                  tileColor: AppColors.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
                  leading: const Icon(PhosphorIconsRegular.buildings, color: AppColors.primary),
                  title: const Text('Linked Booking Record', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  subtitle: Text(expense.bookingId!, style: const TextStyle(fontSize: 11)),
                  trailing: const Icon(PhosphorIconsRegular.caretRight, size: 16),
                  onTap: () => context.push('/trips/$tripId/bookings/${expense.bookingId!}'),
                ),

              if (expense.receiptDocumentId != null) ...[
                const SizedBox(height: 10),
                ListTile(
                  tileColor: AppColors.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
                  leading: const Icon(PhosphorIconsRegular.fileText, color: Colors.indigo),
                  title: const Text('Attached Receipt PDF', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  subtitle: Text(expense.receiptDocumentId!, style: const TextStyle(fontSize: 11)),
                  trailing: const Icon(PhosphorIconsRegular.caretRight, size: 16),
                  onTap: () => AppSnackBar.show(context, message: 'Opening attached receipt...'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
        Text(value, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }
}
