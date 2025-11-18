import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/providers/theme_provider.dart';
import '../common/section_card.dart';
import '../common/action_tile.dart';

/// Theme selection section for settings screen
class SettingsThemeSection extends StatelessWidget {
  const SettingsThemeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    return SectionCard(
      title: localeProvider.isEnglish ? "Theme" : "المظهر",
      child: ActionTile(
        icon: themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
        title: localeProvider.isEnglish
            ? themeProvider.isDarkMode
                ? "Dark Mode"
                : "Light Mode"
            : themeProvider.isDarkMode
            ? "الوضع الداكن"
            : "الوضع الفاتح",
        trailing: Switch(
          value: themeProvider.isDarkMode,
          onChanged: (value) {
            themeProvider.toggleTheme();
          },
        ),
        onTap: () {
          themeProvider.toggleTheme();
        },
        margin: EdgeInsets.zero,
      ),
    );
  }
}
