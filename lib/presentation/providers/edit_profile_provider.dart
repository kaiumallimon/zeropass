import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zeropass/data/local_db/local_db_service.dart';
import 'package:zeropass/data/models/profile_model.dart';
import 'package:zeropass/presentation/providers/profile_provider.dart';

class EditProfileProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final TextEditingController nameController = TextEditingController();

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void loadCurrentProfile() {
    final profile = LocalDatabaseService.getProfile();
    if (profile != null) {
      nameController.text = profile.name;
    }
  }

  void onNameChanged() {
    notifyListeners();
  }

  Future<void> updateProfile(BuildContext context) async {
    if (!_validateInput()) return;

    setLoading(true);
    setErrorMessage(null);

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        setErrorMessage('User not authenticated');
        return;
      }

      final newName = nameController.text.trim();

      // Update user metadata in Supabase
      await _supabase.auth.updateUser(UserAttributes(data: {'name': newName}));

      // Update local profile
      final currentProfile = LocalDatabaseService.getProfile();
      if (currentProfile != null) {
        final updatedProfile = ProfileModel(
          id: currentProfile.id,
          name: newName,
          email: currentProfile.email,
        );

        await LocalDatabaseService.saveProfile(updatedProfile);

        // Refresh the profile provider
        if (context.mounted) {
          context.read<ProfileProvider>().refreshProfile();
        }
      }

      if (context.mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Success',
          text: 'Profile updated successfully!',
          onConfirmBtnTap: () {
            context.pop(); // Close the alert
            context.pop(); // Go back to profile page
          },
        );
      }
    } on AuthException catch (e) {
      setErrorMessage(e.message);
      if (context.mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: e.message,
        );
      }
    } catch (e) {
      setErrorMessage('An unexpected error occurred. Please try again.');
      if (context.mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'An unexpected error occurred. Please try again.',
        );
      }
    } finally {
      setLoading(false);
    }
  }

  bool _validateInput() {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      setErrorMessage('Please enter your name');
      return false;
    }

    if (name.length < 2) {
      setErrorMessage('Name must be at least 2 characters long');
      return false;
    }

    if (name.length > 50) {
      setErrorMessage('Name must be less than 50 characters');
      return false;
    }

    // Check if name contains only letters, spaces, and common name characters
    if (!RegExp(r"^[a-zA-Z\s\-'.]+$").hasMatch(name)) {
      setErrorMessage(
        'Name can only contain letters, spaces, hyphens, and apostrophes',
      );
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
