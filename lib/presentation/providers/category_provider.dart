import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zeropass/data/local_db/secure_st_service.dart';
import 'package:zeropass/utils/encryptor_helper.dart';

class CategoryProvider extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();

  // final _service = DatabaseService();
  final supabase = Supabase.instance.client;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> get categories => _categories;
  void setCategories(List<Map<String, dynamic>> categories) {
    _categories = categories;
    notifyListeners();
  }

  String? errorMessage;
  void setErrorMessage(String? message) {
    errorMessage = message;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    setLoading(true);

    try {
      final userId = supabase.auth.currentUser!.id;
      final response = await supabase
          .from('categories')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: true);

      final aesString = await SecureStorageService().getAesKey();
      final aesKey = EncryptionHelper.saltFromBase64(aesString!);

      // decrypt category names:
      for (var category in response) {
        if (category['name'] != null) {
          category['name'] = EncryptionHelper.aesDecrypt(
            category['name'],
            aesKey,
          );
        }
      }
      setCategories(response);
      setLoading(false);
      setErrorMessage(null);
    } catch (error) {
      setErrorMessage('Failed to fetch categories. Please try again.');
      setLoading(false);
      return;
    }
  }
}
