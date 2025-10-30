import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../shared/models/user_model.dart';
import '../../../auth/presentation/auth_provider.dart';
import '../message_provider.dart';
import 'chat_screen.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  bool _conversationsLoaded = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final messageProvider = Provider.of<MessageProvider>(
        context,
        listen: false,
      );

      if (authProvider.userProfile != null && !_conversationsLoaded) {
        messageProvider.loadConversations(authProvider.userProfile!.id);
        _conversationsLoaded = true;
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: AppTheme.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Messages',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey[300]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: AppTheme.textSecondary,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search conversations...',
                          hintStyle: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 15,
                          ),
                          disabledBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          fillColor: Colors.white,
                          filled: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Messages List
          Consumer2<AuthProvider, MessageProvider>(
            builder: (context, authProvider, messageProvider, child) {
              if (authProvider.userProfile == null) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (messageProvider.isLoading &&
                  messageProvider.conversations.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (messageProvider.errorMessage != null) {
                return SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
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
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              messageProvider.loadConversations(
                                authProvider.userProfile!.id,
                              );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              if (messageProvider.conversations.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.chat_bubble_outline,
                              size: 64,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'No messages yet',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Start a conversation by connecting with service providers',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              // Filter conversations based on search
              final conversations = messageProvider.conversations.where((
                conversation,
              ) {
                if (_searchController.text.isEmpty) return true;
                return conversation.lastMessage.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                );
              }).toList();

              return SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final conversation = conversations[index];
                    final otherUserId = conversation.participants.firstWhere(
                      (id) => id != authProvider.userProfile!.id,
                    );

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseService.firestore
                          .collection(AppConstants.usersCollection)
                          .doc(otherUserId)
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox.shrink();
                        }

                        UserModel? otherUser;
                        try {
                          otherUser = UserModel.fromFirestore(snapshot.data!);
                        } catch (e) {
                          return const SizedBox.shrink();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildConversationCard(
                            context,
                            conversation.id,
                            otherUser,
                            conversation.lastMessage,
                            conversation.lastMessageTime,
                          ),
                        );
                      },
                    );
                  }, childCount: conversations.length),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConversationCard(
    BuildContext context,
    String conversationId,
    UserModel otherUser,
    String lastMessage,
    DateTime lastMessageTime,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              conversationId: conversationId,
              otherUserId: otherUser.id,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  otherUser.name.isNotEmpty
                      ? otherUser.name[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          otherUser.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppTheme.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatTime(lastMessageTime),
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    lastMessage.isEmpty ? 'Start a conversation' : lastMessage,
                    style: TextStyle(
                      color: lastMessage.isEmpty
                          ? AppTheme.textSecondary
                          : AppTheme.textSecondary.withOpacity(0.8),
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Badge
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
