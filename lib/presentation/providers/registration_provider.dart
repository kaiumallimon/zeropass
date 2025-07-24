import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:zeropass/data/services/auth_service.dart';
import 'package:zeropass/data/services/email_verifier.dart';

class RegistrationProvider extends ChangeNotifier {
  /// TextEditingControllers for registration fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// auth service
  final AuthService _authService = AuthService();

  /// Loading state for registration process
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// form validation
  String validateForm() {
    if (nameController.text.isEmpty) {
      return "Name cannot be empty";
    }
    if (emailController.text.isEmpty) {
      return "Email cannot be empty";
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text)) {
      return "Please enter a valid email address";
    }
    if (passwordController.text.isEmpty || passwordController.text.length < 6) {
      return "Password must be at least 6 characters long";
    }
    return "";
  }

  /// register method to handle registration logic
  Future<void> register(BuildContext context) async {
    /// Check if the form is valid
    if (validateForm().isNotEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: "Validation Error",
        text: validateForm(),
      );
    } else {
      setLoading(true);
      try {
        // Simulate registration
        final String name = nameController.text.trim();
        final String email = emailController.text.trim();
        final String password = passwordController.text.trim();

        final response = await _authService.registerUser(
          name: name,
          email: email,
          password: password,
        );

        if (!response) {
          if (context.mounted) {
            setLoading(false);
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: "Registration Failed",
              text: "An error occurred while registering. Please try again.",
            );
          }
        } else {
          if (context.mounted) {
            setLoading(false);
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              title: "Registration Successful",
              text: "You have successfully registered. Please log in.",
              onConfirmBtnTap: () {
                nameController.clear();
                emailController.clear();
                passwordController.clear();

                setLoading(false);

                context.go('/login');
              },
            );
          }
        }
      } catch (error) {
        setLoading(false);
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Registration Failed",
          text: error.toString(),
        );
      } finally {
        setLoading(false);
      }
    }
  }
}
