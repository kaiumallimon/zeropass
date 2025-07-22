import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

  String validate() {
    if (emailController.text.isEmpty) {
      return "Email is required";
    }
    if (passwordController.text.isEmpty) {
      return "Password is required";
    }
    return "";
  }

  Future<void> login(BuildContext context) async {
    if (validate().isNotEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "Validation Error",
        text: validate(),
      );
    } else {
      setLoading(true);

      try {
        final user = await _service.loginUser(
          email: emailController.text,
          password: passwordController.text,
        );

        await Supabase.instance.client.auth.signOut();
      } catch (error) {
        if (context.mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Login Error",
            text: error.toString(),
          );
        }
      } finally {
        setLoading(false);
      }
    }
  }
}
