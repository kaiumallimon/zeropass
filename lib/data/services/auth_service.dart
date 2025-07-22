import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

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

          return true;
        } catch (error) {
          throw Exception('Error inserting profile data: $error');
        }
      }
    } catch (error) {
      throw Exception('Error registering user: $error');
    }
  }
}
