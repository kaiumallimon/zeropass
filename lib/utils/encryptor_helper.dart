import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt_package;
import 'package:flutter/foundation.dart';
import 'package:pointycastle/export.dart';


// Private top-level isolate-safe function
Uint8List _pbkdf2Worker(Map<String, dynamic> args) {
  final password = args['password'] as String;
  final salt = base64.decode(args['salt'] as String);
  final iterations = args['iterations'] as int;
  final keyLength = args['keyLength'] as int;

  final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
    ..init(Pbkdf2Parameters(salt, iterations, keyLength));
  return pbkdf2.process(Uint8List.fromList(utf8.encode(password)));
}


class EncryptionHelper {
  /// Generate a random 16-byte salt and return it as base64 string
  static String generateSalt() {
    final secureRandom = SecureRandom('Fortuna')
      ..seed(
        KeyParameter(
          Uint8List.fromList(
            List.generate(
              32,
              (_) => DateTime.now().millisecondsSinceEpoch.remainder(256),
            ),
          ),
        ),
      );
    final saltBytes = secureRandom.nextBytes(16);
    return base64.encode(saltBytes);
  }

  /// Convert base64 salt string to Uint8List
  static Uint8List saltFromBase64(String base64Salt) {
    return base64.decode(base64Salt);
  }

  /// Convert Uint8List salt to base64 string
  static String saltToBase64(Uint8List salt) {
    return base64.encode(salt);
  }

  /// Derive a 256-bit AES key from password and salt (Uint8List)
static Future<Uint8List> deriveAesKeyFromPassword(
  String password,
  Uint8List salt, {
  int iterations = 100000,
  int keyLength = 32,
}) {
  return compute(_pbkdf2Worker, {
    'password': password,
    'salt': base64.encode(salt),
    'iterations': iterations,
    'keyLength': keyLength,
  });
}



  /// Encrypt plaintext with AES key, returns base64 string of IV + ciphertext
  static String aesEncrypt(String plainText, Uint8List aesKey) {
    final key = encrypt_package.Key(aesKey);
    final iv = encrypt_package.IV.fromSecureRandom(16);

    final encrypter = encrypt_package.Encrypter(
      encrypt_package.AES(key, mode: encrypt_package.AESMode.cbc),
    );

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    final combined = iv.bytes + encrypted.bytes;

    return base64.encode(combined);
  }

  /// Decrypt base64 encoded ciphertext using AES key
  static String aesDecrypt(String base64CipherText, Uint8List aesKey) {
    final combined = base64.decode(base64CipherText);

    final iv = encrypt_package.IV(Uint8List.fromList(combined.sublist(0, 16)));
    final cipherText = combined.sublist(16);

    final key = encrypt_package.Key(aesKey);

    final encrypter = encrypt_package.Encrypter(
      encrypt_package.AES(key, mode: encrypt_package.AESMode.cbc),
    );

    final decrypted = encrypter.decrypt(
      encrypt_package.Encrypted(Uint8List.fromList(cipherText)),
      iv: iv,
    );

    return decrypted;
  }
}
