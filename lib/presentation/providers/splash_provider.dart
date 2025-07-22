import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zeropass/data/local_db/local_db_service.dart';

class SplashProvider extends ChangeNotifier {
  // navigate to the expected page
  Future<void> navigate(BuildContext context) async {
    bool isWelcomeShown = LocalDatabaseService.isWelcomeShown();
    bool isLoggedIn = LocalDatabaseService.isLoggedIn();

    if (isLoggedIn) {
      if (context.mounted) {
        context.go('/home');
      }
    } else {
      if (isWelcomeShown) {
        context.go('/login');
      } else {
        context.go('/welcome');
      }
    }
  }
}
