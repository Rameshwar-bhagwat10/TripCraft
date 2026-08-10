import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../domain/entities/ai_conversation.dart';
import 'ai_action_card.dart';

class AiMessageBubble extends StatelessWidget {
  final AiMessage message;
  final Function(AiActionProposal)? onConfirmAction;

  const AiMessageBubble({
    super.key,
    required this.message,
    this.onConfirmAction,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == AiMessageRole.user;

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.space14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.primarySurface,
                shape: BoxShape.circle,
              ),
              child: const Icon(PhosphorIconsFill.sparkle, color: AppColors.primary, size: 16),
            ),
            const SizedBox(width: AppDimensions.space10),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimensions.space14),
                  decoration: BoxDecoration(
                    color: isUser ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(16).copyWith(
                      bottomRight: isUser ? Radius.zero : null,
                      bottomLeft: !isUser ? Radius.zero : null,
                    ),
                    border: Border.all(
                      color: isUser ? AppColors.primary : AppColors.border,
                    ),
                    boxShadow: [
                      if (!isUser)
                        const BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.02),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Text(
                    message.content,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isUser ? Colors.white : AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
                if (message.actionProposal != null) ...[
                  const SizedBox(height: AppDimensions.space10),
                  AiActionCard(
                    proposal: message.actionProposal!,
                    onConfirm: () => onConfirmAction?.call(message.actionProposal!),
                  ),
                ],
              ],
            ),
          ),
          if (isUser) const SizedBox(width: 40),
        ],
      ),
    );
  }
}
