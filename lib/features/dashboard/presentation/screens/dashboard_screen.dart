import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/models/user_model.dart';
import '../../../auth/presentation/auth_provider.dart';
import 'contributor_dashboard.dart';
import 'customer_dashboard.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Show loading while user profile is being loaded
        if (authProvider.userProfile == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Route to appropriate dashboard based on user type
        final userProfile = authProvider.userProfile!;

        if (userProfile.userType == UserType.contributor) {
          return const ContributorDashboard();
        } else {
          return const CustomerDashboard();
        }
      },
    );
  }
}
