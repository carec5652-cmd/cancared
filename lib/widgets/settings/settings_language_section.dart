import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/locale_provider.dart';
import '../common/section_card.dart';

/// Language selection section for settings screen
class SettingsLanguageSection extends StatelessWidget {
  const SettingsLanguageSection({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return SectionCard(
      title: localeProvider.isEnglish ? "Language" : "اللغة",
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // English button
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    localeProvider.setEnglish();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          localeProvider.isEnglish
                              ? Theme.of(context).primaryColor
                              : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'English',
                        style: TextStyle(
                          color:
                              localeProvider.isEnglish
                                  ? Colors.white
                                  : Colors.black87,
                          fontWeight:
                              localeProvider.isEnglish
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Arabic button
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    localeProvider.setArabic();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          !localeProvider.isEnglish
                              ? Theme.of(context).primaryColor
                              : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'العربية',
                        style: TextStyle(
                          color:
                              !localeProvider.isEnglish
                                  ? Colors.white
                                  : Colors.black87,
                          fontWeight:
                              !localeProvider.isEnglish
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
