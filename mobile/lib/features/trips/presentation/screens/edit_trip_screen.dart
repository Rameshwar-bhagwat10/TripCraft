import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/feedback/app_snackbar.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';

import '../providers/trips_provider.dart';
import '../widgets/traveler_stepper.dart';

class EditTripScreen extends ConsumerStatefulWidget {
  final String tripId;

  const EditTripScreen({
    super.key,
    required this.tripId,
  });

  @override
  ConsumerState<EditTripScreen> createState() => _EditTripScreenState();
}

class _EditTripScreenState extends ConsumerState<EditTripScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 5));
  int _travelersCount = 2;
  bool _isSubmitting = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final body = {
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'startDate': _startDate.toIso8601String().split('T').first,
      'endDate': _endDate.toIso8601String().split('T').first,
      'travelersCount': _travelersCount,
    };

    final success = await ref.read(tripsProvider.notifier).updateTrip(widget.tripId, body);

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (success) {
        AppSnackBar.show(
          context,
          message: 'Trip updated successfully!',
          variant: AppSnackBarVariant.success,
        );
        ref.invalidate(tripDetailsProvider(widget.tripId));
        context.pop();
      } else {
        AppSnackBar.show(
          context,
          message: 'Failed to update trip. Please try again.',
          variant: AppSnackBarVariant.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tripAsync = ref.watch(tripDetailsProvider(widget.tripId));

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Edit Trip',
          style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: tripAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (_, __) => const Center(child: Text('Trip not found')),
          data: (trip) {
            if (!_initialized) {
              _titleController.text = trip.title;
              _descriptionController.text = trip.description ?? '';
              try {
                _startDate = DateTime.parse(trip.startDate);
                _endDate = DateTime.parse(trip.endDate);
              } catch (_) {}
              _travelersCount = trip.travelersCount;
              _initialized = true;
            }

            final startDateStr = '${_startDate.day}/${_startDate.month}/${_startDate.year}';
            final endDateStr = '${_endDate.day}/${_endDate.month}/${_endDate.year}';
            final duration = _endDate.difference(_startDate).inDays + 1;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.pageMargin),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      controller: _titleController,
                      label: 'Trip Name',
                      validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a trip name' : null,
                    ),
                    const SizedBox(height: AppDimensions.space20),

                    // Dates Selection Card
                    Text(
                      'DATES & DURATION',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textTertiary,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space8),
                    GestureDetector(
                      onTap: _selectDateRange,
                      child: Container(
                        padding: const EdgeInsets.all(AppDimensions.space16),
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
                                const Icon(PhosphorIconsRegular.calendar, color: AppColors.primary, size: 20),
                                const SizedBox(width: AppDimensions.space12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$startDateStr — $endDateStr',
                                      style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      '$duration days trip',
                                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Icon(PhosphorIconsRegular.caretRight, size: 16, color: AppColors.textTertiary),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space20),

                    TravelerStepper(
                      count: _travelersCount,
                      onChanged: (val) => setState(() => _travelersCount = val),
                    ),
                    const SizedBox(height: AppDimensions.space20),

                    AppTextField(
                      controller: _descriptionController,
                      label: 'Notes & Preferences',
                      maxLines: 3,
                    ),
                    const SizedBox(height: AppDimensions.space32),

                    PrimaryButton(
                      label: 'Save Changes',
                      isLoading: _isSubmitting,
                      onPressed: _onSave,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
