import '../datasources/ai_copilot_remote_datasource.dart';
import '../../domain/entities/ai_conversation.dart';

class AiCopilotRepositoryImpl {
  final AiCopilotRemoteDataSource _dataSource;

  AiCopilotRepositoryImpl(this._dataSource);

  Future<AiConversation> createConversation({String? tripId}) => _dataSource.createConversation(tripId: tripId);
  Future<AiMessage> sendMessage(String conversationId, String message, {String? tripId}) => _dataSource.sendMessage(conversationId, message, tripId: tripId);
  Future<bool> confirmAction(String actionId) => _dataSource.confirmAction(actionId);
  Future<bool> rejectAction(String actionId) => _dataSource.rejectAction(actionId);
  Future<List<AiMemoryItem>> getMemories() => _dataSource.getMemories();
  Future<bool> deleteMemory(String memoryId) => _dataSource.deleteMemory(memoryId);
}
