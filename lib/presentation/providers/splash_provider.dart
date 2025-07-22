import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zeropass/data/local_db/local_db_service.dart';

class SplashProvider extends ChangeNotifier {
  // navigate to the expected page
  Future<void> navigate(BuildContext context)async {
    bool isWelcomeShown = LocalDatabaseService.isWelcomeShown();

    if (isWelcomeShown) {
      // if welcome page is shown, navigate to login page
      context.go('/login');
    } else {
      // if welcome page is not shown, navigate to welcome page
      context.go('/welcome');
    }
  }
}
