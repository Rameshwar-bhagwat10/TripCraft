import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';

enum BudgetStatus {
  onTrack,
  approachingLimit,
  overBudget,
}

class BudgetStatusConfig {
  final BudgetStatus status;
  final String label;
  final IconData icon;
  final Color color;

  const BudgetStatusConfig({
    required this.status,
    required this.label,
    required this.icon,
    required this.color,
  });

  static const Map<BudgetStatus, BudgetStatusConfig> _configs = {
    BudgetStatus.onTrack: BudgetStatusConfig(status: BudgetStatus.onTrack, label: 'On Track', icon: PhosphorIconsFill.checkCircle, color: Color(0xFF10B981)),
    BudgetStatus.approachingLimit: BudgetStatusConfig(status: BudgetStatus.approachingLimit, label: 'Approaching Limit', icon: PhosphorIconsFill.warning, color: Colors.orange),
    BudgetStatus.overBudget: BudgetStatusConfig(status: BudgetStatus.overBudget, label: 'Over Budget', icon: PhosphorIconsFill.xCircle, color: AppColors.error),
  };

  static BudgetStatusConfig getConfig(BudgetStatus status) {
    return _configs[status] ?? _configs[BudgetStatus.onTrack]!;
  }

  static BudgetStatus fromString(String str) {
    switch (str.toLowerCase()) {
      case 'over_budget':
      case 'overbudget':
        return BudgetStatus.overBudget;
      case 'approaching_limit':
      case 'approachinglimit':
        return BudgetStatus.approachingLimit;
      case 'on_track':
      default:
        return BudgetStatus.onTrack;
    }
  }
}

class CategoryBudget {
  final String categoryId;
  final String categoryName;
  final double allocatedAmount;
  final double spentAmount;

  const CategoryBudget({
    required this.categoryId,
    required this.categoryName,
    required this.allocatedAmount,
    required this.spentAmount,
  });

  factory CategoryBudget.fromJson(Map<String, dynamic> json) {
    return CategoryBudget(
      categoryId: json['categoryId'] as String? ?? 'other',
      categoryName: json['categoryName'] as String? ?? 'Other',
      allocatedAmount: (json['allocatedAmount'] as num?)?.toDouble() ?? 0.0,
      spentAmount: (json['spentAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  double get remainingAmount => allocatedAmount - spentAmount;
  double get percentageUsed => allocatedAmount > 0 ? (spentAmount / allocatedAmount) * 100 : 0;
}

class TripBudget {
  final String id;
  final String tripId;
  final double totalBudget;
  final String currency;
  final double spentAmount;
  final double remainingAmount;
  final double percentageUsed;
  final BudgetStatus status;
  final double dailyAllowance;
  final List<CategoryBudget> categoryBudgets;
  final String createdAt;
  final String updatedAt;

  const TripBudget({
    required this.id,
    required this.tripId,
    required this.totalBudget,
    required this.currency,
    required this.spentAmount,
    required this.remainingAmount,
    required this.percentageUsed,
    required this.status,
    required this.dailyAllowance,
    this.categoryBudgets = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory TripBudget.fromJson(Map<String, dynamic> json) {
    return TripBudget(
      id: json['id'] as String? ?? '',
      tripId: json['tripId'] as String? ?? '',
      totalBudget: (json['totalBudget'] as num?)?.toDouble() ?? 50000.0,
      currency: json['currency'] as String? ?? 'INR',
      spentAmount: (json['spentAmount'] as num?)?.toDouble() ?? 0.0,
      remainingAmount: (json['remainingAmount'] as num?)?.toDouble() ?? 50000.0,
      percentageUsed: (json['percentageUsed'] as num?)?.toDouble() ?? 0.0,
      status: BudgetStatusConfig.fromString(json['status'] as String? ?? 'on_track'),
      dailyAllowance: (json['dailyAllowance'] as num?)?.toDouble() ?? 5000.0,
      categoryBudgets: (json['categoryBudgets'] as List<dynamic>?)?.map((e) => CategoryBudget.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      updatedAt: json['updatedAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }
}
