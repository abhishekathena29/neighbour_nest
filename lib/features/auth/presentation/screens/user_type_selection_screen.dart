import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/responsive_wrapper.dart';

class UserTypeSelectionScreen extends StatelessWidget {
  const UserTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ResponsiveWrapper(
          child: Padding(
            padding: EdgeInsets.all(context.responsivePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                const SizedBox(height: 48),

                // Title
                Text(
                  'What brings you to NearWise?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Subtitle
                Text(
                  'Choose how you\'d like to get started.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 40),

                // Option 1: Offer Skills
                _UserTypeCard(
                  gradient: AppTheme.primaryGradient,
                  icon: Icons.person_add_outlined,
                  title: 'I want to offer skills',
                  description:
                      'Share your expertise with neighbors and help others learn.',
                  tags: const ['Teach', 'Share', 'Help'],
                  tagColors: const [
                    Color(0xFF6BCBA4),
                    Color(0xFFEDB862),
                    Color(0xFFB88DC8),
                  ],
                  onTap: () {
                    context.go('/share-skills-form');
                  },
                ),
                const SizedBox(height: 24),

                // Option 2: Find Skills
                _UserTypeCard(
                  gradient: AppTheme.purpleGradient,
                  icon: Icons.search,
                  title: 'I want to find skills',
                  description:
                      'Discover talented neighbors who can teach you new skills.',
                  tags: const ['Learn', 'Discover', 'Grow'],
                  tagColors: const [
                    Color(0xFF6B9DC8),
                    Color(0xFFEDB862),
                    Color(0xFFB88DC8),
                  ],
                  onTap: () {
                    context.go('/almost-there');
                  },
                ),
                const Spacer(),

                // Bottom Note
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Don\'t worry, you can always do both! This just helps us personalize your experience.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserTypeCard extends StatelessWidget {
  final Gradient gradient;
  final IconData icon;
  final String title;
  final String description;
  final List<String> tags;
  final List<Color> tagColors;
  final VoidCallback onTap;

  const _UserTypeCard({
    required this.gradient,
    required this.icon,
    required this.title,
    required this.description,
    required this.tags,
    required this.tagColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            // Icon with gradient background
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: Colors.white, size: 36),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),

            // Tags
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                tags.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Chip(
                    label: Text(
                      tags[index],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: tagColors[index],
                      ),
                    ),
                    backgroundColor: tagColors[index].withOpacity(0.15),
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
