import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/feedback/app_snackbar.dart';
import '../../domain/entities/booking.dart';
import '../providers/trip_operations_provider.dart';

class BookingDetailScreen extends ConsumerWidget {
  final String tripId;
  final String bookingId;

  const BookingDetailScreen({
    super.key,
    required this.tripId,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tripOperationsProvider(tripId));
    final booking = state.bookings.firstWhere(
      (b) => b.id == bookingId,
      orElse: () => Booking(
        id: bookingId,
        tripId: tripId,
        type: BookingType.flight,
        title: 'IndiGo Flight 6E-204',
        providerName: 'IndiGo Airlines',
        confirmationNumber: '6E-PNR-8849',
        status: BookingStatus.confirmed,
        startDateTime: '2026-08-21T08:30:00Z',
        createdAt: DateTime.now().toIso8601String(),
      ),
    );

    final typeConfig = BookingTypeConfig.getConfig(booking.type);
    final statusConfig = BookingStatusConfig.getConfig(booking.status);

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Booking Details', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.pageMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Status & Provider Banner
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
                            color: typeConfig.color.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(typeConfig.icon, color: typeConfig.color, size: 22),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusConfig.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            statusConfig.label,
                            style: AppTypography.labelSmall.copyWith(color: statusConfig.color, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.space16),
                    Text(booking.title, style: AppTypography.displaySmall.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(booking.providerName, style: AppTypography.titleSmall.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: AppDimensions.space16),

                    // Confirmation Reference Pill
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.space12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSecondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('CONFIRMATION REF', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, fontSize: 10)),
                              const SizedBox(height: 2),
                              Text(booking.confirmationNumber, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800, color: AppColors.primary)),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(PhosphorIconsRegular.copy, size: 18, color: AppColors.primary),
                            onPressed: () => AppSnackBar.show(context, message: 'Confirmation number copied'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.space20),

              // Booking Details Breakdown
              Text('RESERVATION INFORMATION', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
              const SizedBox(height: AppDimensions.space10),

              Container(
                padding: const EdgeInsets.all(AppDimensions.space16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Start Time', booking.startDateTime),
                    if (booking.endDateTime != null) ...[
                      const Divider(height: 16),
                      _buildDetailRow('End Time', booking.endDateTime!),
                    ],
                    if (booking.location != null) ...[
                      const Divider(height: 16),
                      _buildDetailRow('Location', booking.location!),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.space24),

              // Actions
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/trips/$tripId/map'),
                  icon: const Icon(PhosphorIconsRegular.mapPin, size: 18),
                  label: const Text('Open Location on Map', style: TextStyle(fontWeight: FontWeight.w700)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
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
        Expanded(
          child: Text(
            value,
            style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
