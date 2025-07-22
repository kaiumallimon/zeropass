import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/quickalert.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zeropass/data/local_db/local_db_service.dart';
import 'package:zeropass/data/models/profile_model.dart';
import 'package:zeropass/data/services/auth_service.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _service = AuthService();

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
        await LocalDatabaseService.saveProfile(
          ProfileModel(
            id: profile['id'],
            name: profile['name'] ?? '',
            email: profile['email'] ?? '',
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
