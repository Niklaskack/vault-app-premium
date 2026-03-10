import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../domain/repositories/transaction_repository.dart';
import '../../../domain/models/transaction.dart';
import '../../../core/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

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
          l10n.translate('nav_transactions'),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 4.0,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildBackgroundGlows(context),
          transactionsAsync.when(
            data: (transactions) => ListView.builder(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 80,
                left: 20,
                right: 20,
                bottom: 40,
              ),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return _buildTransactionCard(context, tx, index);
              },
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(color: Color(0xFF38B6FF)),
            ),
            error: (err, stack) => Center(
              child: Text(
                'SYSTEM ERROR: $err',
                style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
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
                colors: [const Color(0xFF1E40AF).withOpacity(0.1), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionCard(BuildContext context, Transaction tx, int index) {
    final isExpense = tx.type == TransactionType.expense;

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
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _getCategoryColor(tx.category).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            _getCategoryIcon(tx.category),
            color: _getCategoryColor(tx.category),
            size: 20,
          ),
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
          DateFormat('MMM dd, yyyy').format(tx.date).toUpperCase(),
          style: TextStyle(
            color: Colors.white.withOpacity(0.3),
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        trailing: Text(
          '${isExpense ? '-' : '+'}${NumberFormat.currency(symbol: r'$').format(tx.amount)}',
          style: TextStyle(
            color: isExpense ? const Color(0xFFF87171) : const Color(0xFF34D399),
            fontWeight: FontWeight.w900,
            fontSize: 15,
            letterSpacing: -0.5,
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: (index * 50).ms).slideX(begin: 0.1, end: 0);
  }

  IconData _getCategoryIcon(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.food: return Icons.restaurant_rounded;
      case TransactionCategory.transport: return Icons.directions_car_rounded;
      case TransactionCategory.shopping: return Icons.shopping_bag_rounded;
      case TransactionCategory.housing: return Icons.home_rounded;
      case TransactionCategory.utilities: return Icons.electric_bolt_rounded;
      case TransactionCategory.health: return Icons.medical_services_rounded;
      case TransactionCategory.entertainment: return Icons.movie_rounded;
      case TransactionCategory.income: return Icons.wallet_rounded;
      case TransactionCategory.other: return Icons.more_horiz_rounded;
    }
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
