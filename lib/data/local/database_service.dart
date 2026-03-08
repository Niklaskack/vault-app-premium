import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'secure_storage.dart';
import '../../domain/models/transaction.dart' as model;
import '../../domain/models/bank_connection.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;
  final _secureStorage = SecureStorageService();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final password = await _secureStorage.getDatabaseKey();
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'vault_secure.db');

    return await openDatabase(
      path,
      password: password,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions (
            id TEXT PRIMARY KEY,
            merchant TEXT,
            amount REAL,
            date TEXT,
            category INTEGER,
            type INTEGER,
            note TEXT,
            rawSms TEXT,
            isParsed INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE bank_connections (
            id TEXT PRIMARY KEY,
            institutionName TEXT,
            publicToken TEXT,
            connectedAt TEXT
          )
        ''');
      },
    );
  }

  // Transaction CRUD
  Future<void> insertTransaction(model.Transaction transaction) async {
    final db = await database;
    await db.insert(
      'transactions',
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<model.Transaction>> getAllTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transactions', orderBy: 'date DESC');
    return List.generate(maps.length, (i) => model.Transaction.fromMap(maps[i]));
  }

  // Bank Connection CRUD
  Future<void> insertBankConnection(BankConnection connection) async {
    final db = await database;
    await db.insert(
      'bank_connections',
      connection.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<BankConnection>> getBankConnections() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('bank_connections');
    return List.generate(maps.length, (i) => BankConnection.fromMap(maps[i]));
  }

  Future<void> deleteTransaction(String id) async {
    final db = await database;
    await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateTransaction(model.Transaction transaction) async {
    final db = await database;
    await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }
}
