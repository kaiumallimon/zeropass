import 'package:flutter/material.dart';
import 'package:zeropass/data/services/database_service.dart';

class CategoryProvider extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();

  final _service = DatabaseService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> get categories => _categories;
  void setCategories(List<Map<String, dynamic>> categories) {
    _categories = categories;
    notifyListeners();
  }

  String? errorMessage;
  void setErrorMessage(String? message) {
    errorMessage = message;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    setLoading(true);

    try {
      final response = await _service.fetchData('categories');
      setCategories(response);
      setLoading(false);
      setErrorMessage(null);
    } catch (error) {
      setErrorMessage('Failed to fetch categories. Please try again.');
      setLoading(false);
      return;
    }
  }
}
