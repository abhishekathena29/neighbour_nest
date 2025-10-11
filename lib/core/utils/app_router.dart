import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/auth_provider.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/contributor_dashboard.dart';
import '../../features/dashboard/presentation/screens/customer_dashboard.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Handle splash screen - let the splash screen handle the delay
      if (state.uri.path == '/splash') {
        return null; // Stay on splash, let SplashScreen handle navigation
      }

      // If user is not authenticated, redirect to login
      if (!authProvider.isAuthenticated) {
        return '/login';
      }

      // If user is authenticated but profile is not loaded, wait
      if (authProvider.userProfile == null) {
        return null; // Stay on current route
      }

      // If user is on auth screens but authenticated, redirect to dashboard
      if (state.uri.path.startsWith('/login') ||
          state.uri.path.startsWith('/signup') ||
          state.uri.path.startsWith('/forgot-password')) {
        return '/dashboard';
      }

      return null; // No redirect needed
    },
    routes: [
      // Splash Route
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      // Auth Routes
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Dashboard Routes
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
        routes: [
          GoRoute(
            path: 'contributor',
            builder: (context, state) => const ContributorDashboard(),
          ),
          GoRoute(
            path: 'customer',
            builder: (context, state) => const CustomerDashboard(),
          ),
        ],
      ),
    ],
  );

  static GoRouter get router => _router;
}
