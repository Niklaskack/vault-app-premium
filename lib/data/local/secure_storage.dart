import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();
  static const _dbKeyName = 'vault_db_encryption_key';

  Future<String> getDatabaseKey() async {
    String? key = await _storage.read(key: _dbKeyName);
    if (key == null) {
      key = const Uuid().v4(); // Generate a random key
      await _storage.write(key: _dbKeyName, value: key);
    }
    return key;
  }

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}
