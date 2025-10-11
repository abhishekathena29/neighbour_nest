import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/presentation/auth_provider.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../messaging/presentation/screens/messaging_screen.dart';
import '../../../services/presentation/screens/add_service_screen.dart';
import '../../../services/presentation/service_provider.dart';
import '../widgets/dashboard_app_bar.dart';
import '../widgets/stats_card.dart';
import '../widgets/quick_action_button.dart';

class ContributorDashboard extends StatefulWidget {
  const ContributorDashboard({super.key});

  @override
  State<ContributorDashboard> createState() => _ContributorDashboardState();
}

class _ContributorDashboardState extends State<ContributorDashboard> {
  int _selectedIndex = 0;

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
          ).loadMyServices(authProvider.userProfile!.id);
        });

        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: DashboardAppBar(
            title: 'My Services',
            user: authProvider.userProfile,
          ),
          body: IndexedStack(
            index: _selectedIndex,
            children: [
              _buildHomeTab(),
              _buildServicesTab(),
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
                icon: Icon(Icons.work),
                label: 'Services',
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
                  'Welcome back!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ready to help your neighbors today?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Stats Section
          Text(
            'Your Performance',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: StatsCard(
                  title: 'Active Services',
                  value: '3',
                  icon: Icons.work,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatsCard(
                  title: 'Total Ratings',
                  value: '4.8',
                  icon: Icons.star,
                  color: AppTheme.warningColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatsCard(
                  title: 'Messages',
                  value: '12',
                  icon: Icons.message,
                  color: AppTheme.infoColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatsCard(
                  title: 'Earnings',
                  value: '₹2,400',
                  icon: Icons.attach_money,
                  color: AppTheme.successColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Quick Actions
          Text(
            'Quick Actions',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: QuickActionButton(
                  title: 'Add Service',
                  icon: Icons.add,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddServiceScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QuickActionButton(
                  title: 'View Requests',
                  icon: Icons.request_page,
                  onTap: () {
                    // TODO: Navigate to requests screen
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: QuickActionButton(
                  title: 'My Services',
                  icon: Icons.list,
                  onTap: () {
                    setState(() => _selectedIndex = 1);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QuickActionButton(
                  title: 'Messages',
                  icon: Icons.chat,
                  onTap: () {
                    setState(() => _selectedIndex = 2);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServicesTab() {
    return Consumer<ServiceProvider>(
      builder: (context, serviceProvider, child) {
        if (serviceProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (serviceProvider.errorMessage != null) {
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
                  serviceProvider.errorMessage!,
                  style: const TextStyle(color: AppTheme.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final authProvider = Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    );
                    if (authProvider.userProfile != null) {
                      serviceProvider.loadMyServices(
                        authProvider.userProfile!.id,
                      );
                    }
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (serviceProvider.myServices.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.work_outline,
                  size: 64,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No services yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Create your first service to get started',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddServiceScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Service'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          itemCount: serviceProvider.myServices.length,
          itemBuilder: (context, index) {
            final service = serviceProvider.myServices[index];
            return _buildServiceCard(service);
          },
        );
      },
    );
  }

  Widget _buildServiceCard(service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    service.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: service.status.toString().contains('active')
                        ? AppTheme.successColor.withOpacity(0.1)
                        : AppTheme.textSecondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    service.status.toString().split('.').last,
                    style: TextStyle(
                      color: service.status.toString().contains('active')
                          ? AppTheme.successColor
                          : AppTheme.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              service.description,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (service.price != null) ...[
                  Text(
                    '₹${service.price!.toInt()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                Text(
                  AppConstants.defaultCategories.firstWhere(
                    (cat) => cat['id'] == service.category,
                  )['name'],
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                if (service.rating > 0) ...[
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    service.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesTab() {
    return const MessagingScreen();
  }

  Widget _buildProfileTab() {
    return const ProfileScreen();
  }
}
