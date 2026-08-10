import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/feedback/app_snackbar.dart';

import '../../domain/entities/ai_conversation.dart';
import '../providers/ai_copilot_provider.dart';
import '../widgets/ai_confirmation_sheet.dart';
import '../widgets/ai_context_chip.dart';
import '../widgets/ai_message_bubble.dart';
import '../widgets/ai_suggestion_chip.dart';

class AiCopilotScreen extends ConsumerStatefulWidget {
  final String? tripId;

  const AiCopilotScreen({
    super.key,
    this.tripId,
  });

  @override
  ConsumerState<AiCopilotScreen> createState() => _AiCopilotScreenState();
}

class _AiCopilotScreenState extends ConsumerState<AiCopilotScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  final List<String> _suggestions = const [
    'Check weather risks tomorrow',
    'Move Baga Beach to morning',
    'Find a quiet cafe nearby',
    'Make Day 2 less rushed',
    'Summarize my Goa trip',
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend([String? presetText]) {
    final query = presetText ?? _textController.text;
    if (query.trim().isEmpty) return;

    HapticFeedback.lightImpact();
    if (presetText == null) _textController.clear();

    ref.read(aiCopilotProvider(widget.tripId).notifier).sendMessage(query);
    _scrollToBottom();
  }

  void _showActionConfirmation(AiActionProposal proposal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AiConfirmationSheet(
          proposal: proposal,
          onApply: () async {
            final res = await ref.read(aiCopilotProvider(widget.tripId).notifier).confirmAction(proposal.id);
            if (context.mounted && res) {
              AppSnackBar.show(context, message: 'Action applied: ${proposal.title}');
            }
          },
          onReject: () async {
            await ref.read(aiCopilotProvider(widget.tripId).notifier).rejectAction(proposal.id);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiCopilotProvider(widget.tripId));

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Column(
          children: [
            Text('Tripcraft AI Copilot', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            AiContextChip(labelText: state.activeContextChip),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsRegular.brain, color: AppColors.textPrimary),
            onPressed: () => context.push('/profile/ai-memories'),
            tooltip: 'AI Memories',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Messages Scroll Area
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(AppDimensions.pageMargin),
                      itemCount: state.messages.length + (state.isThinking ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.messages.length && state.isThinking) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primarySurface,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Copilot is reasoning & checking tools...',
                                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                          );
                        }

                        final msg = state.messages[index];
                        return AiMessageBubble(
                          message: msg,
                          onConfirmAction: (prop) => _showActionConfirmation(prop),
                        );
                      },
                    ),
            ),

            // Prompt Suggestions Carousel
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageMargin),
                itemCount: _suggestions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final prompt = _suggestions[index];
                  return AiSuggestionChip(
                    label: prompt,
                    onTap: () => _handleSend(prompt),
                  );
                },
              ),
            ),
            const SizedBox(height: AppDimensions.space10),

            // Keyboard-Safe iOS Input Bar
            Padding(
              padding: const EdgeInsets.all(AppDimensions.pageMargin),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.border),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.04),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _textController,
                        style: AppTypography.bodyMedium,
                        decoration: const InputDecoration(
                          hintText: 'Ask Copilot anything about your trip...',
                          hintStyle: TextStyle(color: AppColors.textTertiary),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _handleSend(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: IconButton(
                      icon: const Icon(PhosphorIconsBold.paperPlaneRight, color: Colors.white, size: 18),
                      onPressed: () => _handleSend(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}