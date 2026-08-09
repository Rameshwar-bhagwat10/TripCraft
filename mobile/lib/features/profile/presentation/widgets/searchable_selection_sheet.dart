import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';

class SelectionItem<T> {
  final T value;
  final String title;
  final String? subtitle;
  final String? leadingText;

  const SelectionItem({
    required this.value,
    required this.title,
    this.subtitle,
    this.leadingText,
  });
}

/// Searchable iOS-style Bottom Sheet for Language and Currency selections.
class SearchableSelectionSheet<T> extends StatefulWidget {
  final String title;
  final List<SelectionItem<T>> items;
  final T selectedValue;
  final ValueChanged<T> onSelected;

  const SearchableSelectionSheet({
    super.key,
    required this.title,
    required this.items,
    required this.selectedValue,
    required this.onSelected,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<SelectionItem<T>> items,
    required T selectedValue,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SearchableSelectionSheet<T>(
          title: title,
          items: items,
          selectedValue: selectedValue,
          onSelected: (val) => Navigator.of(context).pop(val),
        );
      },
    );
  }

  @override
  State<SearchableSelectionSheet<T>> createState() => _SearchableSelectionSheetState<T>();
}

class _SearchableSelectionSheetState<T> extends State<SearchableSelectionSheet<T>> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SelectionItem<T>> get _filteredItems {
    if (_searchQuery.trim().isEmpty) return widget.items;
    final query = _searchQuery.trim().toLowerCase();
    return widget.items.where((item) {
      final titleMatch = item.title.toLowerCase().contains(query);
      final subtitleMatch = item.subtitle?.toLowerCase().contains(query) ?? false;
      final leadingMatch = item.leadingText?.toLowerCase().contains(query) ?? false;
      return titleMatch || subtitleMatch || leadingMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppDimensions.space12),
            // Drag Handle
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderStrong,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppDimensions.space16),
            // Title Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageMargin),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
                  ),
                  IconButton(
                    icon: const Icon(PhosphorIconsRegular.x, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.space8),
            // Search input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageMargin),
              child: AppTextField(
                controller: _searchController,
                hintText: 'Search...',
                prefixIcon: const Icon(PhosphorIconsRegular.magnifyingGlass),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
              ),
            ),
            const SizedBox(height: AppDimensions.space16),
            // Items List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageMargin),
                itemCount: _filteredItems.length,
                separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.border),
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  final isSelected = item.value == widget.selectedValue;

                  return Material(
                    color: isSelected ? AppColors.primarySurface : AppColors.surface,
                    borderRadius: index == 0
                        ? const BorderRadius.vertical(top: Radius.circular(12))
                        : index == _filteredItems.length - 1
                            ? const BorderRadius.vertical(bottom: Radius.circular(12))
                            : BorderRadius.zero,
                    child: InkWell(
                      onTap: () => widget.onSelected(item.value),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.space16,
                          vertical: AppDimensions.space14,
                        ),
                        child: Row(
                          children: [
                            if (item.leadingText != null) ...[
                              Container(
                                width: 36,
                                height: 36,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceSecondary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item.leadingText!,
                                  style: AppTypography.titleSmall.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppDimensions.space12),
                            ],
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: AppTypography.bodyMedium.copyWith(
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  if (item.subtitle != null) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      item.subtitle!,
                                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (isSelected) ...[
                              const Icon(
                                PhosphorIconsBold.check,
                                size: 18,
                                color: AppColors.primary,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppDimensions.space16),
          ],
        ),
      ),
    );
  }
}
