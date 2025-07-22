import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:zeropass/data/services/email_verifier.dart';

class RegistrationProvider extends ChangeNotifier {
  /// TextEditingControllers for registration fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
      if (!await EmailVerifier().verifyEmail(emailController.text)) {
        if (context.mounted) {
          setLoading(false);
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Invalid Email",
            text: "Invalid email address. Please enter a valid email.",
          );
        }
      } else {}
    }
  }
}
