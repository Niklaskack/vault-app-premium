import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction.dart';
import '../../data/local/database_service.dart';

class TransactionRepository {
  final DatabaseService _dbService;

  TransactionRepository(this._dbService);

  Future<void> addTransaction(Transaction transaction) => _dbService.insertTransaction(transaction);
  Future<List<Transaction>> getTransactions() => _dbService.getAllTransactions();
  Future<void> removeTransaction(String id) => _dbService.deleteTransaction(id);
  Future<void> updateTransaction(Transaction transaction) => _dbService.updateTransaction(transaction);
}

final databaseServiceProvider = Provider((ref) => DatabaseService());

final transactionRepositoryProvider = Provider((ref) {
  final dbService = ref.watch(databaseServiceProvider);
  return TransactionRepository(dbService);
});

final transactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.getTransactions();
});
