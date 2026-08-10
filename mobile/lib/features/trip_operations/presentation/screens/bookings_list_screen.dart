import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../domain/entities/booking.dart';
import '../providers/trip_operations_provider.dart';
import '../widgets/booking_card.dart';

class BookingsListScreen extends ConsumerStatefulWidget {
  final String tripId;

  const BookingsListScreen({
    super.key,
    required this.tripId,
  });

  @override
  ConsumerState<BookingsListScreen> createState() => _BookingsListScreenState();
}

class _BookingsListScreenState extends ConsumerState<BookingsListScreen> {
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tripOperationsProvider(widget.tripId));

    final filteredBookings = state.bookings.where((b) {
      if (_selectedFilter == 'all') return true;
      if (_selectedFilter == 'confirmed') return b.status == BookingStatus.confirmed;
      if (_selectedFilter == 'pending') return b.status == BookingStatus.pending;
      return true;
    }).toList();

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Trip Bookings (${state.bookings.length})', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsBold.plus, color: AppColors.primary),
            onPressed: () => context.push('/trips/${widget.tripId}/bookings/create'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Pills
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageMargin, vertical: 8),
              child: Row(
                children: ['all', 'confirmed', 'pending'].map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(filter.toUpperCase()),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedFilter = filter),
                      selectedColor: AppColors.primarySurface,
                      labelStyle: AppTypography.bodySmall.copyWith(
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppDimensions.space10),

            // Bookings List
            Expanded(
              child: filteredBookings.isEmpty
                  ? Center(child: Text('No bookings match filter.', style: AppTypography.bodyMedium))
                  : ListView.builder(
                      padding: const EdgeInsets.all(AppDimensions.pageMargin),
                      itemCount: filteredBookings.length,
                      itemBuilder: (context, index) {
                        final b = filteredBookings[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppDimensions.space12),
                          child: BookingCard(
                            booking: b,
                            onTap: () => context.push('/trips/${widget.tripId}/bookings/${b.id}'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
