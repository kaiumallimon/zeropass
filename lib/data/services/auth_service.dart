import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  /// Singleton instance of AuthService
  final supabase = Supabase.instance.client;

  /// Registers a new user with the given name, email, and password.
  /// If the registration is successful, it also inserts the user's name and email into the 'profiles' table.
  /// Returns true if the registration and profile insertion are successful, otherwise throws an exception.

  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        throw Exception('User registration failed');
      } else {
        final user = authResponse.user!;

        // insert name & email in profile table using the user id
        try {
          final profileResponse = await supabase.from('profiles').insert({
            'id': user.id,
            'name': name,
            'email': email,
          });

          debugPrint('Profile inserted: $profileResponse');

          return true;
        } catch (error) {
          throw Exception('Error inserting profile data: $error');
        }
      }
    } catch (error) {
      throw Exception('Error registering user: $error');
    }
  }

  /// resets the password for the user with the given email.
  Future<bool> forgotPassword({required String email}) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
      return true;
    } catch (error) {
      throw Exception('Error sending password reset email: $error');
    }
  }
}
