import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zeropass/data/local_db/secure_st_service.dart';
import 'package:zeropass/utils/encryptor_helper.dart';

class DetailedPasswordProvider extends ChangeNotifier {
  final nameController = TextEditingController();
  final urlController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final noteController = TextEditingController();

  final _secureStorage = SecureStorageService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isEditable = false;
  bool get isEditable => _isEditable;

  Map<String, dynamic> _originalData = {};

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void makeEditable(bool value) {
    _isEditable = value;
    notifyListeners();
  }

  /// Call this when navigating to the details page.
  void setInitialData(Map<String, dynamic> decryptedData) {
    _originalData = decryptedData;

    nameController.text = decryptedData['name'] ?? '';
    urlController.text = decryptedData['url'] ?? '';
    usernameController.text = decryptedData['username'] ?? '';
    passwordController.text = decryptedData['password'] ?? '';
    noteController.text = decryptedData['note'] ?? '';
  }

  Future<void> updatePassword(String passwordId) async {
    setLoading(true);

    try {
      final aesKeyString = await _secureStorage.getAesKey();
      final aesKey = EncryptionHelper.saltFromBase64(aesKeyString!);

      final updates = <String, dynamic>{};

      if (nameController.text.trim() != _originalData['name']) {
        updates['name'] = EncryptionHelper.aesEncrypt(
          nameController.text.trim(),
          aesKey,
        );
      }

      if (urlController.text.trim() != (_originalData['url'] ?? '')) {
        updates['url'] = urlController.text.trim().isEmpty
            ? null
            : EncryptionHelper.aesEncrypt(urlController.text.trim(), aesKey);
      }

      if (usernameController.text.trim() != _originalData['username']) {
        updates['username'] = EncryptionHelper.aesEncrypt(
          usernameController.text.trim(),
          aesKey,
        );
      }

      if (passwordController.text.trim() != _originalData['password']) {
        updates['password'] = EncryptionHelper.aesEncrypt(
          passwordController.text.trim(),
          aesKey,
        );
      }

      if (noteController.text.trim() != (_originalData['note'] ?? '')) {
        updates['note'] = noteController.text.trim().isEmpty
            ? null
            : EncryptionHelper.aesEncrypt(noteController.text.trim(), aesKey);
      }

      if (updates.isNotEmpty) {
        await Supabase.instance.client
            .from('passwords')
            .update(updates)
            .eq('id', passwordId);
      }
    } catch (e) {
      debugPrint('Update password failed: $e');
    } finally {
      setLoading(false);
      clear();
    }
  }

  void clear() {
    nameController.clear();
    urlController.clear();
    usernameController.clear();
    passwordController.clear();
    noteController.clear();

    _originalData = {};
    _isEditable = false;
    _isLoading = false;
    notifyListeners();
  }
}
