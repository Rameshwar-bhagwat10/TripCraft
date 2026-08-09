import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../app/app_colors.dart';
import '../../app/app_dimensions.dart';
import '../../app/app_typography.dart';

/// Navigation Destination Item for AppShell.
class ShellTabItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const ShellTabItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  static const List<ShellTabItem> tabs = [
    ShellTabItem(
      label: 'Home',
      icon: PhosphorIconsRegular.house,
      activeIcon: PhosphorIconsBold.house,
    ),
    ShellTabItem(
      label: 'Explore',
      icon: PhosphorIconsRegular.compass,
      activeIcon: PhosphorIconsBold.compass,
    ),
    ShellTabItem(
      label: 'Trips',
      icon: PhosphorIconsRegular.suitcase,
      activeIcon: PhosphorIconsBold.suitcase,
    ),
    ShellTabItem(
      label: 'Saved',
      icon: PhosphorIconsRegular.bookmark,
      activeIcon: PhosphorIconsBold.bookmark,
    ),
    ShellTabItem(
      label: 'Profile',
      icon: PhosphorIconsRegular.user,
      activeIcon: PhosphorIconsBold.user,
    ),
  ];
}

/// Core Authenticated Application Shell for TripCraft.
/// Provides iOS-inspired bottom navigation with stateful tab preservation.
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({
    super.key,
    required this.navigationShell,
  });

  void _onTabTap(int index) {
    HapticFeedback.selectionClick();
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.border, width: 1.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.03),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(ShellTabItem.tabs.length, (index) {
                final tab = ShellTabItem.tabs[index];
                final isSelected = index == navigationShell.currentIndex;

                return Expanded(
                  child: InkWell(
                    onTap: () => _onTabTap(index),
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primarySurface
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              isSelected ? tab.activeIcon : tab.icon,
                              size: 22,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tab.label,
                            style: AppTypography.labelSmall.copyWith(
                              fontSize: 10,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textTertiary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
