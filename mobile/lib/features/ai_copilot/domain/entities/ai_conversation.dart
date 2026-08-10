import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';

enum AiMessageRole {
  user,
  assistant,
  tool,
  system,
}

enum ActionRiskLevel {
  low,
  medium,
  high,
}

class ActionRiskLevelConfig {
  final ActionRiskLevel level;
  final String label;
  final IconData icon;
  final Color color;

  const ActionRiskLevelConfig({
    required this.level,
    required this.label,
    required this.icon,
    required this.color,
  });

  static const Map<ActionRiskLevel, ActionRiskLevelConfig> _configs = {
    ActionRiskLevel.low: ActionRiskLevelConfig(level: ActionRiskLevel.low, label: 'Low Risk', icon: PhosphorIconsFill.info, color: AppColors.primary),
    ActionRiskLevel.medium: ActionRiskLevelConfig(level: ActionRiskLevel.medium, label: 'Medium Risk', icon: PhosphorIconsFill.warning, color: Colors.orange),
    ActionRiskLevel.high: ActionRiskLevelConfig(level: ActionRiskLevel.high, label: 'High Risk', icon: PhosphorIconsFill.warningOctagon, color: AppColors.error),
  };

  static ActionRiskLevelConfig getConfig(ActionRiskLevel level) {
    return _configs[level] ?? _configs[ActionRiskLevel.medium]!;
  }

  static ActionRiskLevel fromString(String str) {
    switch (str.toLowerCase()) {
      case 'low':
        return ActionRiskLevel.low;
      case 'high':
        return ActionRiskLevel.high;
      case 'medium':
      default:
        return ActionRiskLevel.medium;
    }
  }
}

class AiActionProposal {
  final String id;
  final String type;
  final String title;
  final String description;
  final String currentValue;
  final String proposedValue;
  final String reason;
  final ActionRiskLevel riskLevel;
  final String status; // proposed, applied, rejected

  const AiActionProposal({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.currentValue,
    required this.proposedValue,
    required this.reason,
    required this.riskLevel,
    this.status = 'proposed',
  });

  factory AiActionProposal.fromJson(Map<String, dynamic> json) {
    return AiActionProposal(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? 'general_action',
      title: json['title'] as String? ?? 'Proposed Action',
      description: json['description'] as String? ?? '',
      currentValue: json['currentValue'] as String? ?? '',
      proposedValue: json['proposedValue'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      riskLevel: ActionRiskLevelConfig.fromString(json['riskLevel'] as String? ?? 'medium'),
      status: json['status'] as String? ?? 'proposed',
    );
  }

  AiActionProposal copyWith({String? status}) {
    return AiActionProposal(
      id: id,
      type: type,
      title: title,
      description: description,
      currentValue: currentValue,
      proposedValue: proposedValue,
      reason: reason,
      riskLevel: riskLevel,
      status: status ?? this.status,
    );
  }
}

class AiMessage {
  final String id;
  final String conversationId;
  final AiMessageRole role;
  final String content;
  final List<dynamic>? cards;
  final AiActionProposal? actionProposal;
  final String createdAt;

  const AiMessage({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.content,
    this.cards,
    this.actionProposal,
    required this.createdAt,
  });

  factory AiMessage.fromJson(Map<String, dynamic> json) {
    final roleStr = json['role'] as String? ?? 'assistant';
    final role = roleStr == 'user'
        ? AiMessageRole.user
        : (roleStr == 'system' ? AiMessageRole.system : AiMessageRole.assistant);

    return AiMessage(
      id: json['id'] as String? ?? '',
      conversationId: json['conversationId'] as String? ?? '',
      role: role,
      content: json['content'] as String? ?? '',
      cards: json['cards'] as List<dynamic>?,
      actionProposal: json['actionProposal'] != null
          ? AiActionProposal.fromJson(json['actionProposal'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }
}

class AiConversation {
  final String id;
  final String title;
  final String? tripId;
  final String activeContextChip;
  final String createdAt;

  const AiConversation({
    required this.id,
    required this.title,
    this.tripId,
    required this.activeContextChip,
    required this.createdAt,
  });

  factory AiConversation.fromJson(Map<String, dynamic> json) {
    return AiConversation(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Tripcraft Copilot',
      tripId: json['tripId'] as String?,
      activeContextChip: json['activeContextChip'] as String? ?? 'Goa Trip · Day 1',
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }
}

class AiMemoryItem {
  final String id;
  final String category;
  final String key;
  final String value;
  final String createdAt;

  const AiMemoryItem({
    required this.id,
    required this.category,
    required this.key,
    required this.value,
    required this.createdAt,
  });

  factory AiMemoryItem.fromJson(Map<String, dynamic> json) {
    return AiMemoryItem(
      id: json['id'] as String? ?? '',
      category: json['category'] as String? ?? 'preference',
      key: json['key'] as String? ?? '',
      value: json['value'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }
}
