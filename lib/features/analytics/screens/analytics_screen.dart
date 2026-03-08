import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../domain/repositories/transaction_repository.dart';
import '../../../domain/models/transaction.dart';
import '../../../services/analysis_service.dart';
import 'negotiation_screen.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final analysis = AnalysisService();

    return Scaffold(
      appBar: AppBar(title: const Text('Spending Analytics')),
      body: transactionsAsync.when(
        data: (transactions) {
          if (transactions.isEmpty) {
            return const Center(child: Text('No data yet for analytics'));
          }
          
          final categoryData = analysis.getSpendingByCategory(transactions);
          final recurringBills = analysis.identifyRecurring(transactions);
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSpendingPieChart(context, categoryData),
                const SizedBox(height: 32),
                _buildSpendingList(context, categoryData),
                const SizedBox(height: 32),
                Text('Recurring Bills', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildRecurringBillsList(context, recurringBills),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSpendingPieChart(BuildContext context, Map<TransactionCategory, double> data) {
    return SizedBox(
      height: 300,
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
                  radius: 50,
                );
              }).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 70,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total Spending', style: Theme.of(context).textTheme.bodySmall),
              Text(
                '${r'$'}${data.values.fold(0.0, (a, b) => a + b).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingList(BuildContext context, Map<TransactionCategory, double> data) {
    return Column(
      children: data.entries.map((e) {
        return ListTile(
          leading: CircleAvatar(backgroundColor: _getCategoryColor(e.key), radius: 8),
          title: Text(e.key.name.toUpperCase()),
          trailing: Text('${r'$'}${e.value.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
        );
      }).toList(),
    );
  }

  Widget _buildRecurringBillsList(BuildContext context, List<Transaction> bills) {
    if (bills.isEmpty) return const Text('No recurring bills detected yet.', style: TextStyle(color: Colors.grey));

    return Column(
      children: bills.map((tx) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.repeat, color: Colors.blue),
            title: Text(tx.merchant),
            subtitle: const Text('Found in monthly history'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${r'$'}${tx.amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => NegotiationScreen(transaction: tx)));
                  },
                  style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                  child: const Text('Negotiate', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getCategoryColor(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.food: return Colors.orange;
      case TransactionCategory.transport: return Colors.blue;
      case TransactionCategory.shopping: return Colors.purple;
      case TransactionCategory.housing: return Colors.brown;
      case TransactionCategory.utilities: return Colors.cyan;
      case TransactionCategory.health: return Colors.red;
      case TransactionCategory.entertainment: return Colors.pink;
      case TransactionCategory.income: return Colors.green;
      case TransactionCategory.other: return Colors.grey;
    }
  }
}
