import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/states/empty_state.dart';

import '../../../explore/presentation/providers/explore_provider.dart';
import '../../../home/presentation/widgets/destination_card.dart';

class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedAsync = ref.watch(savedDestinationsProvider);
    final exploreNotifier = ref.read(exploreProvider.notifier);

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Saved Places',
          style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: savedAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (_, __) => Padding(
            padding: const EdgeInsets.all(AppDimensions.pageMargin),
            child: EmptyState(
              title: 'Your Saved Collection',
              description: 'Save destinations, activities, and spots to access them anytime when planning trips.',
              icon: PhosphorIconsRegular.bookmark,
            ),
          ),
          data: (destinations) {
            if (destinations.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(AppDimensions.pageMargin),
                child: EmptyState(
                  title: 'Your Saved Collection is Empty',
                  description: 'Explore destinations and tap the bookmark icon to save places for your next getaway.',
                  icon: PhosphorIconsRegular.bookmark,
                  actionLabel: 'Explore Destinations',
                  onAction: () => context.go('/explore'),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => ref.refresh(savedDestinationsProvider),
              color: AppColors.primary,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.pageMargin),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.82,
                    crossAxisSpacing: AppDimensions.space12,
                    mainAxisSpacing: AppDimensions.space12,
                  ),
                  itemCount: destinations.length,
                  itemBuilder: (context, index) {
                    final dest = destinations[index];
                    return DestinationCard.fromDestination(
                      destination: dest,
                      onTap: () => context.push('/explore/destination/${dest.id}'),
                      onSaveTap: () {
                        exploreNotifier.toggleSaveDestination(dest.id);
                      },
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
