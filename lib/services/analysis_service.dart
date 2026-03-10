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
    return generateForecast(history).projectedTotal;
  }

  ForecastData generateForecast(List<Transaction> history) {
    if (history.isEmpty) return ForecastData.empty();

    final now = DateTime.now();
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    final daysRemaining = endOfMonth.difference(now).inDays;

    // 1. Identify Fixed Recurring Costs
    final recurring = identifyRecurring(history);
    final totalRecurring = recurring.fold(0.0, (sum, tx) => sum + tx.amount);

    // 2. Identify Variable Daily Spending (moving average of last 14 days)
    final twoWeeksAgo = now.subtract(const Duration(days: 14));
    final variableExpenses = history.where((t) {
      return t.type == TransactionType.expense && 
             t.date.isAfter(twoWeeksAgo) &&
             !recurring.any((r) => r.merchant == t.merchant);
    }).toList();

    double avgDailyVariable = 0;
    if (variableExpenses.isNotEmpty) {
      avgDailyVariable = variableExpenses.fold(0.0, (sum, tx) => sum + tx.amount) / 14;
    }

    // 3. Generate Projection Points (Next 30 Days)
    final List<double> projectionPoints = [];
    double currentHypotheticalBalance = 0; // Starting from relative zero for the chart
    
    for (int i = 0; i < 30; i++) {
      currentHypotheticalBalance -= avgDailyVariable;
      // Add recurring if it falls on this day (simplified)
      if (i % 30 == 0) currentHypotheticalBalance -= totalRecurring; 
      projectionPoints.add(currentHypotheticalBalance);
    }

    final projectedTotal = totalRecurring + (avgDailyVariable * 30);
    final safeToSpend = avgDailyVariable > 0 ? avgDailyVariable : 50.0; // Fallback to $50

    return ForecastData(
      projectedTotal: projectedTotal,
      safeToSpendDaily: safeToSpend,
      projectionPoints: projectionPoints,
    );
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

class ForecastData {
  final double projectedTotal;
  final double safeToSpendDaily;
  final List<double> projectionPoints;

  ForecastData({
    required this.projectedTotal,
    required this.safeToSpendDaily,
    required this.projectionPoints,
  });

  factory ForecastData.empty() => ForecastData(
    projectedTotal: 0,
    safeToSpendDaily: 0,
    projectionPoints: [],
  );
}
