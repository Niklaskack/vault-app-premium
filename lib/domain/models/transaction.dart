import 'package:uuid/uuid.dart';

enum TransactionType { income, expense, transfer }

enum TransactionCategory {
  food,
  transport,
  shopping,
  housing,
  utilities,
  health,
  entertainment,
  income,
  other
}

class Transaction {
  final String id;
  final String merchant;
  final double amount;
  final DateTime date;
  final TransactionCategory category;
  final TransactionType type;
  final String? note;
  final String? rawSms;
  final bool isParsed;

  Transaction({
    String? id,
    required this.merchant,
    required this.amount,
    required this.date,
    this.category = TransactionCategory.other,
    this.type = TransactionType.expense,
    this.note,
    this.rawSms,
    this.isParsed = false,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'merchant': merchant,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category.index,
      'type': type.index,
      'note': note,
      'rawSms': rawSms,
      'isParsed': isParsed ? 1 : 0,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      merchant: map['merchant'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      category: TransactionCategory.values[map['category']],
      type: TransactionType.values[map['type']],
      note: map['note'],
      rawSms: map['rawSms'],
      isParsed: map['isParsed'] == 1,
    );
  }

  Transaction copyWith({
    String? merchant,
    double? amount,
    DateTime? date,
    TransactionCategory? category,
    TransactionType? type,
    String? note,
    String? rawSms,
    bool? isParsed,
  }) {
    return Transaction(
      id: id,
      merchant: merchant ?? this.merchant,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      type: type ?? this.type,
      note: note ?? this.note,
      rawSms: rawSms ?? this.rawSms,
      isParsed: isParsed ?? this.isParsed,
    );
  }
}
