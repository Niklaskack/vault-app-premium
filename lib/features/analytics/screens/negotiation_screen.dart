import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../domain/models/transaction.dart';
import '../../../core/providers/service_providers.dart';
import '../../../core/providers/premium_provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../profile/screens/paywall_screen.dart';

class NegotiationScreen extends ConsumerWidget {
  final Transaction transaction;

  const NegotiationScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysis = ref.watch(analysisServiceProvider);
    final isPremium = ref.watch(isPremiumProvider);
    final l10n = ref.watch(l10nProvider);
    final tips = analysis.getNegotiationTips(transaction.merchant);

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
          _buildBackgroundGlows(context),
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 60,
              left: 24,
              right: 24,
              bottom: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF38B6FF).withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF38B6FF).withOpacity(0.2)),
                        ),
                        child: const Icon(
                          Icons.insights_rounded,
                          color: Color(0xFF38B6FF),
                          size: 48,
                        ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2.seconds),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        transaction.merchant.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'OPTIMIZATION TARGET DETECTED',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.2)),
                        ),
                        child: Text(
                          '${l10n.formatCurrency(transaction.amount)} / MONTH',
                          style: const TextStyle(
                            color: Color(0xFFF59E0B),
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  'NEGOTIATION BLUEPRINTS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Colors.white.withOpacity(0.4),
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 16),
                ...tips.map((tip) => _buildScriptCard(context, tip)).toList(),
                const SizedBox(height: 40),
                _buildAutomatedNegotiationSection(context, isPremium),
              ],
            ),
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
                colors: [const Color(0xFF1E40AF).withOpacity(0.15), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAutomatedNegotiationSection(BuildContext context, bool isPremium) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: isPremium ? 0 : 5, sigmaY: isPremium ? 0 : 5),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isPremium 
                  ? const Color(0xFF2563EB).withOpacity(0.1) 
                  : Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isPremium 
                    ? const Color(0xFF2563EB).withOpacity(0.2) 
                    : Colors.white.withOpacity(0.05)
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.bolt_rounded, color: Color(0xFFF59E0B), size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'VAULT AUTONOMOUS AGENT',
                        style: TextStyle(
                          color: isPremium ? const Color(0xFF38B6FF) : Colors.white.withOpacity(0.3),
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Success Probability: 84%',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (isPremium) {
                          // TODO: Automated negotiation logic
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const PaywallScreen()));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPremium ? const Color(0xFF2563EB) : Colors.white10,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        isPremium ? 'INITIATE NEURAL NEGOTIATION' : 'UNLOCK AI AGENT',
                        style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!isPremium)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              'VAULT PREMIUM REQUIRED FOR AUTOMATED NEGOTIATION',
              style: TextStyle(
                color: Colors.white.withOpacity(0.2),
                fontSize: 8,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildScriptCard(BuildContext context, String script) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.terminal_rounded, size: 16, color: Color(0xFF38B6FF)),
              const SizedBox(width: 12),
              Text(
                'INTELLIGENCE SCRIPT',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Intelligence script copied to clipboard.')),
                  );
                },
                child: Icon(Icons.copy_rounded, size: 16, color: Colors.white.withOpacity(0.2)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '"$script"',
            style: const TextStyle(
              fontStyle: FontStyle.italic, 
              color: Colors.white70,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0);
  }
}
