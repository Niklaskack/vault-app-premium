// import 'package:flutter_fuse_connect/flutter_fuse_connect.dart';
import '../data/local/database_service.dart';
import '../domain/models/bank_connection.dart';
import '../domain/models/transaction.dart';
import 'package:uuid/uuid.dart';

class BankSyncService {
  final _dbService = DatabaseService();

  Future<void> connectBank(String clientSecret) async {
    // This would typically open the Fuse Connect SDK
    /*
    final result = await FuseConnect.open(
      configuration: FuseConfiguration(clientSecret: clientSecret),
    );
    
    if (result is FuseSuccess) {
      final connection = BankConnection(
        id: const Uuid().v4(),
        institutionName: result.institutionName,
        publicToken: result.publicToken,
        connectedAt: DateTime.now(),
      );
      await _dbService.insertBankConnection(connection);
      await syncTransactions(connection);
    }
    */
    
    // MOCK for demonstration
    final mockConnection = BankConnection(
      id: const Uuid().v4(),
      institutionName: 'Chase Bank',
      publicToken: 'mock_token_${const Uuid().v4()}',
      connectedAt: DateTime.now(),
    );
    await _dbService.insertBankConnection(mockConnection);
    await syncTransactions(mockConnection);
  }

  Future<void> syncTransactions(BankConnection connection) async {
    // In a real app, you'd call your backend or the Fuse API to fetch transactions
    // using the publicToken (or an exchangeable accessToken).
    
    // MOCK transactions
    final now = DateTime.now();
    final mockTxs = [
      Transaction(
        merchant: 'Amazon',
        amount: 89.99,
        date: now.subtract(const Duration(days: 1)),
        category: TransactionCategory.shopping,
      ),
      Transaction(
        merchant: 'Uber',
        amount: 15.50,
        date: now.subtract(const Duration(hours: 5)),
        category: TransactionCategory.transport,
      ),
    ];

    for (var tx in mockTxs) {
      await _dbService.insertTransaction(tx);
    }
  }

  Future<List<BankConnection>> getStoredConnections() async {
    return await _dbService.getBankConnections();
  }
}
