class TravelerBalance {
  final String travelerId;
  final String travelerName;
  final double totalPaid;
  final double totalShare;
  final double netBalance;

  const TravelerBalance({
    required this.travelerId,
    required this.travelerName,
    required this.totalPaid,
    required this.totalShare,
    required this.netBalance,
  });

  factory TravelerBalance.fromJson(Map<String, dynamic> json) {
    return TravelerBalance(
      travelerId: json['travelerId'] as String? ?? '',
      travelerName: json['travelerName'] as String? ?? 'Traveler',
      totalPaid: (json['totalPaid'] as num?)?.toDouble() ?? 0.0,
      totalShare: (json['totalShare'] as num?)?.toDouble() ?? 0.0,
      netBalance: (json['netBalance'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class SettlementSuggestion {
  final String id;
  final String payerId;
  final String payerName;
  final String receiverId;
  final String receiverName;
  final double amount;
  final String currency;
  final String status;

  const SettlementSuggestion({
    required this.id,
    required this.payerId,
    required this.payerName,
    required this.receiverId,
    required this.receiverName,
    required this.amount,
    required this.currency,
    required this.status,
  });

  factory SettlementSuggestion.fromJson(Map<String, dynamic> json) {
    return SettlementSuggestion(
      id: json['id'] as String? ?? '',
      payerId: json['payerId'] as String? ?? '',
      payerName: json['payerName'] as String? ?? 'Payer',
      receiverId: json['receiverId'] as String? ?? '',
      receiverName: json['receiverName'] as String? ?? 'Receiver',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'INR',
      status: json['status'] as String? ?? 'pending',
    );
  }

  bool get isSettled => status == 'settled';
}

class CategoryBreakdownItem {
  final String categoryName;
  final double amount;
  final double percentage;

  const CategoryBreakdownItem({
    required this.categoryName,
    required this.amount,
    required this.percentage,
  });

  factory CategoryBreakdownItem.fromJson(Map<String, dynamic> json) {
    return CategoryBreakdownItem(
      categoryName: json['categoryName'] as String? ?? 'Other',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class FinanceAnalytics {
  final String tripId;
  final double totalSpent;
  final double totalBudget;
  final double projectedTotalSpend;
  final double dailyAverageSpend;
  final String topSpendingCategory;
  final List<CategoryBreakdownItem> categoryBreakdown;
  final List<String> spendingInsights;

  const FinanceAnalytics({
    required this.tripId,
    required this.totalSpent,
    required this.totalBudget,
    required this.projectedTotalSpend,
    required this.dailyAverageSpend,
    required this.topSpendingCategory,
    required this.categoryBreakdown,
    required this.spendingInsights,
  });

  factory FinanceAnalytics.fromJson(Map<String, dynamic> json) {
    return FinanceAnalytics(
      tripId: json['tripId'] as String? ?? '',
      totalSpent: (json['totalSpent'] as num?)?.toDouble() ?? 0.0,
      totalBudget: (json['totalBudget'] as num?)?.toDouble() ?? 50000.0,
      projectedTotalSpend: (json['projectedTotalSpend'] as num?)?.toDouble() ?? 0.0,
      dailyAverageSpend: (json['dailyAverageSpend'] as num?)?.toDouble() ?? 0.0,
      topSpendingCategory: json['topSpendingCategory'] as String? ?? 'Accommodation',
      categoryBreakdown: (json['categoryBreakdown'] as List<dynamic>?)?.map((e) => CategoryBreakdownItem.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      spendingInsights: (json['spendingInsights'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }
}
