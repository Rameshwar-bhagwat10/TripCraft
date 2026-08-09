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

class CreateTripScreen extends ConsumerStatefulWidget {
  final String? initialDestinationId;

  const CreateTripScreen({
    super.key,
    this.initialDestinationId,
  });

  @override
  ConsumerState<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends ConsumerState<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _startDate = DateTime.now().add(const Duration(days: 7));
  DateTime _endDate = DateTime.now().add(const Duration(days: 12));
  int _travelersCount = 2;
  String _destinationId = 'dest-goa';
  final String _destinationName = 'Goa, India';
  final String _coverImage = 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=1200';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialDestinationId != null) {
      _destinationId = widget.initialDestinationId!;
    }
    _titleController.text = 'Goa Escape';
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
      firstDate: DateTime.now(),
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

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final body = {
      'destinationId': _destinationId,
      'title': _titleController.text.trim().isEmpty
          ? '$_destinationName Trip'
          : _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'startDate': _startDate.toIso8601String().split('T').first,
      'endDate': _endDate.toIso8601String().split('T').first,
      'travelersCount': _travelersCount,
      'coverImage': _coverImage,
    };

    final createdTrip = await ref.read(tripsProvider.notifier).createTrip(body);

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (createdTrip != null) {
        AppSnackBar.show(
          context,
          message: 'Trip created successfully!',
          variant: AppSnackBarVariant.success,
        );
        context.go('/trips/${createdTrip.id}');
      } else {
        AppSnackBar.show(
          context,
          message: 'Failed to create trip. Please try again.',
          variant: AppSnackBarVariant.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final startDateStr = '${_startDate.day}/${_startDate.month}/${_startDate.year}';
    final endDateStr = '${_endDate.day}/${_endDate.month}/${_endDate.year}';
    final duration = _endDate.difference(_startDate).inDays + 1;

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Create Trip',
          style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.pageMargin),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Destination Selector Card
                Text(
                  'DESTINATION',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textTertiary,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: AppDimensions.space8),
                Container(
                  padding: const EdgeInsets.all(AppDimensions.space14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          _coverImage,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 48,
                            height: 48,
                            color: AppColors.primarySurface,
                            child: const Icon(PhosphorIconsRegular.mapPin, color: AppColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.space12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _destinationName,
                              style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Selected Destination',
                              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const Icon(PhosphorIconsRegular.checkCircle, color: AppColors.primary, size: 20),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.space20),

                // Trip Name Input
                AppTextField(
                  controller: _titleController,
                  label: 'Trip Name',
                  hintText: 'e.g. Goa Escape',
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

                // Travelers Count Stepper
                TravelerStepper(
                  count: _travelersCount,
                  onChanged: (val) => setState(() => _travelersCount = val),
                ),
                const SizedBox(height: AppDimensions.space20),

                // Notes / Description
                AppTextField(
                  controller: _descriptionController,
                  label: 'Notes & Preferences (Optional)',
                  hintText: 'Add any notes, dietary preferences, or goals for this trip...',
                  maxLines: 3,
                ),
                const SizedBox(height: AppDimensions.space32),

                // Submit Primary Button
                PrimaryButton(
                  label: 'Create Trip',
                  isLoading: _isSubmitting,
                  icon: const Icon(PhosphorIconsBold.suitcase, size: 18),
                  onPressed: _onSubmit,
                ),
                const SizedBox(height: AppDimensions.space24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}