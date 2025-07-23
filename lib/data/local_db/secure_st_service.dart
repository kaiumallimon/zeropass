import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;
  final String _aesKeyStorageKey;

  SecureStorageService({String aesKeyStorageKey = 'aes_key'})
    : _storage = const FlutterSecureStorage(),
      _aesKeyStorageKey = aesKeyStorageKey;

  Future<void> saveAesKey(String aesKeyBase64) async {
    await _storage.write(key: _aesKeyStorageKey, value: aesKeyBase64);
  }

  Future<String?> getAesKey() async {
    return await _storage.read(key: _aesKeyStorageKey);
  }

  Future<void> deleteAesKey() async {
    await _storage.delete(key: _aesKeyStorageKey);
  }
}
