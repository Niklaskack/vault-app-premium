import '../../../domain/models/transaction.dart' as model;
import '../../../domain/models/bank_connection.dart';

abstract class DatabaseServiceInterface {
  Future<void> insertTransaction(model.Transaction transaction);
  Future<List<model.Transaction>> getAllTransactions();
  Future<void> insertBankConnection(BankConnection connection);
  Future<List<BankConnection>> getBankConnections();
  Future<void> deleteTransaction(String id);
  Future<void> updateTransaction(model.Transaction transaction);
}
