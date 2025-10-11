import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/models/service_model.dart';
import '../service_provider.dart';
import 'service_detail_screen.dart';

class ServiceListingScreen extends StatefulWidget {
  final String? category;
  final String? searchQuery;

  const ServiceListingScreen({super.key, this.category, this.searchQuery});

  @override
  State<ServiceListingScreen> createState() => _ServiceListingScreenState();
}

class _ServiceListingScreenState extends State<ServiceListingScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final serviceProvider = Provider.of<ServiceProvider>(
        context,
        listen: false,
      );
      if (widget.category != null) {
        serviceProvider.loadServicesByCategory(widget.category!);
      } else if (widget.searchQuery != null) {
        serviceProvider.searchServices(widget.searchQuery!);
      } else {
        serviceProvider.loadAllServices();
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
      appBar: AppBar(
        title: Text(
          widget.category != null
              ? AppConstants.defaultCategories.firstWhere(
                  (cat) => cat['id'] == widget.category,
                )['name']
              : 'Services',
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search services...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          Provider.of<ServiceProvider>(
                            context,
                            listen: false,
                          ).loadAllServices();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius,
                  ),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppTheme.backgroundColor,
              ),
              onSubmitted: (query) {
                Provider.of<ServiceProvider>(
                  context,
                  listen: false,
                ).searchServices(query);
              },
            ),
          ),

          // Category Filter
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: AppConstants.defaultCategories.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildCategoryChip('all', 'All', index == 0);
                }
                final category = AppConstants.defaultCategories[index - 1];
                return _buildCategoryChip(
                  category['id'],
                  category['name'],
                  widget.category == category['id'],
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Services List
          Expanded(
            child: Consumer<ServiceProvider>(
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
                            serviceProvider.loadAllServices();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (serviceProvider.services.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No services found',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or filters',
                          style: const TextStyle(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  itemCount: serviceProvider.services.length,
                  itemBuilder: (context, index) {
                    final service = serviceProvider.services[index];
                    return _buildServiceCard(service);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
    String categoryId,
    String categoryName,
    bool isSelected,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(categoryName),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            Provider.of<ServiceProvider>(
              context,
              listen: false,
            ).loadServicesByCategory(categoryId);
          }
        },
        selectedColor: AppTheme.primaryColor.withOpacity(0.2),
        checkmarkColor: AppTheme.primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildServiceCard(ServiceModel service) {
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
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServiceDetailScreen(service: service),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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
                  if (service.price != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '₹${service.price!.toInt()}',
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 8),

              // Description
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

              // Category and Type
              Row(
                children: [
                  _buildInfoChip(
                    AppConstants.defaultCategories.firstWhere(
                      (cat) => cat['id'] == service.category,
                    )['name'],
                    AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    service.serviceType.toString().split('.').last,
                    AppTheme.secondaryColor,
                  ),
                  if (service.isOnline) ...[
                    const SizedBox(width: 8),
                    _buildInfoChip('Online', AppTheme.successColor),
                  ],
                ],
              ),

              const SizedBox(height: 12),

              // Footer
              Row(
                children: [
                  // Rating
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
                    const SizedBox(width: 4),
                    Text(
                      '(${service.totalRatings})',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                  ] else
                    const Spacer(),

                  // Contact Button
                  ElevatedButton.icon(
                    onPressed: () {
                      _showContactDialog(service);
                    },
                    icon: const Icon(Icons.message, size: 16),
                    label: const Text('Contact'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showContactDialog(ServiceModel service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact ${service.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Service Provider: ${service.contributorId}'),
            if (service.contactInfo != null) ...[
              const SizedBox(height: 8),
              Text('Contact: ${service.contactInfo}'),
            ],
            const SizedBox(height: 16),
            const Text('Would you like to start a conversation?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to chat screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Starting conversation...'),
                  backgroundColor: AppTheme.primaryColor,
                ),
              );
            },
            child: const Text('Start Chat'),
          ),
        ],
      ),
    );
  }
}
