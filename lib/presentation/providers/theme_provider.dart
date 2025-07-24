// lib/presentation/providers/theme_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zeropass/core/theme/app_theme.dart';
import 'package:zeropass/data/local_db/local_db_service.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme =>
      _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

  ThemeProvider() {
    _loadTheme(); // Load on startup
  }

  void _loadTheme() async {
    _isDarkMode = await LocalDatabaseService.getDarkMode();
    notifyListeners();
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await LocalDatabaseService.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  void setDarkMode(bool value) async {
    _isDarkMode = value;
    await LocalDatabaseService.setDarkMode(value);
    notifyListeners();
  }

  SystemUiOverlayStyle getOverlayStyle(BuildContext context) {
    final theme = Theme.of(context);
    if (_isDarkMode) {
      return SystemUiOverlayStyle(
        statusBarColor: theme.colorScheme.surface,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: theme.colorScheme.surface,
        systemNavigationBarIconBrightness: Brightness.light,
      );
    } else {
      return SystemUiOverlayStyle(
        statusBarColor: theme.colorScheme.surface,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: theme.colorScheme.surface,
        systemNavigationBarIconBrightness: Brightness.dark,
      );
    }
  }
}
