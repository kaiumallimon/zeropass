import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:zeropass/data/services/database_service.dart';

class AddCategoryProvider extends ChangeNotifier {
  final TextEditingController categoryNameController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final _service = DatabaseService();

  String validate() {
    if (categoryNameController.text.isEmpty) {
      return 'Category name cannot be empty';
    }
    if (categoryNameController.text.length < 3 ||
        categoryNameController.text.length > 15) {
      return 'Category name must be within 3 to 15 characters';
    }
    return '';
  }

  Future<void> addCategory(BuildContext context) async {
    if (validate().isNotEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: validate(),
      );
    } else {
      setLoading(true);

      try {
        final category = categoryNameController.text.trim();
        await _service.insertData('categories', {'category': category});
        setLoading(false);
        categoryNameController.clear();
        if (context.mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'Success',
            text: 'Category added successfully!',
          );
        }
      } catch (error) {
        setLoading(false);
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Failed to add category. Please try again.',
        );
        return;
      }
    }
  }
}
