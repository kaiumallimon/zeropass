import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class EmailVerifier {
  final String baseUrl = 'https://api.zerobounce.net/v2/validate';

  Future<bool> verifyEmail(String email) async {
    try {
      final apiKey = dotenv.env['ZEROBOUNCE_API_KEY'];
      
      
      
      
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception(
          'ZeroBounce API key not found in environment variables.',
        );
      }

      final requestUrl = "$baseUrl?api_key=$apiKey&email=$email";

      final response = await http.get(Uri.parse(requestUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Example: status could be 'valid', 'invalid', 'catch-all', 'unknown'
        final status = data['status'];
        if (status == 'valid') {
          return true;
        } else {
          return false;
        }
      } else {
        throw Exception('Failed to verify email: ${response.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }
}
