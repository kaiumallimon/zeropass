import 'dart:math';

class PasswordUtils {
  static String generateStrongPassword({
    int length = 16,
    bool includeUppercase = true,
    bool includeLowercase = true,
    bool includeDigits = true,
    bool includeSpecialChars = true,
  }) {
    const uppercaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lowercaseLetters = 'abcdefghijklmnopqrstuvwxyz';
    const digits = '0123456789';
    const specialChars = '!@#\$%^&*()-_=+[]{}|;:,.<>?';

    String chars = '';
    if (includeUppercase) chars += uppercaseLetters;
    if (includeLowercase) chars += lowercaseLetters;
    if (includeDigits) chars += digits;
    if (includeSpecialChars) chars += specialChars;

    if (chars.isEmpty) {
      throw Exception('At least one character set must be included.');
    }

    final rand = Random.secure();
    final password = List.generate(
      length,
      (_) => chars[rand.nextInt(chars.length)],
    ).join();

    return password;
  }

  static String checkPasswordStrength(String password) {
    int score = 0;

    final length = password.length;
    final hasUpper = password.contains(RegExp(r'[A-Z]'));
    final hasLower = password.contains(RegExp(r'[a-z]'));
    final hasDigit = password.contains(RegExp(r'[0-9]'));
    final hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (length >= 8) score++;
    if (length >= 12) score++;
    if (hasUpper) score++;
    if (hasLower) score++;
    if (hasDigit) score++;
    if (hasSpecial) score++;

    if (score <= 2) return 'Very Weak';
    if (score == 3) return 'Weak';
    if (score == 4) return 'Medium';
    if (score == 5) return 'Strong';
    return 'Very Strong';
  }
}
