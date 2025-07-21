import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashProvider extends ChangeNotifier {
  // navigate to the expected page
  void navigate(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        context.go('/welcome');
      }
    });
  }
}
