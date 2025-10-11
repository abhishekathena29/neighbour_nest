import 'package:flutter/foundation.dart';
import '../../../shared/models/message_model.dart';
import '../data/message_repository.dart';

class MessageProvider with ChangeNotifier {
  final MessageRepository _messageRepository = MessageRepository();

  List<ConversationModel> _conversations = [];
  List<MessageModel> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _unreadCount = 0;

  List<ConversationModel> get conversations => _conversations;
  List<MessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get unreadCount => _unreadCount;

  // Load user conversations
  void loadConversations(String userId) {
    _setLoading(true);
    _clearError();

    _messageRepository
        .getUserConversations(userId)
        .listen(
          (conversations) {
            _conversations = conversations;
            _setLoading(false);
          },
          onError: (error) {
            _errorMessage = error.toString();
            _setLoading(false);
          },
        );
  }

  // Load conversation messages
  void loadMessages(String conversationId) {
    _setLoading(true);
    _clearError();

    _messageRepository
        .getConversationMessages(conversationId)
        .listen(
          (messages) {
            _messages = messages;
            _setLoading(false);
          },
          onError: (error) {
            _errorMessage = error.toString();
            _setLoading(false);
          },
        );
  }

  // Create conversation
  Future<String?> createConversation({
    required String participant1Id,
    required String participant2Id,
    required String serviceId,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final conversationId = await _messageRepository.createConversation(
        participant1Id: participant1Id,
        participant2Id: participant2Id,
        serviceId: serviceId,
      );
      _setLoading(false);
      return conversationId;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return null;
    }
  }

  // Send message
  Future<bool> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
    MessageType type = MessageType.text,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _messageRepository.sendMessage(
        conversationId: conversationId,
        senderId: senderId,
        content: content,
        type: type,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String conversationId, String userId) async {
    try {
      await _messageRepository.markMessagesAsRead(conversationId, userId);
    } catch (e) {
      _errorMessage = e.toString();
    }
  }

  // Load unread count
  void loadUnreadCount(String userId) {
    _messageRepository
        .getUnreadMessageCount(userId)
        .listen(
          (count) {
            _unreadCount = count;
            notifyListeners();
          },
          onError: (error) {
            _errorMessage = error.toString();
          },
        );
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
