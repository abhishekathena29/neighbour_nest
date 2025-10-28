import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/auth_provider.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/auth/presentation/screens/user_type_selection_screen.dart';
import '../../features/auth/presentation/screens/almost_there_screen.dart';
import '../../features/auth/presentation/screens/share_skills_form_screen.dart';
import '../../features/auth/presentation/screens/contributors_list_screen.dart';
import '../../features/auth/presentation/screens/skill_requests_screen.dart';
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

      // List of public routes that don't require authentication
      final publicRoutes = [
        '/splash',
        '/welcome',
        '/user-type-selection',
        '/almost-there',
        '/share-skills-form',
        '/contributors-list',
        '/skill-requests',
        '/login',
        '/signup',
        '/forgot-password',
      ];

      // Allow access to all public routes
      if (publicRoutes.contains(state.uri.path)) {
        return null;
      }

      // For protected routes (dashboard), check authentication
      if (!authProvider.isAuthenticated) {
        // Redirect to welcome for unauthenticated users trying to access protected routes
        return '/welcome';
      }

      return null; // No redirect needed
    },
    routes: [
      // Splash Route
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      // Welcome/Onboarding Routes
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/user-type-selection',
        builder: (context, state) => const UserTypeSelectionScreen(),
      ),
      GoRoute(
        path: '/almost-there',
        builder: (context, state) => const AlmostThereScreen(),
      ),
      GoRoute(
        path: '/share-skills-form',
        builder: (context, state) => const ShareSkillsFormScreen(),
      ),
      GoRoute(
        path: '/contributors-list',
        builder: (context, state) => const ContributorsListScreen(),
      ),
      GoRoute(
        path: '/skill-requests',
        builder: (context, state) => const SkillRequestsScreen(),
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
