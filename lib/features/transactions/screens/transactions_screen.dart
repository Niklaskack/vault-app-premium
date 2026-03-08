import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repositories/transaction_repository.dart';
import '../../../domain/models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Transactions'),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: transactionsAsync.when(
        data: (transactions) => ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final tx = transactions[index];
            return ListTile(
              title: Text(tx.merchant),
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
