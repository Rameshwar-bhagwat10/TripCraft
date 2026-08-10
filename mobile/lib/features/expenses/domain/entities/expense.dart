import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';

enum ExpenseCategory {
  accommodation,
  transport,
  food,
  activities,
  shopping,
  entertainment,
  flights,
  localTransport,
  insurance,
  other,
}

class ExpenseCategoryConfig {
  final ExpenseCategory category;
  final String label;
  final IconData icon;
  final Color color;

  const ExpenseCategoryConfig({
    required this.category,
    required this.label,
    required this.icon,
    required this.color,
  });

  static const Map<ExpenseCategory, ExpenseCategoryConfig> _configs = {
    ExpenseCategory.accommodation: ExpenseCategoryConfig(category: ExpenseCategory.accommodation, label: 'Accommodation', icon: PhosphorIconsFill.buildings, color: Colors.blue),
    ExpenseCategory.transport: ExpenseCategoryConfig(category: ExpenseCategory.transport, label: 'Transportation', icon: PhosphorIconsFill.car, color: Colors.indigo),
    ExpenseCategory.food: ExpenseCategoryConfig(category: ExpenseCategory.food, label: 'Food & Dining', icon: PhosphorIconsFill.forkKnife, color: Colors.orange),
    ExpenseCategory.activities: ExpenseCategoryConfig(category: ExpenseCategory.activities, label: 'Activities', icon: PhosphorIconsFill.ticket, color: Colors.purple),
    ExpenseCategory.shopping: ExpenseCategoryConfig(category: ExpenseCategory.shopping, label: 'Shopping', icon: PhosphorIconsFill.shoppingBag, color: Colors.pink),
    ExpenseCategory.entertainment: ExpenseCategoryConfig(category: ExpenseCategory.entertainment, label: 'Entertainment', icon: PhosphorIconsFill.filmStrip, color: Colors.deepPurple),
    ExpenseCategory.flights: ExpenseCategoryConfig(category: ExpenseCategory.flights, label: 'Flights', icon: PhosphorIconsFill.airplaneTilt, color: Colors.teal),
    ExpenseCategory.localTransport: ExpenseCategoryConfig(category: ExpenseCategory.localTransport, label: 'Local Transport', icon: PhosphorIconsFill.bus, color: Colors.amber),
    ExpenseCategory.insurance: ExpenseCategoryConfig(category: ExpenseCategory.insurance, label: 'Insurance', icon: PhosphorIconsFill.shieldCheck, color: Colors.green),
    ExpenseCategory.other: ExpenseCategoryConfig(category: ExpenseCategory.other, label: 'Other', icon: PhosphorIconsFill.receipt, color: AppColors.primary),
  };

  static ExpenseCategoryConfig getConfig(ExpenseCategory category) {
    return _configs[category] ?? _configs[ExpenseCategory.other]!;
  }

  static ExpenseCategory fromString(String str) {
    switch (str.toLowerCase()) {
      case 'accommodation':
        return ExpenseCategory.accommodation;
      case 'transport':
      case 'transportation':
        return ExpenseCategory.transport;
      case 'food':
      case 'dining':
        return ExpenseCategory.food;
      case 'activities':
        return ExpenseCategory.activities;
      case 'shopping':
        return ExpenseCategory.shopping;
      case 'entertainment':
        return ExpenseCategory.entertainment;
      case 'flights':
        return ExpenseCategory.flights;
      case 'local_transport':
        return ExpenseCategory.localTransport;
      case 'insurance':
        return ExpenseCategory.insurance;
      case 'other':
      default:
        return ExpenseCategory.other;
    }
  }
}

class Expense {
  final String id;
  final String tripId;
  final String userId;
  final ExpenseCategory category;
  final String categoryName;
  final String title;
  final String? description;
  final double amount;
  final String currency;
  final double baseAmount;
  final String baseCurrency;
  final double exchangeRate;
  final String expenseDate;
  final String payerId;
  final String payerName;
  final String paymentMethod;
  final String? bookingId;
  final String? itineraryActivityId;
  final String? receiptDocumentId;
  final String? notes;
  final String createdAt;

  const Expense({
    required this.id,
    required this.tripId,
    required this.userId,
    required this.category,
    required this.categoryName,
    required this.title,
    this.description,
    required this.amount,
    required this.currency,
    required this.baseAmount,
    required this.baseCurrency,
    required this.exchangeRate,
    required this.expenseDate,
    required this.payerId,
    required this.payerName,
    required this.paymentMethod,
    this.bookingId,
    this.itineraryActivityId,
    this.receiptDocumentId,
    this.notes,
    required this.createdAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String? ?? '',
      tripId: json['tripId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      category: ExpenseCategoryConfig.fromString(json['categoryId'] as String? ?? 'other'),
      categoryName: json['categoryName'] as String? ?? 'Other',
      title: json['title'] as String? ?? 'Travel Expense',
      description: json['description'] as String?,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'INR',
      baseAmount: (json['baseAmount'] as num?)?.toDouble() ?? 0.0,
      baseCurrency: json['baseCurrency'] as String? ?? 'INR',
      exchangeRate: (json['exchangeRate'] as num?)?.toDouble() ?? 1.0,
      expenseDate: json['expenseDate'] as String? ?? DateTime.now().toIso8601String(),
      payerId: json['payerId'] as String? ?? '',
      payerName: json['payerName'] as String? ?? 'Payer',
      paymentMethod: json['paymentMethod'] as String? ?? 'card',
      bookingId: json['bookingId'] as String?,
      itineraryActivityId: json['itineraryActivityId'] as String?,
      receiptDocumentId: json['receiptDocumentId'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }
}
