import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/quickalert.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zeropass/data/local_db/local_db_service.dart';
import 'package:zeropass/data/local_db/secure_st_service.dart';
import 'package:zeropass/data/models/profile_model.dart';
import 'package:zeropass/data/services/auth_service.dart';
import 'package:zeropass/utils/encryptor_helper.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _service = AuthService();
  final storageService = SecureStorageService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Validate login form inputs
  String? _validateFields() {
    if (emailController.text.trim().isEmpty) {
      return "Email is required";
    }
    if (passwordController.text.trim().isEmpty) {
      return "Password is required";
    }
    return null;
  }

  /// Main login function
  Future<void> login(BuildContext context) async {
    // Remove focus from inputs
    FocusScope.of(context).unfocus();

    final validationMessage = _validateFields();

    if (validationMessage != null) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "Validation Error",
        text: validationMessage,
      );
      return;
    }

    setLoading(true);

    try {
      final loginModel = await _service.loginUser(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final profile = loginModel.userProfile;

      if (profile.isNotEmpty) {
        final encryptedName = profile['name'] ?? '';
        final encryptedEmail = profile['email'] ?? '';
        final salt = profile['salt'] ?? '';
        await storageService.saveSalt(salt);

        final base64Salt = EncryptionHelper.saltFromBase64(salt);
        final aesKey = EncryptionHelper.deriveAesKeyFromPassword(
          passwordController.text.trim(),
          base64Salt,
        );

        final decryptedName = EncryptionHelper.aesDecrypt(
          encryptedName,
          aesKey,
        );
        final decryptedEmail = EncryptionHelper.aesDecrypt(
          encryptedEmail,
          aesKey,
        );

        await LocalDatabaseService.saveProfile(
          ProfileModel(
            id: profile['id'],
            name: decryptedName,
            email: decryptedEmail,
          ),
        );
      }

      // Clear input fields after successful login
      emailController.clear();
      passwordController.clear();

      if (context.mounted) {
        context.go('/home');
      }
    } on AuthException catch (e) {
      if (context.mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Authentication Error",
          text: e.message,
        );
      }
    } catch (e) {
      if (context.mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Login Failed",
          text: e.toString(),
        );
      }
    } finally {
      setLoading(false);
    }
  }
}
