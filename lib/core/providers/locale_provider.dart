import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'storage_provider.dart';

/// Provider for managing the app's locale
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocaleNotifier(prefs);
});

/// Notifier for managing locale state
class LocaleNotifier extends StateNotifier<Locale> {
  final SharedPreferences _prefs;
  static const String _localeKey = 'app_locale';

  LocaleNotifier(this._prefs) : super(_getInitialLocale(_prefs));

  /// Get initial locale from SharedPreferences or use device default
  static Locale _getInitialLocale(SharedPreferences prefs) {
    final savedLocale = prefs.getString(_localeKey);
    if (savedLocale != null) {
      return Locale(savedLocale);
    }
    // Default to English
    return const Locale('en');
  }

  /// Change the app locale and persist the choice
  Future<void> setLocale(Locale locale) async {
    state = locale;
    await _prefs.setString(_localeKey, locale.languageCode);
  }

  /// Get current locale language code
  String get currentLanguageCode => state.languageCode;

  /// Get display name for current locale
  String get currentLanguageName {
    switch (state.languageCode) {
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      case 'ar':
        return 'العربية';
      default:
        return 'English';
    }
  }
}
