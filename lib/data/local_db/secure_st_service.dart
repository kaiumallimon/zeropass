import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;
  final String _saltKey;

  SecureStorageService({String saltKey = 'salt'})
      : _storage = const FlutterSecureStorage(),
        _saltKey = saltKey;

  Future<void> saveSalt(String salt) async {
    try {
      await _storage.write(key: _saltKey, value: salt);
    } catch (e) {
      // Handle error or rethrow
      throw Exception('Failed to save salt: $e');
    }
  }

  Future<String?> getSalt() async {
    try {
      return await _storage.read(key: _saltKey);
    } catch (e) {
      throw Exception('Failed to read salt: $e');
    }
  }

  Future<void> deleteSalt() async {
    try {
      await _storage.delete(key: _saltKey);
    } catch (e) {
      throw Exception('Failed to delete salt: $e');
    }
  }
}
