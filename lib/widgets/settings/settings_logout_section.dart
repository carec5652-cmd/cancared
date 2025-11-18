import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/providers/locale_provider.dart';
import '../common/action_tile.dart';

/// Log out section for settings screen
class SettingsLogoutSection extends StatelessWidget {
  const SettingsLogoutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return ActionTile(
      icon: Icons.logout,
      title: localeProvider.isEnglish ? "Log Out" : "تسجيل الخروج",
      iconColor: Colors.red,
      titleColor: Colors.red,
      onTap: () async {
        // Show confirmation dialog
        final shouldLogout = await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text(
                  localeProvider.isEnglish ? "Log Out" : "تسجيل الخروج",
                ),
                content: Text(
                  localeProvider.isEnglish
                      ? "Are you sure you want to log out?"
                      : "هل أنت متأكد أنك تريد تسجيل الخروج؟",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(localeProvider.isEnglish ? "Cancel" : "إلغاء"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: Text(
                      localeProvider.isEnglish ? "Log Out" : "تسجيل الخروج",
                    ),
                  ),
                ],
              ),
        );

        // If user confirmed, sign out
        if (shouldLogout == true) {
          await FirebaseAuth.instance.signOut();
          if (context.mounted) {
            Navigator.of(context).pushReplacementNamed('/login');
          }
        }
      },
    );
  }
}
