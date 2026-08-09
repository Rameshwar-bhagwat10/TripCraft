import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/buttons/secondary_button.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return AppScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.pageMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimensions.space16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                      Text(
                        authState.fullName ?? authState.email ?? 'Traveler',
                        style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => context.push(RouteConstants.profile),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primaryLight),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(15, 118, 110, 0.12),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        PhosphorIconsBold.user,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.space32),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          PhosphorIconsBold.compass,
                          size: 36,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.space20),
                      Text(
                        'TripCraft Dashboard',
                        style: AppTypography.headlineMedium,
                      ),
                      const SizedBox(height: AppDimensions.space8),
                      Text(
                        'Phase 4 Profile & Personalization active.',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.space24),
                      SecondaryButton(
                        label: 'View User Profile & Preferences',
                        icon: const Icon(PhosphorIconsRegular.userGear, size: 20),
                        onPressed: () => context.push(RouteConstants.profile),
                      ),
                    ],
                  ),
                ),
              ),
              SecondaryButton(
                label: 'Sign Out',
                icon: const Icon(PhosphorIconsRegular.signOut, size: 20),
                onPressed: () => ref.read(authProvider.notifier).logout(),
              ),
              const SizedBox(height: AppDimensions.space16),
            ],
          ),
        ),
      ),
    );
  }
}