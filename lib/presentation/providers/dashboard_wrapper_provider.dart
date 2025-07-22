import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardWrapperProvider extends ChangeNotifier {
  // List of tabs (matching your GoRouter paths)
  final List<String> tabs = [
    '/home',
    '/categories',
    '/add-password',
    '/generator',
    '/profile',
  ];

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  /// Update index and navigate to corresponding tab route
  void setTab(BuildContext context, int index) {
    if (index == _selectedIndex) return; // Avoid unnecessary navigation

    _selectedIndex = index;
    notifyListeners();

    // Navigate to the corresponding route
    context.go(tabs[index]);
  }

  /// Sync index with current route (e.g. on app start or route change)
  void syncWithLocation(String location) {
    final index = tabs.indexWhere((tab) => location.startsWith(tab));
    if (index != -1 && index != _selectedIndex) {
      _selectedIndex = index;
      notifyListeners();
    }
  }
}
