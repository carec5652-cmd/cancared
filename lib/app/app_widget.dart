import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../core/providers/locale_provider.dart';
import '../core/providers/theme_provider.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../screens/auth/admin_login_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';

/// Main app widget that sets up providers and MaterialApp
class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap app with MultiProvider to provide LocaleProvider, ThemeProvider, and AdminDashboardController
    return MultiProvider(
      providers: [
        // Provide LocaleProvider for language switching
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        // Provide ThemeProvider for theme switching
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // Provide AdminDashboardController for dashboard data
        ChangeNotifierProvider(create: (_) => AdminDashboardController()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'CanCare Admin',
            // Use theme from ThemeProvider
            theme: ThemeProvider.lightTheme,
            darkTheme: ThemeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const AuthWrapper(),
            routes: {
              '/login': (context) => const AdminLoginScreen(),
              '/home': (context) => const AdminDashboardScreen(),
            },
          );
        },
      ),
    );
  }
}

/// Wrapper widget that checks authentication state
/// Shows login screen if not authenticated, otherwise shows dashboard
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If user is logged in, show dashboard
        if (snapshot.hasData && snapshot.data != null) {
          return const AdminDashboardScreen();
        }

        // Otherwise, show login screen
        return const AdminLoginScreen();
      },
    );
  }
}
