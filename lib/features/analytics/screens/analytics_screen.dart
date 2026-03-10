import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../domain/repositories/transaction_repository.dart';
import '../../../domain/models/transaction.dart';
import '../../../services/analysis_service.dart';
import '../../../core/providers/service_providers.dart';
import '../../../core/providers/premium_provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../profile/screens/paywall_screen.dart';
import 'negotiation_screen.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final analysis = ref.watch(analysisServiceProvider);
    final isPremium = ref.watch(isPremiumProvider);
    final l10n = ref.watch(l10nProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF030712), // Cosmic Black
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.translate('nav_analytics'),
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
          transactionsAsync.when(
            data: (transactions) {
              if (transactions.isEmpty) {
                return _buildEmptyState(context, l10n);
              }
              
              final categoryData = analysis.getSpendingByCategory(transactions);
              final recurringBills = analysis.identifyRecurring(transactions);
              final forecast = analysis.generateForecast(transactions);
              
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 80,
                  left: 20,
                  right: 20,
                  bottom: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNeuralForecast(context, l10n, forecast, isPremium),
                    const SizedBox(height: 48),
                    _buildSpendingPieChart(context, l10n, categoryData),
                    const SizedBox(height: 40),
                    Text(
                      l10n.translate('analytics_category_allocation'),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Colors.white.withOpacity(0.4),
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSpendingList(context, l10n, categoryData),
                    const SizedBox(height: 48),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.translate('analytics_recurring'),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: Colors.white.withOpacity(0.4),
                            letterSpacing: 2.0,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF38B6FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF38B6FF).withOpacity(0.2)),
                          ),
                          child: Text(
                            l10n.translate('analytics_ai_detected'),
                            style: const TextStyle(color: Color(0xFF38B6FF), fontSize: 9, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildRecurringBillsList(context, l10n, recurringBills),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF38B6FF))),
            error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.redAccent))),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundGlows(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 100,
          right: -50,
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
        Positioned(
          bottom: -50,
          left: -50,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [const Color(0xFF38B6FF).withOpacity(0.1), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpendingPieChart(BuildContext context, AppLocalizations l10n, Map<TransactionCategory, double> data) {
    final total = data.values.fold(0.0, (a, b) => a + b);

    return SizedBox(
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sections: data.entries.map((e) {
                return PieChartSectionData(
                  color: _getCategoryColor(e.key),
                  value: e.value,
                  title: '',
                  radius: 35,
                  showTitle: false,
                );
              }).toList(),
              sectionsSpace: 4,
              centerSpaceRadius: 85,
            ),
          ).animate().scale(duration: 1.seconds, curve: Curves.easeOutBack),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.translate('analytics_net_burn'),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.formatCurrency(total),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingList(BuildContext context, AppLocalizations l10n, Map<TransactionCategory, double> data) {
    final sortedData = data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12),
        itemCount: sortedData.length,
        separatorBuilder: (_, __) => Divider(color: Colors.white.withOpacity(0.03), height: 1),
        itemBuilder: (context, index) {
          final e = sortedData[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            leading: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getCategoryColor(e.key),
                boxShadow: [
                  BoxShadow(color: _getCategoryColor(e.key).withOpacity(0.4), blurRadius: 8),
                ],
              ),
            ),
            title: Text(
              e.key.name.toUpperCase(),
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w900,
                fontSize: 11,
                letterSpacing: 1.0,
              ),
            ),
            trailing: Text(
              l10n.formatCurrency(e.value),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecurringBillsList(BuildContext context, AppLocalizations l10n, List<Transaction> bills) {
    if (bills.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          children: [
            Icon(Icons.auto_awesome_rounded, color: Colors.white.withOpacity(0.1), size: 40),
            const SizedBox(height: 16),
            Text(
              '${l10n.translate('analytics_no_cycles')}\n${l10n.translate('analytics_train_engine')}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11, height: 1.5),
            ),
          ],
        ),
      );
    }

    return Column(
      children: bills.map((tx) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF38B6FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.sync_rounded, color: Color(0xFF38B6FF), size: 20),
            ),
            title: Text(
              tx.merchant.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 13,
                letterSpacing: 1.0,
              ),
            ),
            subtitle: Text(
              l10n.translate('analytics_cycle_detected'),
              style: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  l10n.formatCurrency(tx.amount),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NegotiationScreen(transaction: tx))),
                  child: Text(
                    l10n.translate('analytics_negotiate'),
                    style: TextStyle(
                      color: const Color(0xFF38B6FF),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                      decoration: TextDecoration.underline,
                      decorationColor: const Color(0xFF38B6FF).withOpacity(0.3),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0);
      }).toList(),
    );
  }

  Widget _buildNeuralForecast(BuildContext context, AppLocalizations l10n, ForecastData forecast, bool isPremium) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.translate('analytics_neural_forecast'),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: Colors.white.withOpacity(0.4),
                letterSpacing: 2.0,
              ),
            ),
            if (!isPremium)
              const Icon(Icons.lock_rounded, color: Color(0xFFF59E0B), size: 14),
          ],
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.translate('analytics_safe_to_spend'),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${l10n.formatCurrency(forecast.safeToSpendDaily)} / DAY',
                      style: const TextStyle(
                        color: Color(0xFF38B6FF),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 120,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: forecast.projectionPoints.asMap().entries.map((e) {
                                return FlSpot(e.key.toDouble(), e.value);
                              }).toList(),
                              isCurved: true,
                              color: const Color(0xFF38B6FF),
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: const Color(0xFF38B6FF).withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isPremium)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PaywallScreen())),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(
                        color: Colors.black.withOpacity(0.2),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              l10n.translate('analytics_unlock_forecast'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 10,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.analytics_outlined, size: 80, color: Colors.white.withOpacity(0.05)),
          const SizedBox(height: 24),
          Text(
            l10n.translate('analytics_engine_standby'),
            style: const TextStyle(
              color: Colors.white30,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 4.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.translate('analytics_engine_standby_msg'),
            style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 11),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.food: return const Color(0xFFF87171);
      case TransactionCategory.transport: return const Color(0xFF60A5FA);
      case TransactionCategory.shopping: return const Color(0xFFC084FC);
      case TransactionCategory.housing: return const Color(0xFFFBBF24);
      case TransactionCategory.utilities: return const Color(0xFF2DD4BF);
      case TransactionCategory.health: return const Color(0xFFF472B6);
      case TransactionCategory.entertainment: return const Color(0xFF818CF8);
      case TransactionCategory.income: return const Color(0xFF34D399);
      case TransactionCategory.other: return const Color(0xFF94A3B8);
    }
  }
}
