import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/providers/locale_provider.dart';
import '../../controllers/admin_dashboard_controller.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/dashboard/dashboard_header.dart';
import '../../widgets/dashboard/dashboard_welcome_text.dart';
import '../../widgets/dashboard/dashboard_stats_grid.dart';
import '../../widgets/dashboard/dashboard_recent_activity.dart';
import '../../widgets/dashboard/dashboard_actions_list.dart';
import '../../widgets/dashboard/dashboard_bottom_nav_bar.dart';

/// Admin Dashboard Screen
/// Displays dashboard with statistics, recent activity, and quick actions
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // Track current bottom navigation index
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load dashboard data when screen is first displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<AdminDashboardController>(
        context,
        listen: false,
      );
      controller.loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get providers using context.watch - MUST be at top of build method
    final localeProvider = context.watch<LocaleProvider>();
    final controller = Provider.of<AdminDashboardController>(context);
    final user = FirebaseAuth.instance.currentUser;

    // Get admin name from user (email or phone, or default)
    final adminName =
        user?.email?.split('@')[0] ??
        user?.phoneNumber ??
        (localeProvider.isEnglish ? 'Admin' : 'مشرف');

    return Scaffold(
      body: SafeArea(
        child: controller.isLoading
            ? const LoadingIndicator()
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  16.0,
                  16.0,
                  16.0,
                  80.0,
                ), // Extra bottom padding for bottom nav
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Custom header row with avatar and notification
                    const DashboardHeader(),
                    const SizedBox(height: 24),

                    // Welcome text (centered)
                    DashboardWelcomeText(
                      adminName: adminName,
                      isEnglish: localeProvider.isEnglish,
                    ),
                    const SizedBox(height: 32),

                    // Grid of 4 cards: Doctor, Nurse, Patient, Posts
                    DashboardStatsGrid(controller: controller),
                    const SizedBox(height: 32),

                    // Recent Activity section
                    DashboardRecentActivity(
                      controller: controller,
                      isEnglish: localeProvider.isEnglish,
                    ),
                    const SizedBox(height: 32),

                    // Vertical list of actions
                    DashboardActionsList(
                      isEnglish: localeProvider.isEnglish,
                    ),
                  ],
                ),
              ),
      ),
      // Bottom navigation bar
      bottomNavigationBar: DashboardBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        isEnglish: localeProvider.isEnglish,
      ),
    );
  }
}

