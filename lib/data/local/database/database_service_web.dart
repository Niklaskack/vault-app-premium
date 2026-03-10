import '../../../domain/models/transaction.dart' as model;
import '../../../domain/models/bank_connection.dart';
import 'database_service_interface.dart';

class DatabaseService implements DatabaseServiceInterface {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  final List<model.Transaction> _transactions = [];
  final List<BankConnection> _bankConnections = [];

  @override
  Future<void> insertTransaction(model.Transaction transaction) async {
    _transactions.removeWhere((t) => t.id == transaction.id);
    _transactions.add(transaction);
  }

  @override
  Future<List<model.Transaction>> getAllTransactions() async {
    return List.from(_transactions)..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<void> insertBankConnection(BankConnection connection) async {
    _bankConnections.removeWhere((c) => c.id == connection.id);
    _bankConnections.add(connection);
  }

  @override
  Future<List<BankConnection>> getBankConnections() async {
    return List.from(_bankConnections);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((t) => t.id == id);
  }

  @override
  Future<void> updateTransaction(model.Transaction transaction) async {
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      _transactions[index] = transaction;
    }
  }
}
