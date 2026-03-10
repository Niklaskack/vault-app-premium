import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/providers/premium_provider.dart';
import '../../../core/l10n/app_localizations.dart';
import 'privacy_dashboard.dart';
import 'paywall_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final isPremium = ref.watch(isPremiumProvider);
    final l10n = ref.watch(l10nProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF030712), // Cosmic Black
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.translate('nav_profile'),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 4.0,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _buildBackgroundGlows(context),
          ListView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 60,
              left: 20,
              right: 20,
              bottom: 40,
            ),
            children: [
              _buildEliteHeader(context, isPremium),
              const SizedBox(height: 40),
              _buildSectionHeader(l10n.translate('profile_identity')),
              const SizedBox(height: 16),
              _buildActionCard(
                context,
                title: l10n.translate('profile_legal_identity'),
                subtitle: l10n.translate('profile_elite_member'),
                icon: Icons.badge_rounded,
                onTap: () {},
              ),
              _buildActionCard(
                context,
                title: l10n.translate('profile_governance_email'),
                subtitle: l10n.translate('profile_shielded_email'),
                icon: Icons.alternate_email_rounded,
                onTap: () {},
              ),
              const SizedBox(height: 32),
              _buildSectionHeader(l10n.translate('profile_security')),
              const SizedBox(height: 16),
              _buildActionCard(
                context,
                title: l10n.translate('profile_privacy_dashboard'),
                subtitle: l10n.translate('profile_zero_knowledge'),
                icon: Icons.vpn_lock_rounded,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyDashboard())),
              ),
              _buildToggleCard(
                context,
                title: l10n.translate('profile_app_lock'),
                subtitle: l10n.translate('profile_biometric'),
                icon: Icons.fingerprint_rounded,
                value: settings.isLockEnabled,
                onChanged: (v) => ref.read(appSettingsProvider.notifier).setLockEnabled(v),
              ),
              const SizedBox(height: 32),
              _buildSectionHeader(l10n.translate('profile_system')),
              const SizedBox(height: 16),
              _buildLanguageCard(context, ref, l10n, settings),
              _buildActionCard(
                context,
                title: l10n.translate('profile_export_data'),
                subtitle: l10n.translate('profile_download_json'),
                icon: Icons.ios_share_rounded,
                onTap: () {},
              ),
              _buildActionCard(
                context,
                title: l10n.translate('profile_about'),
                subtitle: l10n.translate('profile_version'),
                icon: Icons.info_outline_rounded,
                onTap: () {},
              ),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  l10n.translate('profile_session_encrypted'),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.15),
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundGlows(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [const Color(0xFF1E40AF).withOpacity(0.1), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEliteHeader(BuildContext context, bool isPremium) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF38B6FF).withOpacity(0.2), width: 2),
              ),
            ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 3.seconds),
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFF1F2937),
              child: Icon(Icons.person_outline_rounded, size: 40, color: Colors.white70),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'V A U L T  U S E R',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: isPremium ? const Color(0xFFF59E0B).withOpacity(0.1) : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isPremium ? const Color(0xFFF59E0B).withOpacity(0.2) : Colors.white.withOpacity(0.1),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.star_rounded, 
                size: 14, 
                color: isPremium ? const Color(0xFFF59E0B) : Colors.white38
              ),
              const SizedBox(width: 8),
              Text(
                isPremium ? 'ELITE MEMBER' : 'STANDARD ACCESS',
                style: TextStyle(
                  color: isPremium ? const Color(0xFFF59E0B) : Colors.white38,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ).animate().scale(delay: 200.ms, curve: Curves.easeOutBack),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: Colors.white.withOpacity(0.3),
        letterSpacing: 2.0,
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white70, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 13,
            letterSpacing: 1.0,
          ),
        ),
        subtitle: Text(
          subtitle.toUpperCase(),
          style: TextStyle(
            color: Colors.white.withOpacity(0.3),
            fontSize: 8,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        trailing: Icon(Icons.chevron_right_rounded, color: Colors.white.withOpacity(0.2)),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0);
  }

  Widget _buildToggleCard(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF38B6FF), size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 13,
            letterSpacing: 1.0,
          ),
        ),
        subtitle: Text(
          subtitle.toUpperCase(),
          style: TextStyle(
            color: Colors.white.withOpacity(0.3),
            fontSize: 8,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF38B6FF),
          activeTrackColor: const Color(0xFF38B6FF).withOpacity(0.2),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0);
  }

  Widget _buildLanguageCard(BuildContext context, WidgetRef ref, AppLocalizations l10n, AppSettings settings) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        onTap: () {
          final newLang = settings.languageCode == 'en' ? 'sv' : 'en';
          ref.read(appSettingsProvider.notifier).setLanguageCode(newLang);
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.language_rounded, color: Color(0xFF38B6FF), size: 20),
        ),
        title: Text(
          l10n.translate('profile_language'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 13,
            letterSpacing: 1.0,
          ),
        ),
        subtitle: Text(
          l10n.translate('profile_current_lang'),
          style: TextStyle(
            color: Colors.white.withOpacity(0.3),
            fontSize: 8,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        trailing: Icon(Icons.sync_rounded, color: Colors.white.withOpacity(0.2), size: 18),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0);
  }
}
