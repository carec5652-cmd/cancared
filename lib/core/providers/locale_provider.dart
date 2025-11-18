import 'package:flutter/foundation.dart';

/// LocaleProvider manages the app's language state
/// Uses a simple boolean to track English (true) or Arabic (false)
class LocaleProvider extends ChangeNotifier {
  // Default language is English
  bool _isEnglish = true;

  /// Getter for current language state
  /// Returns true if English, false if Arabic
  bool get isEnglish => _isEnglish;

  /// Switch language to English
  void setEnglish() {
    if (_isEnglish) return; // Already English, no need to update
    _isEnglish = true;
    notifyListeners(); // Notify all listeners that language changed
  }

  /// Switch language to Arabic
  void setArabic() {
    if (!_isEnglish) return; // Already Arabic, no need to update
    _isEnglish = false;
    notifyListeners(); // Notify all listeners that language changed
  }
}

