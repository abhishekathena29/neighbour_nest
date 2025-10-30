import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/presentation/auth_provider.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../messaging/presentation/screens/messaging_screen.dart';
import '../../../services/presentation/screens/service_listing_screen.dart';
import '../../../services/presentation/screens/service_detail_screen.dart';
import '../../../services/presentation/service_provider.dart';
import '../widgets/service_card.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({super.key});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  int _selectedIndex = 0;
  String _selectedCategory = 'all';
  bool _servicesLoaded = false;

  @override
  void initState() {
    super.initState();
    // Load services once when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_servicesLoaded) {
        Provider.of<ServiceProvider>(context, listen: false).loadAllServices();
        _servicesLoaded = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.userProfile == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          body: IndexedStack(
            index: _selectedIndex,
            children: [
              _buildHomeTab(),
              _buildSearchTab(),
              _buildMessagesTab(),
              _buildProfileTab(),
            ],
          ),
          bottomNavigationBar: Container(
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
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.home_outlined, Icons.home, 'Home', 0),
                    _buildNavItem(
                      Icons.search_outlined,
                      Icons.search,
                      'Search',
                      1,
                    ),
                    _buildNavItem(
                      Icons.message_outlined,
                      Icons.message,
                      'Messages',
                      2,
                    ),
                    _buildNavItem(
                      Icons.person_outline,
                      Icons.person,
                      'Profile',
                      3,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    IconData icon,
    IconData activeIcon,
    String label,
    int index,
  ) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected
                  ? AppTheme.primaryColor
                  : AppTheme.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 120,
          floating: false,
          pinned: true,
          elevation: 0,
          backgroundColor: AppTheme.primaryColor,
          flexibleSpace: FlexibleSpaceBar(
            title: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return Text(
                  'Hello, ${authProvider.userProfile?.name.split(' ').first ?? 'User'}!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                );
              },
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

        // Content
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Welcome Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF6BCBA4),
                        const Color(0xFF4FA98D),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6BCBA4).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.explore_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.star, color: Colors.white, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  'Premium',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Find Help Nearby',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Discover skilled neighbors ready to help with your needs',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Search services...',
                            hintStyle: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 15,
                            ),
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          onChanged: (value) {
                            // TODO: Implement search
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _selectedIndex = 1),
                      child: const Text('View All'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: AppConstants.defaultCategories.length,
                  itemBuilder: (context, index) {
                    final category = AppConstants.defaultCategories[index];
                    final isSelected = _selectedCategory == category['id'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category['id'];
                          });
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 100,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (category['color'] as Color).withOpacity(0.15)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? category['color'] as Color
                                  : Colors.grey[200]!,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                category['icon'],
                                color: isSelected
                                    ? category['color'] as Color
                                    : AppTheme.textSecondary,
                                size: 32,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                category['name'],
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? category['color'] as Color
                                      : AppTheme.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Recent Services
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Available Services',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _selectedIndex = 1),
                      child: const Text('View All'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Service Cards
              Consumer<ServiceProvider>(
                builder: (context, serviceProvider, child) {
                  if (serviceProvider.isLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (serviceProvider.errorMessage != null) {
                    return Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: AppTheme.textSecondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              serviceProvider.errorMessage!,
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (serviceProvider.services.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 48,
                              color: AppTheme.textSecondary,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No services available',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: serviceProvider.services
                          .take(5)
                          .map(
                            (service) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ServiceCard(
                                title: service.title,
                                description: service.description,
                                contributor: service.contributorId,
                                rating: service.rating,
                                price: service.price?.toInt() ?? 0,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ServiceDetailScreen(service: service),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchTab() {
    return const ServiceListingScreen();
  }

  Widget _buildMessagesTab() {
    return const MessagingScreen();
  }

  Widget _buildProfileTab() {
    return const ProfileScreen();
  }
}
