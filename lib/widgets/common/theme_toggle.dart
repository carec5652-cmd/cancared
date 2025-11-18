import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/theme_provider.dart';

/// ThemeToggle widget displays a switch to toggle between light and dark theme
/// All logic is handled by ThemeProvider
class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    // Get ThemeProvider from context
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
          size: 24,
        ),
        const SizedBox(width: 12),
        // Switch to toggle theme
        Switch(
          value: themeProvider.isDarkMode,
          onChanged: (value) {
            // Call provider method to toggle theme
            themeProvider.toggleTheme();
          },
        ),
        const SizedBox(width: 12),
        Text(
          themeProvider.isDarkMode ? 'Dark' : 'Light',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
