class AppConstants {
  // App Information
  static const String appName = 'NearWise';
  static const String appVersion = '1.0.0';
  static const String appTagline =
      'Connect with your community and share skills that matter.';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String servicesCollection = 'services';
  static const String categoriesCollection = 'categories';
  static const String ratingsCollection = 'ratings';
  static const String messagesCollection = 'messages';
  static const String conversationsCollection = 'conversations';

  // Storage Paths
  static const String profileImagesPath = 'profile_images';
  static const String serviceImagesPath = 'service_images';

  // User Types
  static const String contributorType = 'contributor';
  static const String customerType = 'customer';

  // Service Status
  static const String activeStatus = 'active';
  static const String inactiveStatus = 'inactive';
  static const String completedStatus = 'completed';
  static const String cancelledStatus = 'cancelled';

  // Service Types
  static const String oneTimeService = 'oneTime';
  static const String recurringService = 'recurring';
  static const String workshopService = 'workshop';

  // Default Categories
  static const List<Map<String, dynamic>> defaultCategories = [
    {
      'id': 'academic_tutoring',
      'name': 'Academic Tutoring',
      'description': 'Math, Science, Languages, and more',
      'icon': 'school',
      'color': '#2196F3',
    },
    {
      'id': 'professional_services',
      'name': 'Professional Services',
      'description': 'Legal, Financial, Business consulting',
      'icon': 'business',
      'color': '#4CAF50',
    },
    {
      'id': 'creative_arts',
      'name': 'Creative Arts',
      'description': 'Music, Art, Writing, Design',
      'icon': 'palette',
      'color': '#FF9800',
    },
    {
      'id': 'health_wellness',
      'name': 'Health & Wellness',
      'description': 'Fitness, Nutrition, Mental health',
      'icon': 'favorite',
      'color': '#E91E63',
    },
    {
      'id': 'technology',
      'name': 'Technology',
      'description': 'Programming, Digital skills, IT support',
      'icon': 'computer',
      'color': '#9C27B0',
    },
    {
      'id': 'home_services',
      'name': 'Home Services',
      'description': 'Plumbing, Electrical, Gardening',
      'icon': 'home',
      'color': '#795548',
    },
    {
      'id': 'lifestyle',
      'name': 'Lifestyle',
      'description': 'Cooking, Fashion, Travel planning',
      'icon': 'star',
      'color': '#FFC107',
    },
    {
      'id': 'other',
      'name': 'Other',
      'description': 'Miscellaneous services and skills',
      'icon': 'more_horiz',
      'color': '#607D8B',
    },
  ];

  // Validation
  static const int minPasswordLength = 6;
  static const int maxDescriptionLength = 500;
  static const int maxTitleLength = 100;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double smallBorderRadius = 8.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
}
