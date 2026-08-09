import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';
import '../../domain/entities/itinerary.dart';

class AddActivitySheet extends StatefulWidget {
  final ItineraryItem? existingItem;
  final Function(Map<String, dynamic> body) onSave;

  const AddActivitySheet({
    super.key,
    this.existingItem,
    required this.onSave,
  });

  @override
  State<AddActivitySheet> createState() => _AddActivitySheetState();
}

class _AddActivitySheetState extends State<AddActivitySheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();

  ActivityType _selectedType = ActivityType.sightseeing;
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 30);
  bool _isAllDay = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingItem != null) {
      final item = widget.existingItem!;
      _titleController.text = item.title;
      _descriptionController.text = item.description ?? '';
      _notesController.text = item.notes ?? '';
      _selectedType = item.type;
      _isAllDay = item.isAllDay;
      if (item.startTime != null) {
        _startTime = _parseTimeOfDay(item.startTime!);
      }
      if (item.endTime != null) {
        _endTime = _parseTimeOfDay(item.endTime!);
      }
    }
  }

  TimeOfDay _parseTimeOfDay(String str) {
    try {
      final parts = str.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (_) {
      return const TimeOfDay(hour: 9, minute: 0);
    }
  }

  String _formatTimeOfDay(TimeOfDay tod) {
    final h = tod.hour.toString().padLeft(2, '0');
    final m = tod.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String _calculateDuration(TimeOfDay start, TimeOfDay end) {
    final startMins = start.hour * 60 + start.minute;
    final endMins = end.hour * 60 + end.minute;
    final diff = endMins - startMins;

    if (diff <= 0) return '30m';

    final h = diff ~/ 60;
    final m = diff % 60;

    if (h > 0 && m > 0) return '${h}h ${m}m';
    if (h > 0) return '${h}h';
    return '${m}m';
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
        // Auto bump end time if before start
        if (_endTime.hour * 60 + _endTime.minute <= picked.hour * 60 + picked.minute) {
          _endTime = TimeOfDay(hour: (picked.hour + 1) % 24, minute: picked.minute);
        }
      });
    }
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (picked != null) {
      setState(() => _endTime = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final duration = _calculateDuration(_startTime, _endTime);

    final body = {
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'type': _selectedType.name,
      'startTime': _formatTimeOfDay(_startTime),
      'endTime': _formatTimeOfDay(_endTime),
      'duration': duration,
      'notes': _notesController.text.trim(),
      'isAllDay': _isAllDay,
    };

    widget.onSave(body);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final durationStr = _calculateDuration(_startTime, _endTime);

    return Container(
      padding: EdgeInsets.only(
        top: AppDimensions.space16,
        left: AppDimensions.pageMargin,
        right: AppDimensions.pageMargin,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppDimensions.space24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bottom Sheet Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.space16),

              Text(
                widget.existingItem != null ? 'Edit Activity' : 'Add Activity',
                style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppDimensions.space16),

              // Activity Title Input
              AppTextField(
                controller: _titleController,
                label: 'Activity Title',
                hintText: 'e.g. Fort Aguada, Lunch at Brittos...',
                validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: AppDimensions.space16),

              // Category Selector Chips
              Text(
                'CATEGORY',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textTertiary,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: AppDimensions.space8),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: ActivityType.values.length,
                  separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.space8),
                  itemBuilder: (context, index) {
                    final type = ActivityType.values[index];
                    final config = ActivityTypeConfig.getConfig(type);
                    final isSelected = _selectedType == type;

                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _selectedType = type);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? config.tintColor : AppColors.surfaceSecondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              config.icon,
                              size: 14,
                              color: isSelected ? Colors.white : config.tintColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              config.label,
                              style: AppTypography.bodySmall.copyWith(
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppDimensions.space20),

              // All-Day Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All-Day Event',
                    style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Switch(
                    value: _isAllDay,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) => setState(() => _isAllDay = val),
                  ),
                ],
              ),

              // Timed Pickers (if not all day)
              if (!_isAllDay) ...[
                const SizedBox(height: AppDimensions.space12),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _pickStartTime,
                        child: Container(
                          padding: const EdgeInsets.all(AppDimensions.space12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('START TIME', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary)),
                              const SizedBox(height: 4),
                              Text(
                                _startTime.format(context),
                                style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.space12),
                    Expanded(
                      child: GestureDetector(
                        onTap: _pickEndTime,
                        child: Container(
                          padding: const EdgeInsets.all(AppDimensions.space12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('END TIME', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary)),
                              const SizedBox(height: 4),
                              Text(
                                _endTime.format(context),
                                style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.space8),
                Text(
                  'Estimated duration: $durationStr',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ],

              const SizedBox(height: AppDimensions.space20),

              // Notes Input
              AppTextField(
                controller: _notesController,
                label: 'Notes / Description (Optional)',
                hintText: 'Add notes or tips...',
                maxLines: 2,
              ),
              const SizedBox(height: AppDimensions.space24),

              // Primary CTA Button
              PrimaryButton(
                label: widget.existingItem != null ? 'Save Changes' : 'Add Activity',
                isLoading: _isSubmitting,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
