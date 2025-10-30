import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../shared/models/message_model.dart';
import '../../../../shared/models/service_model.dart';
import '../../../../shared/models/user_model.dart';
import '../../../auth/presentation/auth_provider.dart';
import '../message_provider.dart';

class ChatScreen extends StatefulWidget {
  final String conversationId;
  final String otherUserId;
  final ServiceModel? service;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.otherUserId,
    this.service,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  UserModel? _otherUser;
  bool _loadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadOtherUser();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final messageProvider = Provider.of<MessageProvider>(
        context,
        listen: false,
      );
      messageProvider.loadMessages(widget.conversationId);
    });
  }

  Future<void> _loadOtherUser() async {
    try {
      final doc = await FirebaseService.firestore
          .collection(AppConstants.usersCollection)
          .doc(widget.otherUserId)
          .get();

      if (doc.exists && mounted) {
        setState(() {
          _otherUser = UserModel.fromFirestore(doc);
          _loadingUser = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingUser = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: _loadingUser
            ? const CircularProgressIndicator()
            : Row(
                children: [
                  // Avatar with initials
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppTheme.primaryColor,
                    child: Text(
                      _otherUser != null && _otherUser!.name.isNotEmpty
                          ? _otherUser!.name
                                .split(' ')
                                .map((word) => word.isNotEmpty ? word[0] : '')
                                .take(2)
                                .join()
                                .toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Name and service
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _otherUser?.name ?? 'User',
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.service != null)
                          Text(
                            widget.service!.title,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF6BCBA4),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: AppTheme.textPrimary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Voice call - Coming Soon'),
                  backgroundColor: AppTheme.primaryColor,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam, color: AppTheme.textPrimary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Video call - Coming Soon'),
                  backgroundColor: AppTheme.primaryColor,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Service Info Banner (shown when chatting about a specific service)
          if (widget.service != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.work_outline,
                      color: AppTheme.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Service Discussion',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.service!.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.service!.price != null)
                          Text(
                            '₹${widget.service!.price!.toInt()}',
                            style: const TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6BCBA4).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Active',
                      style: TextStyle(
                        color: Color(0xFF6BCBA4),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Messages List
          Expanded(
            child: Consumer<MessageProvider>(
              builder: (context, messageProvider, child) {
                if (messageProvider.isLoading &&
                    messageProvider.messages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (messageProvider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          messageProvider.errorMessage!,
                          style: const TextStyle(color: AppTheme.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            messageProvider.loadMessages(widget.conversationId);
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (messageProvider.messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chat_bubble_outline,
                            size: 48,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No messages yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Start the conversation!',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                return Container(
                  color: const Color(0xFFE8F4F8),
                  child: ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    itemCount: messageProvider.messages.length,
                    itemBuilder: (context, index) {
                      final message = messageProvider.messages[index];
                      final showDate =
                          index == messageProvider.messages.length - 1 ||
                          !_isSameDay(
                            message.timestamp,
                            messageProvider.messages[index + 1].timestamp,
                          );

                      return Column(
                        children: [
                          if (showDate) _buildDateDivider(message.timestamp),
                          _buildMessageBubble(message),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),

          // Message Input
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Consumer<MessageProvider>(
                  builder: (context, messageProvider, child) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryColor,
                            AppTheme.primaryColor.withOpacity(0.8),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: messageProvider.isLoading
                            ? null
                            : _sendMessage,
                        icon: messageProvider.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(Icons.send, color: Colors.white),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateDivider(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(date.year, date.month, date.day);

    String dateText;
    if (messageDate == today) {
      dateText = 'Today';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      dateText = 'Yesterday';
    } else {
      dateText = '${date.day}/${date.month}/${date.year}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            dateText,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Widget _buildMessageBubble(MessageModel message) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isMe = message.senderId == authProvider.userProfile?.id;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primaryColor,
              child: Text(
                _otherUser != null && _otherUser!.name.isNotEmpty
                    ? _otherUser!.name[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: isMe
                    ? LinearGradient(
                        colors: [
                          AppTheme.primaryColor,
                          AppTheme.primaryColor.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isMe ? null : Colors.white,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: isMe
                      ? const Radius.circular(20)
                      : const Radius.circular(4),
                  bottomRight: isMe
                      ? const Radius.circular(4)
                      : const Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isMe ? Colors.white : AppTheme.textPrimary,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: isMe
                          ? Colors.white.withOpacity(0.8)
                          : AppTheme.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '$displayHour:$minute $period';
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final messageProvider = Provider.of<MessageProvider>(
      context,
      listen: false,
    );

    if (authProvider.userProfile == null) return;

    _messageController.clear();

    final success = await messageProvider.sendMessage(
      conversationId: widget.conversationId,
      senderId: authProvider.userProfile!.id,
      content: content,
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            messageProvider.errorMessage ?? 'Failed to send message',
          ),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }
}
