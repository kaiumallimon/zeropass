import 'package:supabase_flutter/supabase_flutter.dart';

class LoginModel {
  final User user;
  final Session session;
  final Map<String, dynamic> userProfile;

  LoginModel({
    required this.user,
    required this.session,
    required this.userProfile,
  });

  factory LoginModel.fromSupabaseResponse(
    User user,
    Session session,
    Map<String, dynamic> userProfile,
  ) {
    return LoginModel(user: user, session: session, userProfile: userProfile);
  }
}
