import 'package:flutter/material.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../ai_copilot/domain/entities/ai_conversation.dart';
import '../../../ai_copilot/presentation/widgets/ai_context_chip.dart';
import '../../../ai_copilot/presentation/widgets/ai_message_bubble.dart';
import '../../../ai_copilot/presentation/widgets/ai_suggestion_chip.dart';

class AiCopilotComponentsSection extends StatelessWidget {
  const AiCopilotComponentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI COPILOT COMPONENTS',
          style: AppTypography.labelSmall.copyWith(color: Colors.grey[600], letterSpacing: 1.2),
        ),
        const SizedBox(height: AppDimensions.space12),

        const AiContextChip(labelText: 'Goa Trip · Day 2 · Baga Beach'),
        const SizedBox(height: AppDimensions.space12),

        AiMessageBubble(
          message: AiMessage(
            id: 'demo-msg-1',
            conversationId: 'demo-conv',
            role: AiMessageRole.assistant,
            content: 'I\'ve analyzed your itinerary against afternoon rain conditions on Day 2.',
            actionProposal: const AiActionProposal(
              id: 'prop-demo',
              type: 'move_activity',
              title: 'Move Baga Beach Watersports',
              description: 'Reschedule beach visit to sunny morning window.',
              currentValue: '03:00 PM (Heavy Rain Risk)',
              proposedValue: '10:00 AM (Sunny Window)',
              reason: 'Avoids 85% rain probability and reduces travel time by 18 mins.',
              riskLevel: ActionRiskLevel.medium,
            ),
            createdAt: DateTime.now().toIso8601String(),
          ),
        ),
        const SizedBox(height: AppDimensions.space12),

        Row(
          children: [
            AiSuggestionChip(label: 'Optimize tomorrow', onTap: () {}),
            const SizedBox(width: 8),
            AiSuggestionChip(label: 'Check weather', onTap: () {}),
          ],
        ),
      ],
    );
  }
}
