import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tripcraft/features/ai_copilot/data/repositories/ai_copilot_repository_impl.dart';
import 'package:tripcraft/features/ai_copilot/domain/entities/ai_conversation.dart';
import 'package:tripcraft/features/ai_copilot/presentation/providers/ai_copilot_provider.dart';
import 'package:tripcraft/features/ai_copilot/presentation/screens/ai_copilot_screen.dart';

class FakeAiCopilotRepository implements AiCopilotRepositoryImpl {
  @override
  Future<AiConversation> createConversation({String? tripId}) async {
    return AiConversation(
      id: 'conv-test-1',
      title: 'Goa Trip Copilot Chat',
      tripId: tripId ?? 'trip-goa-escape',
      activeContextChip: 'Goa Trip · Day 1 · Fort Aguada',
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<AiMessage> sendMessage(String conversationId, String message, {String? tripId}) async {
    return AiMessage(
      id: 'msg-test-reply',
      conversationId: conversationId,
      role: AiMessageRole.assistant,
      content: 'Here is the current weather forecast for your Goa trip.',
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<bool> confirmAction(String actionId) async => true;

  @override
  Future<bool> rejectAction(String actionId) async => true;

  @override
  Future<List<AiMemoryItem>> getMemories() async => [];

  @override
  Future<bool> deleteMemory(String memoryId) async => true;
}

void main() {
  testWidgets('AiCopilotScreen renders title, active context chip, suggestions and input bar', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          aiCopilotRepositoryProvider.overrideWithValue(FakeAiCopilotRepository()),
        ],
        child: const MaterialApp(
          home: AiCopilotScreen(tripId: 'test-trip-1'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Tripcraft AI Copilot'), findsOneWidget);
    expect(find.text('Goa Trip · Day 1 · Fort Aguada'), findsOneWidget);
    expect(find.text('Check weather risks tomorrow'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}
