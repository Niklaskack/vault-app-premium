import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  final bool isLockEnabled;
  final String languageCode;

  AppSettings({
    required this.isLockEnabled,
    required this.languageCode,
  });

  AppSettings copyWith({bool? isLockEnabled, String? languageCode}) {
    return AppSettings(
      isLockEnabled: isLockEnabled ?? this.isLockEnabled,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier() : super(AppSettings(isLockEnabled: false, languageCode: 'en')) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = AppSettings(
      isLockEnabled: prefs.getBool('isLockEnabled') ?? false,
      languageCode: prefs.getString('languageCode') ?? 'en',
    );
  }

  Future<void> setLockEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLockEnabled', value);
    state = state.copyWith(isLockEnabled: value);
  }

  Future<void> setLanguageCode(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', value);
    state = state.copyWith(languageCode: value);
  }
}

final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  return AppSettingsNotifier();
});
