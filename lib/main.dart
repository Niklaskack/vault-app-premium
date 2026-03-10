import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/vault_theme.dart';
import 'features/main_navigation.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/profile/screens/lock_screen.dart';
import 'core/providers/settings_provider.dart';
import 'services/background_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Background Services (Mobile Only)
  if (!kIsWeb && (identical(0, 0.0) == false)) { // Better check for native desktop
     // Actually kIsWeb is from foundation, but Platform is from dart:io
  }
  
  // Safe way: Use a simple try-catch or explicit check
  try {
     BackgroundService.init();
     BackgroundService.scheduleSmsSync();
  } catch (e) {
     debugPrint('Background services not supported on this platform: $e');
  }

  runApp(
    const ProviderScope(
      child: VaultApp(),
    ),
  );
}

class VaultApp extends ConsumerWidget {
  const VaultApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);

    return MaterialApp(
      title: 'Vault',
      theme: VaultTheme.light,
      darkTheme: VaultTheme.dark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      locale: Locale(settings.languageCode),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('sv'),
      ],
      home: settings.isLockEnabled ? const LockScreen() : const OnboardingScreen(),
    );
  }
}
