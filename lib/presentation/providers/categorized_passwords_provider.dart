import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zeropass/data/local_db/secure_st_service.dart';
import 'package:zeropass/utils/encryptor_helper.dart';

class CategorizedPasswordsProvider extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? errorMessage;

  final supabase = Supabase.instance.client;
  final _secureStorage = SecureStorageService();

  List<Map<String, dynamic>> _allPasswords = [];
  List<Map<String, dynamic>> _categorizedPasswords = [];
  List<Map<String, dynamic>> get categorizedPasswords => _categorizedPasswords;

  CategorizedPasswordsProvider() {
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterPasswords();
  }

  void _filterPasswords() {
    final searchQuery = searchController.text.toLowerCase().trim();

    if (searchQuery.isEmpty) {
      _categorizedPasswords = List.from(_allPasswords);
    } else {
      _categorizedPasswords = _allPasswords.where((password) {
        final name = password['name']?.toString().toLowerCase() ?? '';
        final username = password['username']?.toString().toLowerCase() ?? '';
        final url = password['url']?.toString().toLowerCase() ?? '';
        final note = password['note']?.toString().toLowerCase() ?? '';

        return name.contains(searchQuery) ||
            username.contains(searchQuery) ||
            url.contains(searchQuery) ||
            note.contains(searchQuery);
      }).toList();
    }

    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setCategorizedPasswords(List<Map<String, dynamic>> passwords) {
    _allPasswords = passwords;
    _filterPasswords();
  }

  Future<void> fetchPasswords(String categoryId) async {
    _allPasswords.clear();
    _categorizedPasswords.clear();
    _setLoading(true);
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception("User not authenticated");
      }

      final response = await supabase
          .from('passwords')
          .select()
          .eq('user_id', user.id)
          .eq('category_id', categoryId);

      final data = response.cast<Map<String, dynamic>>();

      // decrypt all the data:
      final aesKeyString = await _secureStorage.getAesKey();
      final aesKey = EncryptionHelper.saltFromBase64(aesKeyString!);

      /*
      final passwordData = {
                'user_id': userId,
                'category_id': _selectedCategoryId,
                'name': encryptedName,
                'url': encryptedUrl,
                'username': encryptedUsername,
                'password': encryptedPassword,
                'note': encryptedNotes,
              };

      */
      for (var item in data) {
        item['name'] = EncryptionHelper.aesDecrypt(item['name'], aesKey);
        if (item['url'] != null) {
          item['url'] = EncryptionHelper.aesDecrypt(item['url'], aesKey);
        }
        item['username'] = EncryptionHelper.aesDecrypt(
          item['username'],
          aesKey,
        );
        item['password'] = EncryptionHelper.aesDecrypt(
          item['password'],
          aesKey,
        );
        if (item['note'] != null) {
          item['note'] = EncryptionHelper.aesDecrypt(item['note'], aesKey);
        }
      }

      _setCategorizedPasswords(data);
      errorMessage = null;
      print('Fetched ${data.length} passwords for category $categoryId');
    } catch (error) {
      errorMessage = error.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> copyPassword(BuildContext context, int index) async {
    final password = categorizedPasswords[index]['password'];

    await Clipboard.setData(ClipboardData(text: password));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsetsGeometry.all(10),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Text('Password copied to clipboard'),
      ),
    );
  }

  Future<void> deletePassword(String id) async {
    _setLoading(true);
    try {
      _allPasswords.removeWhere((item) => item['id'] == id);
      _filterPasswords();

      await supabase.from('passwords').delete().eq('id', id);
    } catch (error) {
      errorMessage = error.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  void clear() {
    _allPasswords.clear();
    _categorizedPasswords.clear();
    searchController.clear();
    errorMessage = null;
    notifyListeners();
  }
}
