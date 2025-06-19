import 'package:flutter/material.dart';
import 'package:lms/screens/my_profile_screen.dart';
import 'package:lms/screens/register_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/create_listing_screen.dart';
import 'screens/listing_details_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/admin/approve_listings_screen.dart';
import 'screens/admin/approve_users_screen.dart';
import 'screens/admin/assign_roles_screen.dart';
import 'my_theme.dart' as theme;
import 'screens/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alumni System Demo',
      theme: theme.appTheme,
      initialRoute: '/',
      routes: {
  '/': (context) => const SplashScreen(), // Splash is root
  '/login': (context) => const LoginScreen(), // Login moved to '/login'
  '/home': (context) => const HomeScreen(),
  '/create-listing': (context) => const CreateListingScreen(),
  '/listing-details': (context) => const ListingDetailsScreen(),
  '/profile': (context) => const ProfileScreen(),
  '/admin/approve-listings': (context) => const ApproveListingsScreen(),
  '/admin/approve-users': (context) => const ApproveUsersScreen(),
  '/admin/assign-roles': (context) => const AssignRolesScreen(),
  '/register': (context) => const RegisterScreen(),
  '/account':(context)=>MyProfileScreen()
}
,
    );
  }
}
