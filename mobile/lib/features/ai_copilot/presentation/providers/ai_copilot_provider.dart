import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_providers.dart';
import '../../data/datasources/ai_copilot_remote_datasource.dart';
import '../../data/repositories/ai_copilot_repository_impl.dart';
import '../../domain/entities/ai_conversation.dart';

class AiCopilotState {
  final bool isLoading;
  final bool isThinking;
  final AiConversation? conversation;
  final List<AiMessage> messages;
  final String activeContextChip;
  final String? errorMessage;

  const AiCopilotState({
    this.isLoading = false,
    this.isThinking = false,
    this.conversation,
    this.messages = const [],
    this.activeContextChip = 'Goa Trip · Day 1 · Fort Aguada',
    this.errorMessage,
  });

  AiCopilotState copyWith({
    bool? isLoading,
    bool? isThinking,
    AiConversation? conversation,
    List<AiMessage>? messages,
    String? activeContextChip,
    String? errorMessage,
  }) {
    return AiCopilotState(
      isLoading: isLoading ?? this.isLoading,
      isThinking: isThinking ?? this.isThinking,
      conversation: conversation ?? this.conversation,
      messages: messages ?? this.messages,
      activeContextChip: activeContextChip ?? this.activeContextChip,
      errorMessage: errorMessage,
    );
  }
}

final aiCopilotRepositoryProvider = Provider<AiCopilotRepositoryImpl>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final ds = AiCopilotRemoteDataSourceImpl(apiClient.client);
  return AiCopilotRepositoryImpl(ds);
});

class AiCopilotNotifier extends StateNotifier<AiCopilotState> {
  final AiCopilotRepositoryImpl _repository;
  final String? tripId;

  AiCopilotNotifier(this._repository, this.tripId) : super(const AiCopilotState()) {
    initConversation();
  }

  Future<void> initConversation() async {
    state = state.copyWith(isLoading: true);
    try {
      final conv = await _repository.createConversation(tripId: tripId);
      final initialWelcome = AiMessage(
        id: 'msg-welcome',
        conversationId: conv.id,
        role: AiMessageRole.assistant,
        content: 'Hi Rameshwar! I\'m your Tripcraft Travel Copilot. I\'m tracking your Goa Trip (Aug 21-25). How can I help you plan or optimize your trip today?',
        createdAt: DateTime.now().toIso8601String(),
      );
      state = state.copyWith(
        isLoading: false,
        conversation: conv,
        activeContextChip: conv.activeContextChip,
        messages: [initialWelcome],
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || state.conversation == null) return;

    final userMsg = AiMessage(
      id: 'user-msg-${DateTime.now().millisecondsSinceEpoch}',
      conversationId: state.conversation!.id,
      role: AiMessageRole.user,
      content: text,
      createdAt: DateTime.now().toIso8601String(),
    );

    state = state.copyWith(
      isThinking: true,
      messages: [...state.messages, userMsg],
    );

    try {
      final reply = await _repository.sendMessage(state.conversation!.id, text, tripId: tripId);
      state = state.copyWith(
        isThinking: false,
        messages: [...state.messages, reply],
      );
    } catch (e) {
      state = state.copyWith(isThinking: false, errorMessage: 'Failed to send message');
    }
  }

  Future<bool> confirmAction(String actionId) async {
    final success = await _repository.confirmAction(actionId);
    if (success) {
      final updatedMessages = state.messages.map((m) {
        if (m.actionProposal != null && m.actionProposal!.id == actionId) {
          return AiMessage(
            id: m.id,
            conversationId: m.conversationId,
            role: m.role,
            content: m.content,
            cards: m.cards,
            actionProposal: m.actionProposal!.copyWith(status: 'applied'),
            createdAt: m.createdAt,
          );
        }
        return m;
      }).toList();

      state = state.copyWith(messages: updatedMessages);
    }
    return success;
  }

  Future<bool> rejectAction(String actionId) async {
    final success = await _repository.rejectAction(actionId);
    if (success) {
      final updatedMessages = state.messages.map((m) {
        if (m.actionProposal != null && m.actionProposal!.id == actionId) {
          return AiMessage(
            id: m.id,
            conversationId: m.conversationId,
            role: m.role,
            content: m.content,
            cards: m.cards,
            actionProposal: m.actionProposal!.copyWith(status: 'rejected'),
            createdAt: m.createdAt,
          );
        }
        return m;
      }).toList();

      state = state.copyWith(messages: updatedMessages);
    }
    return success;
  }

  void setActiveContextChip(String chipText) {
    state = state.copyWith(activeContextChip: chipText);
  }
}

final aiCopilotProvider = StateNotifierProvider.family<AiCopilotNotifier, AiCopilotState, String?>((ref, tripId) {
  final repo = ref.watch(aiCopilotRepositoryProvider);
  return AiCopilotNotifier(repo, tripId);
});
