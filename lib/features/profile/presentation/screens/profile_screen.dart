import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/models/user_model.dart';
import '../../../auth/presentation/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.userProfile;

        if (user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            title: const Text('Profile'),
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppConstants.largePadding),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Profile Image
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                        child: user.profileImageUrl != null
                            ? ClipOval(
                                child: Image.network(
                                  user.profileImageUrl!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Icons.person,
                                size: 50,
                                color: AppTheme.primaryColor,
                              ),
                      ),
                      const SizedBox(height: 16),

                      // User Name
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                      ),
                      const SizedBox(height: 8),

                      // User Type
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: user.userType == UserType.contributor
                              ? AppTheme.primaryColor.withOpacity(0.1)
                              : AppTheme.secondaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          user.userType == UserType.contributor
                              ? 'Contributor'
                              : 'Customer',
                          style: TextStyle(
                            color: user.userType == UserType.contributor
                                ? AppTheme.primaryColor
                                : AppTheme.secondaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Profile Information
                _buildInfoSection(context, 'Contact Information', [
                  _buildInfoItem('Email', user.email, Icons.email),
                  _buildInfoItem('Phone', user.phone, Icons.phone),
                  if (user.address != null)
                    _buildInfoItem('Address', user.address!, Icons.location_on),
                  if (user.societyName != null)
                    _buildInfoItem(
                      'Society',
                      user.societyName!,
                      Icons.home_work,
                    ),
                ]),

                const SizedBox(height: 24),

                // Account Information
                _buildInfoSection(context, 'Account Information', [
                  _buildInfoItem(
                    'Member Since',
                    _formatDate(user.createdAt),
                    Icons.calendar_today,
                  ),
                  _buildInfoItem(
                    'Status',
                    user.isVerified ? 'Verified' : 'Unverified',
                    Icons.verified,
                  ),
                  if (user.rating != null)
                    _buildInfoItem(
                      'Rating',
                      '${user.rating!.toStringAsFixed(1)} (${user.totalRatings} reviews)',
                      Icons.star,
                    ),
                ]),

                const SizedBox(height: 32),

                // Action Buttons
                _buildActionButton(context, 'Edit Profile', Icons.edit, () {
                  // TODO: Navigate to edit profile screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Edit Profile - Coming Soon'),
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  );
                }),

                const SizedBox(height: 12),

                _buildActionButton(context, 'Settings', Icons.settings, () {
                  // TODO: Navigate to settings screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Settings - Coming Soon'),
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  );
                }),

                const SizedBox(height: 12),

                _buildActionButton(context, 'Sign Out', Icons.logout, () async {
                  await authProvider.signOut();
                  if (context.mounted) {
                    context.go('/login');
                  }
                }, isDestructive: true),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
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
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.textSecondary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDestructive
              ? AppTheme.errorColor
              : AppTheme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
