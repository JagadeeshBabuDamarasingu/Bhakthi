import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper around SharedPreferences for all persisted app state.
class AppPreferences {
  AppPreferences._();

  static late SharedPreferences _prefs;

  static const _kOnboardingComplete = 'onboarding_complete';
  static const _kSelectedDeities    = 'selected_deities';
  static const _kLanguageCode       = 'language_code';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── Onboarding ───────────────────────────────────────────────────────────────

  static bool get onboardingComplete =>
      _prefs.getBool(_kOnboardingComplete) ?? false;

  static Future<void> setOnboardingComplete() =>
      _prefs.setBool(_kOnboardingComplete, true);

  // ── Deity preferences ────────────────────────────────────────────────────────

  static List<String> get selectedDeities =>
      _prefs.getStringList(_kSelectedDeities) ?? [];

  static Future<void> setSelectedDeities(List<String> ids) =>
      _prefs.setStringList(_kSelectedDeities, ids);

  // ── Language ─────────────────────────────────────────────────────────────────

  static String get languageCode =>
      _prefs.getString(_kLanguageCode) ?? 'en';

  static Future<void> setLanguageCode(String code) =>
      _prefs.setString(_kLanguageCode, code);
}
