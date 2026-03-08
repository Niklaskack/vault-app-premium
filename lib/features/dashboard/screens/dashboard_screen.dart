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

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vault Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(transactionsProvider),
        child: transactionsAsync.when(
          data: (transactions) => _buildContent(context, ref, transactions),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionModal(context),
        child: const Icon(Icons.add),
      ).animate().fadeIn(duration: 400.ms).move(begin: const Offset(0, 10), end: Offset.zero, curve: Curves.easeOutBack),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, List<Transaction> transactions) {
    final totalSpent = transactions.where((t) => t.type == TransactionType.expense).fold(0.0, (sum, item) => sum + item.amount);
    final totalIncome = transactions.where((t) => t.type == TransactionType.income).fold(0.0, (sum, item) => sum + item.amount);
    final balance = totalIncome - totalSpent;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBalanceCard(context, balance),
          const SizedBox(height: 16),
          _buildBankSyncCard(context, ref),
          const SizedBox(height: 16),
          _buildSmsSyncCard(context, ref),
          const SizedBox(height: 24),
          Text('Recent Transactions', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          if (transactions.isEmpty)
            _buildEmptyState(context)
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length > 5 ? 5 : transactions.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: tx.type == TransactionType.income ? Colors.green.shade100 : Colors.red.shade100,
                    child: Icon(
                      tx.type == TransactionType.income ? Icons.arrow_upward : Icons.arrow_downward,
                      color: tx.type == TransactionType.income ? Colors.green : Colors.red,
                    ),
                  ),
                  title: Text(tx.merchant, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(DateFormat('MMM dd, yyyy').format(tx.date)),
                  trailing: Text(
                    '${tx.type == TransactionType.expense ? '-' : '+'}${NumberFormat.currency(symbol: r'$').format(tx.amount)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: tx.type == TransactionType.income ? Colors.green : Colors.red,
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 24),
          _buildInsightsSection(context, ref, transactions),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, double balance) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Balance', style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            NumberFormat.currency(symbol: r'$').format(balance),
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.security, color: Colors.white70, size: 16),
              const SizedBox(width: 8),
              Text('Encrypted & Offline', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
            ],
          ),
        ],
      ).animate().fadeIn(duration: 600.ms).move(begin: const Offset(0, 20), end: Offset.zero),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.receipt_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text('No transactions yet', style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            const Text('Add your first transaction manually or wait for SMS sync.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
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

  Widget _buildInsightsSection(BuildContext context, WidgetRef ref, List<Transaction> transactions) {
    final analysis = ref.watch(analysisServiceProvider);
    final insights = analysis.getActionableInsights(transactions);

    if (insights.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Proactive Insights', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
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
                            DefaultTabController.of(context).animateTo(2); // Analytics Tab
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
