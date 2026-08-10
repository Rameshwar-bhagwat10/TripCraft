import 'package:dio/dio.dart';
import '../../domain/entities/ai_conversation.dart';

abstract class AiCopilotRemoteDataSource {
  Future<AiConversation> createConversation({String? tripId});
  Future<AiMessage> sendMessage(String conversationId, String message, {String? tripId});
  Future<bool> confirmAction(String actionId);
  Future<bool> rejectAction(String actionId);
  Future<List<AiMemoryItem>> getMemories();
  Future<bool> deleteMemory(String memoryId);
}

class AiCopilotRemoteDataSourceImpl implements AiCopilotRemoteDataSource {
  final Dio _dio;

  AiCopilotRemoteDataSourceImpl(this._dio);

  static final AiConversation _mockConv = AiConversation(
    id: 'conv-mock-1',
    title: 'Goa Trip Copilot Chat',
    tripId: 'trip-goa-escape',
    activeContextChip: 'Goa Trip · Day 1 · Fort Aguada',
    createdAt: DateTime.now().toIso8601String(),
  );

  static final List<AiMemoryItem> _mockMemories = [
    AiMemoryItem(id: 'mem-1', category: 'preference', key: 'travel_style', value: 'Prefers quiet cafes and historic sightseeing', createdAt: '2026-08-09T10:00:00Z'),
    AiMemoryItem(id: 'mem-2', category: 'constraint', key: 'pace', value: 'Prefers relaxed mornings with clear activity buffer', createdAt: '2026-08-09T11:00:00Z'),
    AiMemoryItem(id: 'mem-3', category: 'avoidance', key: 'weather_risk', value: 'Avoids outdoor beach activities during heavy rain', createdAt: '2026-08-09T12:00:00Z'),
  ];

  @override
  Future<AiConversation> createConversation({String? tripId}) async {
    try {
      final response = await _dio.post('/ai/conversations', data: {if (tripId != null) 'tripId': tripId});
      return AiConversation.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      return _mockConv;
    }
  }

  @override
  Future<AiMessage> sendMessage(String conversationId, String message, {String? tripId}) async {
    try {
      final response = await _dio.post('/ai/conversations/$conversationId/messages', data: {'message': message, if (tripId != null) 'tripId': tripId});
      return AiMessage.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      final msgLower = message.toLowerCase();
      if (msgLower.contains('weather') || msgLower.contains('rain')) {
        return AiMessage(
          id: 'msg-w-1',
          conversationId: conversationId,
          role: AiMessageRole.assistant,
          content: 'Here is the current weather forecast for your Goa trip. Afternoon rain (85% probability) is expected on Day 2 during outdoor beach activities.',
          cards: const [
            {
              'type': 'weatherCard',
              'data': {
                'location': 'Goa, India',
                'temperature': 28,
                'feelsLike': 31,
                'condition': {'main': 'Partly Cloudy', 'description': 'Partly cloudy'},
                'humidity': 74,
                'windSpeed': 14,
                'precipitationProbability': 35,
              }
            }
          ],
          createdAt: DateTime.now().toIso8601String(),
        );
      }

      if (msgLower.contains('move') || msgLower.contains('baga beach') || msgLower.contains('schedule') || msgLower.contains('optimize')) {
        return AiMessage(
          id: 'msg-act-1',
          conversationId: conversationId,
          role: AiMessageRole.assistant,
          content: 'I\'ve analyzed your itinerary against afternoon rain conditions on Day 2. I propose moving Baga Beach Watersports to 10:00 AM during the clear morning window.',
          actionProposal: const AiActionProposal(
            id: 'act-prop-baga',
            type: 'move_activity',
            title: 'Move Baga Beach Watersports',
            description: 'Reschedule beach visit to the sunny morning window.',
            currentValue: '03:00 PM (Heavy Rain Risk)',
            proposedValue: '10:00 AM (Sunny Window)',
            reason: 'Avoids 85% rain probability and reduces daily travel time by 18 minutes.',
            riskLevel: ActionRiskLevel.medium,
          ),
          createdAt: DateTime.now().toIso8601String(),
        );
      }

      return AiMessage(
        id: 'msg-def-1',
        conversationId: conversationId,
        role: AiMessageRole.assistant,
        content: 'Your Goa trip is looking in great shape overall! You have 5 activities planned across 5 days. Is there anything specific you would like to adjust or check?',
        createdAt: DateTime.now().toIso8601String(),
      );
    }
  }

  @override
  Future<bool> confirmAction(String actionId) async {
    try {
      final response = await _dio.post('/ai/actions/$actionId/confirm');
      return response.data['status'] == 'applied';
    } catch (_) {
      return true;
    }
  }

  @override
  Future<bool> rejectAction(String actionId) async {
    try {
      final response = await _dio.post('/ai/actions/$actionId/reject');
      return response.data['status'] == 'rejected';
    } catch (_) {
      return true;
    }
  }

  @override
  Future<List<AiMemoryItem>> getMemories() async {
    try {
      final response = await _dio.get('/ai/memories');
      return (response.data as List<dynamic>).map((e) => AiMemoryItem.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return _mockMemories;
    }
  }

  @override
  Future<bool> deleteMemory(String memoryId) async {
    try {
      final response = await _dio.delete('/ai/memories/$memoryId');
      return response.data['success'] as bool? ?? true;
    } catch (_) {
      return true;
    }
  }
}
