import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/quickalert.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChangePasswordProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isCurrentPasswordVisible = false;
  bool get isCurrentPasswordVisible => _isCurrentPasswordVisible;

  bool _isNewPasswordVisible = false;
  bool get isNewPasswordVisible => _isNewPasswordVisible;

  bool _isConfirmPasswordVisible = false;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void toggleCurrentPasswordVisibility() {
    _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
    notifyListeners();
  }

  void toggleNewPasswordVisibility() {
    _isNewPasswordVisible = !_isNewPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> changePassword(BuildContext context) async {
    if (!_validateInputs(context)) return;

    setLoading(true);
    setErrorMessage(null);

    try {
      // Update password in Supabase
      await _supabase.auth.updateUser(
        UserAttributes(password: newPasswordController.text.trim()),
      );

      if (context.mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Success',
          text: 'Password changed successfully!',
          onConfirmBtnTap: () {
            _clearControllers();
            context.pop(); // Close the alert
            context.pop(); // Go back to profile page
          },
        );
      }
    } on AuthException catch (e) {
      setErrorMessage(e.message);
      if (context.mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: e.message,
        );
      }
    } catch (e) {
      setErrorMessage('An unexpected error occurred. Please try again.');
      if (context.mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'An unexpected error occurred. Please try again.',
        );
      }
    } finally {
      setLoading(false);
    }
  }

  bool _validateInputs(BuildContext context) {
    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (currentPassword.isEmpty) {
      setErrorMessage('Please enter your current password');
      return false;
    }

    if (newPassword.isEmpty) {
      setErrorMessage('Please enter a new password');
      return false;
    }

    if (newPassword.length <= 6) {
      setErrorMessage('New password must be more than 6 characters long');
      return false;
    }

    if (newPassword != confirmPassword) {
      setErrorMessage('New passwords do not match');
      return false;
    }

    if (currentPassword == newPassword) {
      setErrorMessage('New password must be different from current password');
      return false;
    }

    return true;
  }

  void _clearControllers() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
