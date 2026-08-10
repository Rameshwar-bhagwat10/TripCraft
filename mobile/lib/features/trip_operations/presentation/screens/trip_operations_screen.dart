import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/feedback/app_snackbar.dart';

import '../providers/trip_operations_provider.dart';
import '../widgets/add_document_sheet.dart';
import '../widgets/booking_card.dart';
import '../widgets/document_card.dart';
import '../widgets/operational_readiness_card.dart';

class TripOperationsScreen extends ConsumerWidget {
  final String tripId;

  const TripOperationsScreen({
    super.key,
    required this.tripId,
  });

  void _showUploadSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddDocumentSheet(
          onUpload: (data) async {
            await ref.read(tripOperationsProvider(tripId).notifier).createDocument(data);
            if (context.mounted) {
              AppSnackBar.show(context, message: 'Document uploaded to private vault');
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tripOperationsProvider(tripId));

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Trip Operations & Vault', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.pageMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Readiness Score Card
                    if (state.summary != null) OperationalReadinessCard(summary: state.summary!),
                    const SizedBox(height: AppDimensions.space24),

                    // Quick Operations Action Row
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => context.push('/trips/$tripId/bookings/create'),
                            icon: const Icon(PhosphorIconsBold.plus, size: 16),
                            label: const Text('Add Booking', style: TextStyle(fontWeight: FontWeight.w700)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _showUploadSheet(context, ref),
                            icon: const Icon(PhosphorIconsBold.uploadSimple, size: 16),
                            label: const Text('Upload Ticket', style: TextStyle(fontWeight: FontWeight.w700)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textPrimary,
                              side: const BorderSide(color: AppColors.border),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.space24),

                    // Confirmed Bookings Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('CONFIRMED BOOKINGS (${state.bookings.length})', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
                        TextButton(
                          onPressed: () => context.push('/trips/$tripId/bookings'),
                          child: Text('View All', style: AppTypography.labelMedium.copyWith(color: AppColors.primary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.space8),

                    if (state.bookings.isEmpty)
                      Text('No bookings added yet.', style: AppTypography.bodyMedium)
                    else
                      ...state.bookings.take(2).map((b) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppDimensions.space10),
                          child: BookingCard(
                            booking: b,
                            onTap: () => context.push('/trips/$tripId/bookings/${b.id}'),
                          ),
                        );
                      }),

                    const SizedBox(height: AppDimensions.space24),

                    // Document Vault Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('TRAVEL DOCUMENTS (${state.documents.length})', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
                        TextButton(
                          onPressed: () => context.push('/trips/$tripId/documents'),
                          child: Text('Open Vault', style: AppTypography.labelMedium.copyWith(color: AppColors.primary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.space8),

                    if (state.documents.isEmpty)
                      Text('No documents uploaded yet.', style: AppTypography.bodyMedium)
                    else
                      ...state.documents.take(2).map((doc) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppDimensions.space10),
                          child: DocumentCard(
                            document: doc,
                            onTap: () => AppSnackBar.show(context, message: 'Opening ${doc.title}...'),
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
