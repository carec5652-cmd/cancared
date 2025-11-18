import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/providers/locale_provider.dart';
import '../../widgets/settings/settings_admin_info.dart';
import '../../widgets/settings/settings_language_section.dart';
import '../../widgets/settings/settings_theme_section.dart';
import '../../widgets/settings/settings_support_section.dart';
import '../../widgets/settings/settings_logout_section.dart';

/// Settings Screen
/// Allows users to change language and theme settings
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get providers using context.watch
    final localeProvider = context.watch<LocaleProvider>();
    final user = FirebaseAuth.instance.currentUser;

    // Get admin name from user
    final adminName =
        user?.email?.split('@')[0] ??
        user?.phoneNumber ??
        (localeProvider.isEnglish ? 'Admin' : 'مشرف');

    final userInfo = user?.email ?? user?.phoneNumber ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(localeProvider.isEnglish ? "Settings" : "الإعدادات"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Admin info section
            SettingsAdminInfo(
              adminName: adminName,
              userInfo: userInfo,
            ),
            const SizedBox(height: 24),

            // Language selection section
            const SettingsLanguageSection(),
            const SizedBox(height: 32),

            // Theme selection section
            const SettingsThemeSection(),
            const SizedBox(height: 32),

            // Help & Support section
            const SettingsSupportSection(),
            const SizedBox(height: 32),

            // Log Out section
            const SettingsLogoutSection(),
          ],
        ),
      ),
    );
  }
}

