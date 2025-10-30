import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/responsive_wrapper.dart';

class ContributorsListScreen extends StatelessWidget {
  const ContributorsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/share-skills-form');
            }
          },
        ),
      ),
      body: SafeArea(
        child: ResponsiveWrapper(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(context.responsivePadding),
            child: Column(
              children: [
                // Logo and Name
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.share,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      AppConstants.appName,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Title
                Text(
                  'Creative Arts',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  '2 skilled contributors in your area',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                // Contributor Cards
                _ContributorCard(
                  initials: 'AT',
                  name: 'Alex Thompson',
                  rating: 4.7,
                  expertise: 'General expertise',
                  description: 'Experienced community member',
                  reviews: 15,
                  distance: '2.0 miles away',
                  onContact: () {
                    // Handle contact
                  },
                ),
                const SizedBox(height: 16),

                _ContributorCard(
                  initials: 'MG',
                  name: 'Maria Garcia',
                  rating: 4.8,
                  expertise: 'Teaching and mentoring',
                  description: 'Passionate about sharing knowledge',
                  reviews: 19,
                  distance: '1.6 miles away',
                  onContact: () {
                    // Handle contact
                  },
                ),
                const SizedBox(height: 32),

                // Bottom Note
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'All contributors are verified community members. Connect safely and build lasting relationships.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContributorCard extends StatelessWidget {
  final String initials;
  final String name;
  final double rating;
  final String expertise;
  final String description;
  final int reviews;
  final String distance;
  final VoidCallback onContact;

  const _ContributorCard({
    required this.initials,
    required this.name,
    required this.rating,
    required this.expertise,
    required this.description,
    required this.reviews,
    required this.distance,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        // Rating
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Color(0xFFFF9800),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                rating.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFF9800),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      expertise,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6BCBA4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Stats Row
          Row(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 16,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                '$reviews reviews',
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                distance,
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Contact Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: onContact,
              icon: const Icon(Icons.phone, size: 20),
              label: Text('Contact ${name.split(' ')[0]}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
