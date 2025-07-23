import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zeropass/data/local_db/secure_st_service.dart';
import 'package:zeropass/data/services/database_service.dart';
import 'package:zeropass/presentation/providers/category_provider.dart';
import 'package:zeropass/utils/encryptor_helper.dart';

class AddPasswordProvider extends ChangeNotifier {
  final CategoryProvider _categoryProvider;
  AddPasswordProvider(this._categoryProvider);

  List<Map<String, dynamic>> get categories => _categoryProvider.categories;

  String? _selectedCategoryId;
  String? get selectedCategoryId => _selectedCategoryId;

  void setSelectedCategory(String? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  /// Optional: if you want to allow refreshing categories inside the AddPassword screen
  Future<void> loadCategories() async {
    await _categoryProvider.fetchCategories();
    notifyListeners();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController notesController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  String validate() {
    if (nameController.text.isEmpty) {
      return 'Name is required';
    }
    if (selectedCategoryId == null) {
      return 'Category is required';
    }
    if (passwordController.text.isEmpty) {
      return 'Password is required';
    }
    if (passwordController.text != confirmPasswordController.text) {
      return 'Passwords do not match';
    }
    return '';
  }

  final _service = DatabaseService();
  final _secureStorage = SecureStorageService();

  Future<void> savePassword(BuildContext context) async {
    if (validate().isNotEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: validate(),
      );
    } else {
      setLoading(true);

      try {
        final aesKeyString = await _secureStorage.getAesKey();
        final aesKey = EncryptionHelper.saltFromBase64(aesKeyString!);

        final encryptedName = EncryptionHelper.aesEncrypt(
          nameController.text,
          aesKey,
        );

        final encryptedUrl = urlController.text.isEmpty
            ? null
            : EncryptionHelper.aesEncrypt(urlController.text, aesKey);
        final encryptedUsername = EncryptionHelper.aesEncrypt(
          usernameController.text,
          aesKey,
        );

        final encryptedPassword = EncryptionHelper.aesEncrypt(
          passwordController.text,
          aesKey,
        );
        final encryptedNotes = notesController.text.isEmpty
            ? null
            : EncryptionHelper.aesEncrypt(notesController.text, aesKey);

        final userId = Supabase.instance.client.auth.currentUser!.id;

        final passwordData = {
          'user_id': userId,
          'category_id': _selectedCategoryId,
          'name': encryptedName,
          'url': encryptedUrl,
          'username': encryptedUsername,
          'password': encryptedPassword,
          'note': encryptedNotes,
        };

        await _service.insertData('passwords', passwordData);

        if (context.mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'Success',
            text: 'Password saved successfully!',
          );
        }
      } catch (error) {
        if (context.mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Error',
            text: 'Failed to save password: $error',
          );
        }
      } finally {
        setLoading(false);
        clearFields();
      }
    }
  }

  void clearFields() {
    nameController.clear();
    urlController.clear();
    usernameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    notesController.clear();
    _selectedCategoryId = null;
    notifyListeners();
  }
}
