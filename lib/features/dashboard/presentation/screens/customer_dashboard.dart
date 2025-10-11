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
import '../widgets/dashboard_app_bar.dart';
import '../widgets/category_card.dart';
import '../widgets/service_card.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({super.key});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  int _selectedIndex = 0;
  String _selectedCategory = 'all';

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.userProfile == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Load services when dashboard is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<ServiceProvider>(
            context,
            listen: false,
          ).loadAllServices();
        });

        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: DashboardAppBar(
            title: 'Find Services',
            user: authProvider.userProfile,
          ),
          body: IndexedStack(
            index: _selectedIndex,
            children: [
              _buildHomeTab(),
              _buildSearchTab(),
              _buildMessagesTab(),
              _buildProfileTab(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            selectedItemColor: AppTheme.primaryColor,
            unselectedItemColor: AppTheme.textSecondary,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find Help Nearby',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Discover skilled neighbors ready to help',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                AppConstants.smallBorderRadius,
              ),
              border: Border.all(color: AppTheme.dividerColor),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for services...',
                prefixIcon: const Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) {
                // TODO: Implement search
              },
            ),
          ),
          const SizedBox(height: 24),

          // Categories
          Text(
            'Categories',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: AppConstants.defaultCategories.length,
              itemBuilder: (context, index) {
                final category = AppConstants.defaultCategories[index];
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < AppConstants.defaultCategories.length - 1
                        ? 12
                        : 0,
                  ),
                  child: CategoryCard(
                    title: category['name'],
                    icon: category['icon'],
                    color: category['color'],
                    isSelected: _selectedCategory == category['id'],
                    onTap: () {
                      setState(() {
                        _selectedCategory = category['id'];
                      });
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Recent Services
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Services',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () {
                  setState(() => _selectedIndex = 1);
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Service Cards
          Consumer<ServiceProvider>(
            builder: (context, serviceProvider, child) {
              if (serviceProvider.isLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (serviceProvider.errorMessage != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
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
                          style: const TextStyle(color: AppTheme.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (serviceProvider.services.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
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

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: serviceProvider.services.take(3).length,
                itemBuilder: (context, index) {
                  final service = serviceProvider.services[index];
                  return Padding(
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
                  );
                },
              );
            },
          ),
        ],
      ),
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
