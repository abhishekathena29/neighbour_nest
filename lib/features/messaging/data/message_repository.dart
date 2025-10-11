import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/message_model.dart';

class MessageRepository {
  final FirebaseFirestore _firestore = FirebaseService.firestore;

  // Create a conversation
  Future<String> createConversation({
    required String participant1Id,
    required String participant2Id,
    required String serviceId,
  }) async {
    try {
      // Check if conversation already exists
      final existingConversation = await _firestore
          .collection(AppConstants.conversationsCollection)
          .where('participants', arrayContains: participant1Id)
          .where('serviceId', isEqualTo: serviceId)
          .get();

      if (existingConversation.docs.isNotEmpty) {
        return existingConversation.docs.first.id;
      }

      // Create new conversation
      final conversationData = {
        'participants': [participant1Id, participant2Id],
        'serviceId': serviceId,
        'lastMessage': '',
        'lastMessageTime': Timestamp.now(),
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      };

      final docRef = await _firestore
          .collection(AppConstants.conversationsCollection)
          .add(conversationData);

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create conversation: $e');
    }
  }

  // Get user conversations
  Stream<List<ConversationModel>> getUserConversations(String userId) {
    return _firestore
        .collection(AppConstants.conversationsCollection)
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ConversationModel.fromFirestore(doc))
              .toList();
        });
  }

  // Get conversation messages
  Stream<List<MessageModel>> getConversationMessages(String conversationId) {
    return _firestore
        .collection(AppConstants.conversationsCollection)
        .doc(conversationId)
        .collection(AppConstants.messagesCollection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => MessageModel.fromFirestore(doc))
              .toList();
        });
  }

  // Send a message
  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
    required MessageType type,
  }) async {
    try {
      final message = MessageModel(
        id: '',
        conversationId: conversationId,
        senderId: senderId,
        content: content,
        type: type,
        timestamp: DateTime.now(),
        isRead: false,
      );

      // Add message to conversation
      await _firestore
          .collection(AppConstants.conversationsCollection)
          .doc(conversationId)
          .collection(AppConstants.messagesCollection)
          .add(message.toFirestore());

      // Update conversation last message
      await _firestore
          .collection(AppConstants.conversationsCollection)
          .doc(conversationId)
          .update({
            'lastMessage': content,
            'lastMessageTime': Timestamp.now(),
            'updatedAt': Timestamp.now(),
          });
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String conversationId, String userId) async {
    try {
      final messages = await _firestore
          .collection(AppConstants.conversationsCollection)
          .doc(conversationId)
          .collection(AppConstants.messagesCollection)
          .where('senderId', isNotEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      final batch = _firestore.batch();
      for (final doc in messages.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to mark messages as read: $e');
    }
  }

  // Get unread message count for user
  Stream<int> getUnreadMessageCount(String userId) {
    return _firestore
        .collection(AppConstants.conversationsCollection)
        .where('participants', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
          int totalUnread = 0;
          // This is a simplified version - in production, you'd want to optimize this
          // by storing unread counts in the conversation document
          totalUnread = snapshot.docs.length; // Placeholder
          return totalUnread;
        });
  }
}
