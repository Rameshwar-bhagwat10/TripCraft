import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/states/empty_state.dart';

import '../../../home/presentation/widgets/destination_card.dart';
import '../../domain/entities/destination.dart';
import '../providers/explore_provider.dart';

class DestinationSearchScreen extends ConsumerStatefulWidget {
  const DestinationSearchScreen({super.key});

  @override
  ConsumerState<DestinationSearchScreen> createState() => _DestinationSearchScreenState();
}

class _DestinationSearchScreenState extends ConsumerState<DestinationSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  List<Destination> _searchResults = [];
  bool _isSearching = false;
  final List<String> _recentSearches = ['Goa', 'Kerala', 'Dubai', 'Mountain escapes'];

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () async {
      if (query.trim().isEmpty) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
        });
        return;
      }

      setState(() => _isSearching = true);
      final repository = ref.read(exploreRepositoryProvider);
      final results = await repository.getDestinations(DestinationFilter(search: query.trim()));
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    });
  }

  void _performSearch(String query) {
    _searchController.text = query;
    _onSearchChanged(query);
    if (!_recentSearches.contains(query)) {
      setState(() {
        _recentSearches.insert(0, query);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim();

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search destinations, cities...',
            hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(PhosphorIconsRegular.xCircle, color: AppColors.textTertiary, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  )
                : null,
          ),
          onChanged: _onSearchChanged,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.pageMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (query.isEmpty) ...[
                // Recent Searches
                if (_recentSearches.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'RECENT SEARCHES',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textTertiary,
                          letterSpacing: 1.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _recentSearches.clear()),
                        child: Text(
                          'Clear all',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.space12),
                  Wrap(
                    spacing: AppDimensions.space8,
                    runSpacing: AppDimensions.space8,
                    children: _recentSearches.map((term) {
                      return InkWell(
                        onTap: () => _performSearch(term),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(PhosphorIconsRegular.clockCounterClockwise, size: 14, color: AppColors.textTertiary),
                              const SizedBox(width: 6),
                              Text(term, style: AppTypography.bodySmall),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppDimensions.space28),
                ],

                // Popular Suggestions
                Text(
                  'POPULAR SEARCHES',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textTertiary,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: AppDimensions.space12),
                ListTile(
                  leading: const Icon(PhosphorIconsRegular.sun, color: AppColors.primary),
                  title: const Text('Beach Destinations'),
                  trailing: const Icon(PhosphorIconsRegular.caretRight, size: 16),
                  onTap: () => _performSearch('Beach'),
                ),
                ListTile(
                  leading: const Icon(PhosphorIconsRegular.mountains, color: AppColors.primary),
                  title: const Text('Mountain Escapes'),
                  trailing: const Icon(PhosphorIconsRegular.caretRight, size: 16),
                  onTap: () => _performSearch('Mountains'),
                ),
                ListTile(
                  leading: const Icon(PhosphorIconsRegular.compass, color: AppColors.primary),
                  title: const Text('Weekend Getaways'),
                  trailing: const Icon(PhosphorIconsRegular.caretRight, size: 16),
                  onTap: () => _performSearch('Weekend'),
                ),
              ] else if (_isSearching) ...[
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
              ] else if (_searchResults.isEmpty) ...[
                EmptyState(
                  title: 'No destinations found',
                  description: 'Try searching for another city, country, or category like Beach or Mountains.',
                  actionLabel: 'Clear Search',
                  onAction: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                ),
              ] else ...[
                Text(
                  'SEARCH RESULTS (${_searchResults.length})',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textTertiary,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: AppDimensions.space16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.82,
                    crossAxisSpacing: AppDimensions.space12,
                    mainAxisSpacing: AppDimensions.space12,
                  ),
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final dest = _searchResults[index];
                    return DestinationCard.fromDestination(
                      destination: dest,
                      onTap: () => context.push('/explore/destination/${dest.id}'),
                      onSaveTap: () {
                        ref.read(exploreProvider.notifier).toggleSaveDestination(dest.id);
                      },
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
