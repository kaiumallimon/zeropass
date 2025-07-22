import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/quickalert.dart';
import 'package:zeropass/data/services/auth_service.dart';

class ForgotpasswordProvider extends ChangeNotifier {
  /// Controller for the email input field.
  final TextEditingController emailController = TextEditingController();

  /// The AuthService instance to handle authentication-related operations.
  final AuthService _service = AuthService();

  /// Indicates whether the reset password operation is in progress.
  /// This is used to show a loading indicator while the operation is being performed.
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Validates the email input field.
  /// Returns true if the email is not empty, otherwise false.
  bool validate() {
    if (emailController.text.isEmpty) {
      return false;
    }
    return true;
  }

  /// Resets the password by sending a reset link to the user's email.
  /// Displays an error message if the email is empty or if the reset fails.
  Future<void> resetPassword(BuildContext context) async {
    if (!validate()) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Email cannot be empty. Please enter your email address.',
      );
    } else {
      setLoading(true);
      final String email = emailController.text.trim();
      try {
        final response = await _service.forgotPassword(email: email);

        if (!response) {
          if (context.mounted) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'Error',
              text: 'Failed to send reset password email. Please try again.',
            );
          }
        } else {
          if (context.mounted) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              title: 'Success',
              text: 'A reset password link has been sent to your email.',
              onConfirmBtnTap: () {
                emailController.clear();
                setLoading(false);
                context.go('/login');
              },
            );
          }
        }
      } catch (error) {
        if (context.mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Error',
            text:
                'An error occurred while resetting your password. Please try again later.',
          );
        }
      } finally {
        setLoading(false);
      }
    }
  }
}
