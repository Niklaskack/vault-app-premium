import 'dart:math';
import '../domain/models/transaction.dart';

class AnalysisService {
  // Simple anomaly detection for MVP
  // Eventually will use TFLite model (Isolation Forest)
  
  bool isAnomaly(Transaction tx, List<Transaction> history) {
    if (history.isEmpty) return false;
    
    // Rule 1: Amount significantly higher than average
    final amounts = history.map((t) => t.amount).toList();
    final avg = amounts.reduce((a, b) => a + b) / amounts.length;
    final stdDev = sqrt(amounts.map((a) => pow(a - avg, 2)).reduce((a, b) => a + b) / amounts.length);
    
    if (tx.amount > avg + 3 * stdDev) return true; // 3 sigma rule
    
    // Rule 2: Unusual merchant
    final merchants = history.map((t) => t.merchant).toSet();
    if (!merchants.contains(tx.merchant) && tx.amount > 100) return true;
    
    return false;
  }

  Map<TransactionCategory, double> getSpendingByCategory(List<Transaction> transactions) {
    final Map<TransactionCategory, double> data = {};
    for (var tx in transactions) {
      if (tx.type == TransactionType.expense) {
        data[tx.category] = (data[tx.category] ?? 0) + tx.amount;
      }
    }
    return data;
  }

  double forecastNextMonth(List<Transaction> history) {
    if (history.length < 30) return 0.0; // Need more data
    
    // Simple average of past 3 months
    final expenses = history.where((t) => t.type == TransactionType.expense).map((t) => t.amount).toList();
    if (expenses.isEmpty) return 0.0;
    
    return expenses.reduce((a, b) => a + b) / (history.last.date.difference(history.first.date).inDays / 30);
  }

  List<Transaction> identifyRecurring(List<Transaction> history) {
    // Identify transactions with same merchant and similar amount occurring monthly
    final Map<String, List<Transaction>> grouped = {};
    for (var tx in history) {
      grouped.update(tx.merchant, (list) => list..add(tx), ifAbsent: () => [tx]);
    }

    return grouped.values
        .where((list) => list.length >= 2)
        .where((list) {
          // Check if dates are roughly 30 days apart
          list.sort((a, b) => a.date.compareTo(b.date));
          for (int i = 0; i < list.length - 1; i++) {
            final diff = list[i+1].date.difference(list[i].date).inDays;
            if (diff >= 25 && diff <= 35) return true;
          }
          return false;
        })
        .map((list) => list.first)
        .toList();
  }

  List<String> getNegotiationTips(String merchant) {
    return [
      'Hi, I have been a loyal customer for a while and noticed my bill is higher than new promotional rates.',
      'I am considering switching to a competitor for a better rate. Is there anything you can do to lower my monthly cost?',
      'I would like to stay with your service but need to find some savings. Are there any discounts available on my account?'
    ];
  }

  List<ActionableInsight> getActionableInsights(List<Transaction> transactions) {
    final List<ActionableInsight> insights = [];
    final recurring = identifyRecurring(transactions);

    if (recurring.isNotEmpty) {
      insights.add(ActionableInsight(
        title: 'Potential Savings Detected',
        message: 'We found ${recurring.length} recurring bills. Negotiating these could save you ${r'$'}200+ annually.',
        type: InsightType.saving,
        actionLabel: 'Review Bills',
      ));
    }

    for (var tx in transactions) {
      if (tx.amount > 500 && tx.type == TransactionType.expense) {
        insights.add(ActionableInsight(
          title: 'Unusual Large Expense',
          message: 'You spent ${r'$'}${tx.amount} at ${tx.merchant}. Does this look correct?',
          type: InsightType.alert,
          actionLabel: 'View Details',
        ));
        break;
      }
    }

    return insights;
  }
}

enum InsightType { saving, alert, tip }

class ActionableInsight {
  final String title;
  final String message;
  final InsightType type;
  final String actionLabel;

  ActionableInsight({
    required this.title,
    required this.message,
    required this.type,
    required this.actionLabel,
  });
}
