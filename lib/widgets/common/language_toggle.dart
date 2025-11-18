import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/locale_provider.dart';

/// LanguageToggle widget displays two buttons to switch between English and Arabic
/// All logic is handled by LocaleProvider
class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    // Get LocaleProvider from context
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // English button
        ElevatedButton(
          onPressed: () {
            // Call provider method to set English
            localeProvider.setEnglish();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                localeProvider.isEnglish
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300],
            foregroundColor:
                localeProvider.isEnglish ? Colors.white : Colors.black87,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('English'),
        ),
        const SizedBox(width: 16),
        // Arabic button
        ElevatedButton(
          onPressed: () {
            // Call provider method to set Arabic
            localeProvider.setArabic();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                !localeProvider.isEnglish
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300],
            foregroundColor:
                !localeProvider.isEnglish ? Colors.white : Colors.black87,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('العربية'),
        ),
      ],
    );
  }
}

