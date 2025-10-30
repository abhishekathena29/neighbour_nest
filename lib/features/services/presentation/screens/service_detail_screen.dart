import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/models/service_model.dart';
import '../../../auth/presentation/auth_provider.dart';
import '../../../messaging/presentation/message_provider.dart';
import '../../../messaging/presentation/screens/chat_screen.dart';

class ServiceDetailScreen extends StatelessWidget {
  final ServiceModel service;

  const ServiceDetailScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Service Details'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.largePadding),
              decoration: const BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service.description,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (service.price != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '₹${service.price!.toInt()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      _buildInfoChip(
                        AppConstants.defaultCategories.firstWhere(
                          (cat) => cat['id'] == service.category,
                        )['name'],
                        Colors.white,
                        Colors.white.withOpacity(0.2),
                      ),
                      const SizedBox(width: 8),
                      _buildInfoChip(
                        service.serviceType.toString().split('.').last,
                        Colors.white,
                        Colors.white.withOpacity(0.2),
                      ),
                      if (service.isOnline) ...[
                        const SizedBox(width: 8),
                        _buildInfoChip(
                          'Online',
                          Colors.white,
                          Colors.white.withOpacity(0.2),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Information
                  _buildSection('Service Information', [
                    _buildInfoRow(
                      'Category',
                      AppConstants.defaultCategories.firstWhere(
                        (cat) => cat['id'] == service.category,
                      )['name'],
                    ),
                    _buildInfoRow(
                      'Type',
                      service.serviceType.toString().split('.').last,
                    ),
                    if (service.location != null)
                      _buildInfoRow('Location', service.location!),
                    if (service.availableFrom != null)
                      _buildInfoRow(
                        'Available From',
                        _formatDate(service.availableFrom!),
                      ),
                    if (service.availableTo != null)
                      _buildInfoRow(
                        'Available To',
                        _formatDate(service.availableTo!),
                      ),
                    _buildInfoRow(
                      'Max Participants',
                      service.maxParticipants.toString(),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // Pricing
                  if (service.price != null)
                    _buildSection('Pricing', [
                      _buildInfoRow('Price', '₹${service.price!.toInt()}'),
                      _buildInfoRow('Currency', service.currency ?? 'INR'),
                    ]),

                  const SizedBox(height: 24),

                  // Contact Information
                  if (service.contactInfo != null)
                    _buildSection('Contact Information', [
                      _buildInfoRow('Contact', service.contactInfo!),
                    ]),

                  const SizedBox(height: 24),

                  // Tags
                  if (service.tags.isNotEmpty)
                    _buildSection('Tags', [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: service.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ]),

                  const SizedBox(height: 24),

                  // Rating
                  if (service.rating > 0)
                    _buildSection('Rating', [
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              index < service.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 20,
                            );
                          }),
                          const SizedBox(width: 8),
                          Text(
                            '${service.rating.toStringAsFixed(1)} (${service.totalRatings} reviews)',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ]),

                  const SizedBox(height: 32),

                  // Action Buttons
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      if (authProvider.userProfile == null)
                        return const SizedBox();

                      final isCustomer =
                          authProvider.userProfile!.userType.toString() ==
                          'UserType.customer';

                      if (isCustomer) {
                        return Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _showContactDialog(context);
                                },
                                icon: const Icon(Icons.message),
                                label: const Text('Contact Service Provider'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppConstants.borderRadius,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Book Service - Coming Soon',
                                      ),
                                      backgroundColor: AppTheme.primaryColor,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.book_online),
                                label: const Text('Book Service'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTheme.primaryColor,
                                  side: const BorderSide(
                                    color: AppTheme.primaryColor,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppConstants.borderRadius,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Edit Service - Coming Soon'),
                                  backgroundColor: AppTheme.primaryColor,
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit Service'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.secondaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadius,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppTheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, Color textColor, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showContactDialog(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final messageProvider = Provider.of<MessageProvider>(
      context,
      listen: false,
    );

    if (authProvider.userProfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to start a conversation'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Create or get conversation
      final conversationId = await messageProvider.createConversation(
        participant1Id: authProvider.userProfile!.id,
        participant2Id: service.contributorId,
        serviceId: service.id,
      );

      // Close loading dialog
      if (context.mounted) {
        Navigator.pop(context);
      }

      if (conversationId != null) {
        // Navigate to chat screen
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                conversationId: conversationId,
                otherUserId: service.contributorId,
                service: service,
              ),
            ),
          );
        }
      } else {
        // Show error
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to start conversation. Please try again.'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.pop(context);
      }

      // Show error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}
