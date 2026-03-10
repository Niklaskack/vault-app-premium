import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../domain/models/transaction.dart';
import '../../../domain/repositories/transaction_repository.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../transactions/widgets/add_transaction_modal.dart';
import '../../../services/analysis_service.dart';
import '../../../core/providers/service_providers.dart';
import '../../../services/bank_sync_service.dart';
import '../../../core/providers/premium_provider.dart';
import '../../profile/screens/paywall_screen.dart';
import '../../../core/providers/navigation_provider.dart';
import '../../../core/l10n/app_localizations.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final l10n = ref.watch(l10nProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF030712), // Cosmic Black
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.translate('app_title'),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 4.0,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Atmospheric Background Glows
          _buildBackgroundGlows(context),
          
          RefreshIndicator(
            onRefresh: () async => ref.refresh(transactionsProvider),
            displacement: 100,
            child: transactionsAsync.when(
              data: (transactions) => _buildContent(context, ref, l10n, transactions),
              loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF38B6FF))),
              error: (err, stack) => Center(child: Text('${l10n.translate('dash_sync_error')}: $err', style: const TextStyle(color: Colors.redAccent))),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionModal(context),
        backgroundColor: const Color(0xFF2563EB),
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, size: 30, color: Colors.white),
      ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), curve: Curves.easeOutBack),
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

  Widget _buildContent(BuildContext context, WidgetRef ref, AppLocalizations l10n, List<Transaction> transactions) {
    final totalSpent = transactions.where((t) => t.type == TransactionType.expense).fold(0.0, (sum, item) => sum + item.amount);
    final totalIncome = transactions.where((t) => t.type == TransactionType.income).fold(0.0, (sum, item) => sum + item.amount);
    final balance = totalIncome - totalSpent;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 70,
        left: 20,
        right: 20,
        bottom: 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBalanceCard(context, l10n, balance),
          const SizedBox(height: 24),
          _buildQuickActionsRow(context, ref, l10n),
          const SizedBox(height: 32),
          Text(
            l10n.translate('dash_latest_activity'),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Colors.white.withOpacity(0.4),
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 16),
          if (transactions.isEmpty)
            _buildEmptyState(context, l10n)
          else
            _buildTransactionList(context, transactions),
          const SizedBox(height: 32),
          _buildInsightsSection(context, ref, l10n, transactions),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, AppLocalizations l10n, double balance) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withOpacity(0.4),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Stack(
        children: [
          // Cyber Patterns (simplified)
          Positioned(
            right: -20,
            top: -20,
            child: Icon(Icons.security_rounded, size: 100, color: Colors.white.withOpacity(0.03)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.translate('dash_encrypted_balance'),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                NumberFormat.currency(symbol: r'$').format(balance),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF38B6FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF38B6FF).withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off_rounded, color: Color(0xFF38B6FF), size: 14),
                    const SizedBox(width: 8),
                    Text(
                      l10n.translate('dash_local_node'),
                      style: TextStyle(
                        color: const Color(0xFF38B6FF).withOpacity(0.8),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildQuickActionsRow(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(child: _buildSmallActionCard(context, ref, l10n.translate('dash_bank_sync'), Icons.account_balance_rounded, true)),
        const SizedBox(width: 16),
        Expanded(child: _buildSmallActionCard(context, ref, l10n.translate('dash_sms_parse'), Icons.sms_rounded, false)),
      ],
    );
  }

  Widget _buildSmallActionCard(BuildContext context, WidgetRef ref, String label, IconData icon, bool primary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primary ? const Color(0xFF38B6FF) : Colors.greenAccent, size: 24),
          const SizedBox(height: 14),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Colors.white38,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(BuildContext context, List<Transaction> transactions) {
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
         itemCount: transactions.length > 5 ? 5 : transactions.length,
         separatorBuilder: (_, __) => Divider(color: Colors.white.withOpacity(0.05)),
         itemBuilder: (context, index) {
           final tx = transactions[index];
           final isExpense = tx.type == TransactionType.expense;
           return ListTile(
             contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
             leading: Container(
               width: 44,
               height: 44,
               decoration: BoxDecoration(
                 color: isExpense ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                 borderRadius: BorderRadius.circular(14),
               ),
               child: Icon(
                 isExpense ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                 color: isExpense ? Colors.redAccent : Colors.greenAccent,
                 size: 18,
               ),
             ),
             title: Text(
               tx.merchant.toUpperCase(),
               style: const TextStyle(
                 fontWeight: FontWeight.w900, 
                 color: Colors.white, 
                 fontSize: 13,
                 letterSpacing: 1.0,
               ),
             ),
             subtitle: Text(
               DateFormat('MMM dd').format(tx.date).toUpperCase(),
               style: TextStyle(
                 color: Colors.white.withOpacity(0.3), 
                 fontSize: 10,
                 fontWeight: FontWeight.w700,
                 letterSpacing: 0.5,
               ),
             ),
             trailing: Text(
               '${isExpense ? '-' : '+'}${NumberFormat.currency(symbol: r'$').format(tx.amount)}',
               style: TextStyle(
                 fontWeight: FontWeight.w900,
                 fontSize: 15,
                 color: isExpense ? Colors.white : Colors.greenAccent,
               ),
             ),
           );
         },
       ),
     );
  }


  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.receipt_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(l10n.translate('dash_no_transactions'), style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            Text(l10n.translate('dash_empty_instructions'), textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildBankSyncCard(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumProvider);

    return Card(
      elevation: 0,
      color: isPremium ? Colors.blue.withOpacity(0.05) : Colors.grey.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isPremium ? Colors.blue.withOpacity(0.1) : Colors.grey.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isPremium ? Colors.blue : Colors.grey,
              child: Icon(isPremium ? Icons.account_balance : Icons.lock, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Bank Sync', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    isPremium ? 'Connect your bank for auto-sync' : 'Vault Premium required', 
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (isPremium) {
                  _handleBankConnection(context, ref);
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PaywallScreen()));
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                visualDensity: VisualDensity.compact,
                backgroundColor: isPremium ? null : Colors.amber.shade700,
                foregroundColor: isPremium ? null : Colors.white,
              ),
              child: Text(isPremium ? 'Connect' : 'Unlock'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmsSyncCard(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 0,
      color: Colors.green.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.green.withOpacity(0.1)),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.sms, color: Colors.white, size: 20),
        ),
        title: const Text('SMS & Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text('Auto-detect transactions from alerts', style: TextStyle(fontSize: 12)),
        trailing: Switch(
          value: true,
          onChanged: (val) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('On-device SMS parsing active.')),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleBankConnection(BuildContext context, WidgetRef ref) async {
    // Show a loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await ref.read(bankSyncServiceProvider).connectBank("mock_secret");
      if (!context.mounted) return;
      Navigator.pop(context); // Close loading
      
      ref.invalidate(transactionsProvider);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bank connected and transactions synced!')),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context); // Close loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error connecting bank: $e')),
      );
    }
  }

  Widget _buildInsightsSection(BuildContext context, WidgetRef ref, AppLocalizations l10n, List<Transaction> transactions) {
    final analysis = ref.watch(analysisServiceProvider);
    final insights = analysis.getActionableInsights(transactions);

    if (insights.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.translate('dash_proactive_insights'), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: insights.length,
            itemBuilder: (context, index) {
              final insight = insights[index];
              return Container(
                width: 300,
                margin: const EdgeInsets.only(right: 16, bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: insight.type == InsightType.alert ? Colors.red.shade50 : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: insight.type == InsightType.alert ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          insight.type == InsightType.alert ? Icons.warning_amber : Icons.lightbulb_outline,
                          color: insight.type == InsightType.alert ? Colors.red : Colors.green,
                        ),
                        const SizedBox(width: 8),
                        Text(insight.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        insight.message,
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          if (insight.actionLabel == 'Review Bills') {
                            ref.read(navigationIndexProvider.notifier).state = 2; // Analytics Tab
                          } else {
                            // Show alert details or navigate to transaction
                          }
                        },
                        child: Text(insight.actionLabel),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn().move(begin: const Offset(0, 10), end: Offset.zero);
  }

  void _showAddTransactionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => const AddTransactionModal(),
    );
  }
}
