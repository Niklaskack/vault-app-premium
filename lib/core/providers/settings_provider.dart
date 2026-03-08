import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  final bool isLockEnabled;

  AppSettings({required this.isLockEnabled});

  AppSettings copyWith({bool? isLockEnabled}) {
    return AppSettings(isLockEnabled: isLockEnabled ?? this.isLockEnabled);
  }
}

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier() : super(AppSettings(isLockEnabled: false)) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = AppSettings(isLockEnabled: prefs.getBool('isLockEnabled') ?? false);
  }

  Future<void> setLockEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLockEnabled', value);
    state = state.copyWith(isLockEnabled: value);
  }
}

final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  return AppSettingsNotifier();
});
