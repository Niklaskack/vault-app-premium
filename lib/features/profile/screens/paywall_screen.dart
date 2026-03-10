import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../services/subscription_service.dart';

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF030712), // Cosmic Black
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white70),
      ),
      body: Stack(
        children: [
          // Atmospheric Background Glows
          _buildBackgroundGlows(context),
          
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 100, 24, 40),
                  child: Column(
                    children: [
                      const Icon(Icons.auto_awesome_rounded, size: 64, color: Color(0xFF38B6FF))
                        .animate(onPlay: (controller) => controller.repeat())
                        .shimmer(duration: 2.seconds, color: Colors.white30)
                        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 2.seconds, curve: Curves.easeInOut),
                      const SizedBox(height: 24),
                      const Text(
                        'V A U L T   P R E M I U M',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 6.0,
                        ),
                      ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 12),
                      Text(
                        'UNLEASH THE POWER OF SECURE INTELLIGENCE',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.0,
                        ),
                      ).animate().fadeIn(delay: 200.ms),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildFeatureItem(
                      context, 
                      'REAL-TIME SYNC', 
                      'Connect unlimited nodes with encrypted bank-grade protocols.',
                      Icons.account_balance_rounded,
                      const Color(0xFF38B6FF),
                    ),
                    _buildFeatureItem(
                      context, 
                      'AI NEURAL INSIGHTS', 
                      'Predictive forecasting and anomaly detection on-device.',
                      Icons.psychology_rounded,
                      const Color(0xFF10B981),
                    ),
                    _buildFeatureItem(
                      context, 
                      'SMART NEGOTIATOR', 
                      'Autonomous identification of bill reductions and savings.',
                      Icons.auto_awesome_motion_rounded,
                      const Color(0xFFF59E0B),
                    ),
                    _buildFeatureItem(
                      context, 
                      'ZERO-KNOWLEDGE PRIVACY', 
                      'Hardware-level encryption for all your financial data.',
                      Icons.security_rounded,
                      const Color(0xFFEF4444),
                    ),
                    const SizedBox(height: 48),
                    _buildPricingCard(context, ref),
                    const SizedBox(height: 32),
                    Center(
                      child: Text(
                        'SECURED WITH AES-256 ENCRYPTION',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.2),
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                  ]),
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
          left: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [const Color(0xFF1E40AF).withOpacity(0.2), Colors.transparent],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          right: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [const Color(0xFF38B6FF).withOpacity(0.15), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(BuildContext context, String title, String subtitle, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
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
                    fontSize: 12,
                    letterSpacing: 1.5,
                  )
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle, 
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4), 
                    fontSize: 11,
                    height: 1.4,
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0);
  }

  Widget _buildPricingCard(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            gradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.05), Colors.transparent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Text(
                'QUANTUM ACCESS',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                  letterSpacing: 3.0,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                r'$2.99',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -2.0,
                ),
              ),
              Text(
                'PER MONTH',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2563EB).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => SubscriptionService.purchasePremium(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text(
                      'ACTIVATE 7-DAY TRIAL', 
                      style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5)
                    ),
                  ),
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(duration: 3.seconds, delay: 1.seconds),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'CONTINUE WITH LIMITED ACCESS', 
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.3),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 400.ms).slideY(begin: 0.1, end: 0);
  }
}
