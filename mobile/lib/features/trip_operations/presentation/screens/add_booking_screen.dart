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
import '../../domain/entities/booking.dart';
import '../providers/trip_operations_provider.dart';

class AddBookingScreen extends ConsumerStatefulWidget {
  final String tripId;

  const AddBookingScreen({
    super.key,
    required this.tripId,
  });

  @override
  ConsumerState<AddBookingScreen> createState() => _AddBookingScreenState();
}

class _AddBookingScreenState extends ConsumerState<AddBookingScreen> {
  final _titleController = TextEditingController(text: 'Air India Flight AI-582');
  final _providerController = TextEditingController(text: 'Air India');
  final _refController = TextEditingController(text: 'AI-PNR-7711');
  final _locationController = TextEditingController(text: 'Mumbai (BOM) -> Goa (GOI)');

  BookingType _selectedType = BookingType.flight;
  BookingStatus _selectedStatus = BookingStatus.confirmed;

  @override
  void dispose() {
    _titleController.dispose();
    _providerController.dispose();
    _refController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    final body = {
      'type': _selectedType.name,
      'title': _titleController.text,
      'providerName': _providerController.text,
      'confirmationNumber': _refController.text,
      'status': _selectedStatus.name,
      'location': _locationController.text,
      'startDateTime': DateTime.now().toIso8601String(),
    };

    await ref.read(tripOperationsProvider(widget.tripId).notifier).createBooking(body);
    if (mounted) {
      AppSnackBar.show(context, message: 'Booking record created');
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Add Booking Record', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.pageMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('BOOKING TYPE', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: BookingType.values.map((type) {
                  final config = BookingTypeConfig.getConfig(type);
                  final isSelected = _selectedType == type;
                  return ChoiceChip(
                    label: Text(config.label),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedType = type),
                    selectedColor: config.color.withValues(alpha: 0.15),
                    labelStyle: AppTypography.bodySmall.copyWith(
                      color: isSelected ? config.color : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppDimensions.space20),

              Text('RESERVATION STATUS', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [BookingStatus.confirmed, BookingStatus.pending, BookingStatus.draft].map((status) {
                  final config = BookingStatusConfig.getConfig(status);
                  final isSelected = _selectedStatus == status;
                  return ChoiceChip(
                    label: Text(config.label),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedStatus = status),
                    selectedColor: config.color.withValues(alpha: 0.15),
                    labelStyle: AppTypography.bodySmall.copyWith(
                      color: isSelected ? config.color : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppDimensions.space20),

              Text('RESERVATION TITLE', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
              const SizedBox(height: 6),
              _buildInput(_titleController),
              const SizedBox(height: AppDimensions.space16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('PROVIDER NAME', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
                        const SizedBox(height: 6),
                        _buildInput(_providerController),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CONFIRMATION PNR', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
                        const SizedBox(height: 6),
                        _buildInput(_refController),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.space16),

              Text('LOCATION / AIRPORT / HOTEL', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
              const SizedBox(height: 6),
              _buildInput(_locationController),
              const SizedBox(height: AppDimensions.space24),

              PrimaryButton(
                label: 'Save Confirmed Booking',
                icon: const Icon(PhosphorIconsBold.check, size: 18),
                onPressed: _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller) {
    return TextField(
      controller: controller,
      style: AppTypography.bodyMedium,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }
}
