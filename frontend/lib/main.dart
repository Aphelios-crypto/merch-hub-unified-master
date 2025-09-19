import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/deep_link_service.dart';
import 'utils/url_strategy.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/superadmin_dashboard.dart';
import 'screens/admin_listings_screen.dart';
import 'screens/user_listings_screen.dart';
import 'screens/admin_add_listing_screen.dart';
import 'screens/order_confirmation_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/email_verification_success_screen.dart';
import 'models/user_role.dart';
import 'models/listing.dart';

// Global navigator key for accessing navigator from anywhere
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  
  // No need for web-specific configuration in mobile
  
  // Initialize deep link service
  DeepLinkService.init(navigatorKey);
  
  runApp(const UDDEssentialsApp());
}

class UDDEssentialsApp extends StatelessWidget {
  const UDDEssentialsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'UDD Essentials',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/superadmin': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          final userSession = UserSession(
            userId: args['userId'],
            name: args['name'],
            email: args['email'],
            role: args['role'] == 'superadmin'
                ? UserRole.superAdmin
                : UserRole.student,
            departmentId: args['departmentId'],
            departmentName: args['departmentName'],
          );
          return SuperAdminDashboard(userSession: userSession);
        },
        '/admin': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          final userSession = UserSession(
            userId: args['userId'],
            name: args['name'],
            email: args['email'],
            role: args['role'] == 'admin' ? UserRole.admin : UserRole.student,
            departmentId: args['departmentId'],
            departmentName: args['departmentName'],
          );
          return AdminListingsScreen(userSession: userSession);
        },
        '/user-listings': (context) {
          return const UserListingsScreen();
        },
        '/order-confirmation': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          final listing = args['listing'] as Listing;
          return OrderConfirmationScreen(listing: listing);
        },
        '/admin-add-listing': (context) => const AdminAddListingScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/email-verification-success': (context) => const EmailVerificationSuccessScreen(),
      },
    );
  }
}
