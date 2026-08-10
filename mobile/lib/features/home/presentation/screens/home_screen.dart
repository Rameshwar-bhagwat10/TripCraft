import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/cards/app_card.dart';

import '../providers/home_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final upcomingTrip = homeState.data.upcomingTrip;
    final recommendations = homeState.data.recommendations;

    return AppScaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            await ref.read(homeProvider.notifier).fetchHomeData(isRefresh: true);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppDimensions.pageMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Greeting
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WELCOME BACK',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textTertiary,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Ready for Goa?',
                          style: AppTypography.displaySmall.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => context.go('/profile'),
                      child: const CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.primarySurface,
                        child: Icon(PhosphorIconsRegular.user, color: AppColors.primary, size: 22),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.space20),

                // Search Bar Trigger
                GestureDetector(
                  onTap: () => context.push('/explore/search'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.03),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(PhosphorIconsRegular.magnifyingGlass, color: AppColors.textTertiary, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          'Where to next? Search destinations...',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.space24),

                // AI Travel Copilot Hero Banner
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    context.push('/ai-copilot');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.space16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(PhosphorIconsFill.sparkle, color: Colors.amber, size: 24),
                        ),
                        const SizedBox(width: AppDimensions.space14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TRIPCRAFT AI COPILOT',
                                style: AppTypography.labelSmall.copyWith(color: Colors.amber, letterSpacing: 1.0, fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Ask Copilot to plan or optimize',
                                style: AppTypography.titleMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                'Context-aware reasoning over itinerary & weather',
                                style: AppTypography.bodySmall.copyWith(color: Colors.white70, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        const Icon(PhosphorIconsRegular.caretRight, color: Colors.white70, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.space24),

                // Next Trip Card
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'UPCOMING TRIP',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textTertiary,
                        letterSpacing: 1.0,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/trips'),
                      child: Text('See All', style: AppTypography.labelMedium.copyWith(color: AppColors.primary)),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.space8),

                if (upcomingTrip != null) ...[
                  AppCard(
                    padding: const EdgeInsets.all(AppDimensions.space16),
                    onTap: () => context.push('/trips/${upcomingTrip.id}'),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            upcomingTrip.imageUrl,
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 72,
                              height: 72,
                              color: AppColors.surfaceSecondary,
                              child: const Icon(PhosphorIconsRegular.image, color: AppColors.textTertiary),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.space14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                upcomingTrip.destination,
                                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${upcomingTrip.startDate} · ${upcomingTrip.daysToGo} Days to go',
                                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.primarySurface,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'Confirmed',
                                      style: AppTypography.labelSmall.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppDimensions.space28),

                // Featured Destinations Carousel
                Text(
                  'FEATURED DESTINATIONS',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textTertiary,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: AppDimensions.space12),

                SizedBox(
                  height: 180,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: recommendations.length,
                    separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.space12),
                    itemBuilder: (context, index) {
                      final dest = recommendations[index];
                      return GestureDetector(
                        onTap: () => context.push('/explore/destination/${dest.id}'),
                        child: Container(
                          width: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: NetworkImage(dest.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            padding: const EdgeInsets.all(AppDimensions.space12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dest.title,
                                  style: AppTypography.titleSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  dest.category,
                                  style: AppTypography.bodySmall.copyWith(color: Colors.white70, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppDimensions.space32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}