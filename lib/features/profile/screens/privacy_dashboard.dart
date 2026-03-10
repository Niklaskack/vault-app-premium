import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'paywall_screen.dart';

class PrivacyDashboard extends StatelessWidget {
  const PrivacyDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030712), // Cosmic Black
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'G O V E R N A N C E',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 4.0,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        leading: const BackButton(color: Colors.white70),
      ),
      body: Stack(
        children: [
          _buildBackgroundGlows(context),
          ListView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 80,
              left: 20,
              right: 20,
              bottom: 40,
            ),
            children: [
              _buildSecurityHeader(context),
              const SizedBox(height: 40),
              _buildSectionHeader('CORE PROTOCOLS'),
              const SizedBox(height: 16),
              _buildSecurityNode(
                context,
                'ZERO KNOWLEDGE',
                'Device-side encryption active. Vault keys never leave this hardware.',
                Icons.vpn_lock_rounded,
                const Color(0xFF10B981),
              ),
              _buildSecurityNode(
                context,
                'NEURAL ISOLATION',
                'TensorFlow processing is air-gapped from external cloud networks.',
                Icons.memory_rounded,
                const Color(0xFF38B6FF),
              ),
              const SizedBox(height: 32),
              _buildSectionHeader('ACCESS PERMISSIONS'),
              const SizedBox(height: 16),
              _buildPermissionCard(context, 'SMS INGESTION', 'Automated transaction tracking', true),
              _buildPermissionCard(context, 'BIOMETRIC CORE', 'Secure authentication layer', true),
              const SizedBox(height: 48),
              _buildKillSwitch(context),
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
          bottom: -50,
          right: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [const Color(0xFFEF4444).withOpacity(0.05), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityHeader(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF10B981).withOpacity(0.2)),
            ),
            child: const Icon(Icons.shield_rounded, color: Color(0xFF10B981), size: 40),
          ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2.seconds),
          const SizedBox(height: 24),
          const Text(
            'SYSTEM GUARDED',
            style: TextStyle(
              color: Color(0xFF10B981),
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Active Encryption: AES-256-GCM',
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
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

  Widget _buildSecurityNode(BuildContext context, String title, String description, IconData icon, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 24),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideX(begin: 0.1, end: 0);
  }

  Widget _buildPermissionCard(BuildContext context, String title, String subtitle, bool enabled) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 12,
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
          value: enabled,
          onChanged: (v) {},
          activeColor: const Color(0xFF38B6FF),
          activeTrackColor: const Color(0xFF38B6FF).withOpacity(0.2),
        ),
      ),
    );
  }

  Widget _buildKillSwitch(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444).withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.1)),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () => _showDeleteConfirmation(context),
            contentPadding: const EdgeInsets.all(20),
            leading: const Icon(Icons.delete_sweep_rounded, color: Color(0xFFEF4444)),
            title: const Text(
              'NEURAL KILL SWITCH',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.w900,
                fontSize: 13,
                letterSpacing: 1.0,
              ),
            ),
            subtitle: Text(
              'Irreversibly wipe all local storage nodes',
              style: TextStyle(
                color: const Color(0xFFEF4444).withOpacity(0.4),
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text(
            'CONFIRM PURGE',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 2.0),
          ),
          content: Text(
            'This will execute a nuclear wipe of all transaction nodes and secure keys. This action is terminal.',
            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'ABORT',
                style: TextStyle(color: Colors.white.withOpacity(0.4), fontWeight: FontWeight.w900),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'EXECUTE WIPE',
                style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
