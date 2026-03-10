import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../services/auth_service.dart';
import '../../main_navigation.dart';

import '../../../core/providers/service_providers.dart';
import '../../../core/theme/vault_theme.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _tryUnlock();
  }

  Future<void> _tryUnlock() async {
    setState(() => _isAuthenticating = true);
    final success = await ref.read(authServiceProvider).authenticate();
    setState(() => _isAuthenticating = false);

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F1A30), // Dark Navy Top
              Color(0xFF130922), // Deep Purple/Indigo Bottom
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 60),
              // App Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, color: VaultTheme.glowCyan, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    'Vault',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: VaultTheme.textWhite,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              
              // Title
              Text(
                'Vault is Locked',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text(
                'Authenticate to access your data',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
              
              const Spacer(),
              
              // Fingerprint Hero
              GestureDetector(
                onTap: _isAuthenticating ? null : _tryUnlock,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: VaultTheme.glowCyan.withOpacity(0.3),
                        blurRadius: 50,
                        spreadRadius: 10,
                      )
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outline Circle
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: VaultTheme.glowCyan, width: 3),
                        ),
                      ).animate(onPlay: (controller) => controller.repeat()).shimmer(duration: 2.seconds, color: Colors.white24),
                      
                      // Fingerprint Icon
                      Icon(
                        Icons.fingerprint,
                        size: 110,
                        color: _isAuthenticating ? Colors.white : VaultTheme.glowCyan.withOpacity(0.9),
                      ).animate(target: _isAuthenticating ? 1 : 0).scale(end: const Offset(0.9, 0.9)).tint(color: Colors.white),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              Text(
                'Tap or scan fingerprint to unlock',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                'Montserrat, Regular, 14px',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white54, fontSize: 12),
              ),
              
              const Spacer(),
              
              // PIN Option
              TextButton(
                onPressed: () {
                  // PIN Unlock Logic
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Unlock with PIN',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Montserrat, Regular, 14px',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Icon(Icons.keyboard_arrow_up, color: Colors.white54, size: 30),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
