import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:otp/otp.dart';
import 'package:quickalert/quickalert.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:zeropass/data/local_db/secure_st_service.dart';
import 'package:zeropass/data/local_db/totp_secrets_service.dart';
import 'package:zeropass/data/models/totp_entry_model.dart';
import 'package:zeropass/utils/encryptor_helper.dart';

class TotpProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String? _scannedData;
  String? get scannedData => _scannedData;
  void setScannedData(String? value) {
    _scannedData = value;
    notifyListeners();
  }

  final _secureStorage = SecureStorageService();

  List<TotpEntry> _totpEntries = [];
  List<TotpEntry> get totpEntries => _totpEntries;
  void setTotpEntries(List<TotpEntry> entries) {
    _totpEntries = entries;
    notifyListeners();
  }

  Map<String, String> _currentOtps = {};
  Map<String, String> get currentOtps => _currentOtps;

  int _secondsRemaining = 30;
  int get secondsRemaining => _secondsRemaining;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Timer? _mainTimer;

  /// Start a single timer that updates both OTPs and countdown
  void startTotpTimer() {
    _updateTimeAndOtps(); // initial call
    _mainTimer?.cancel();
    _mainTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTimeAndOtps();
    });
  }

  /// Updates countdown and OTPs from current time
  void _updateTimeAndOtps() {
    final now = DateTime.now().toUtc();
    final remaining = 30 - (now.second % 30);

    // Update countdown only if it changed
    if (_secondsRemaining != remaining) {
      _secondsRemaining = remaining;
    }

    // When a new 30s cycle starts (e.g., remaining goes back to 30)
    if (remaining == 30) {
      _currentOtps = generateOtps();
    }

    notifyListeners();
  }

  /// Generates OTPs for all entries
  Map<String, String> generateOtps() {
    final now = DateTime.now().toUtc();
    Map<String, String> otps = {};
    for (final entry in _totpEntries) {
      try {
        final otp = OTP.generateTOTPCodeString(
          entry.secret,
          now.millisecondsSinceEpoch,
          interval: 30,
          length: entry.digits,
          algorithm: Algorithm.SHA1,
        );
        otps[entry.id] = otp;
      } catch (_) {
        otps[entry.id] = "Error";
      }
    }
    return otps;
  }

  @override
  void dispose() {
    _mainTimer?.cancel();
    super.dispose();
  }

  /// Loads TOTP entries from local storage and starts the timer
  /// This method fetches entries from the local storage service,
  /// updates the state, and starts the unified timer.
  /// /// If an error occurs, it sets an error message.
  /// It also generates the current OTPs for all entries.
  Future<void> loadTotpEntries(BuildContext context) async {
    setLoading(true);
    try {
      final entries = await TotpSecretStorageService().getEntries();
      setTotpEntries(entries);
      _currentOtps = generateOtps();
      startTotpTimer(); // start unified timer
    } catch (error) {
      setErrorMessage("Failed to load TOTP entries: $error");
    } finally {
      setLoading(false);
    }
  }

  /// Scans a QR code and extracts TOTP data
  /// This method expects the QR code to contain a URL in the format:
  /// otpauth://totp/Issuer:AccountName?secret=SECRET&digits
  /// digits=6&issuer=Issuer
  /// /// Returns a map with keys: Name, Secret, Digits, Issuer
  /// If the data is invalid, it shows an error alert.
  Future<void> scanQrCode(BuildContext context, String data) async {
    setLoading(true);
    try {
      setScannedData(data);
      final extractedData = extractDataFromUrl(data);

      final name = extractedData['Name'];
      final secret = extractedData['Secret'];
      final digits = extractedData['Digits'] ?? 6;
      final issuer = extractedData['Issuer'];

      if ([name, secret, issuer].any((e) => e == null || e!.isEmpty) ||
          digits <= 0) {
        if (context.mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Error",
            text: "Invalid TOTP data. Please check the scanned QR code.",
          );
        }
        return;
      }

      final aesString = await _secureStorage.getAesKey();
      if (aesString == null) {
        if (context.mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Error",
            text: "Encryption key not found.",
          );
        }
        return;
      }

      final aesBase64 = EncryptionHelper.saltFromBase64(aesString);

      final encryptedName = EncryptionHelper.aesEncrypt(name!, aesBase64);
      final encryptedSecret = EncryptionHelper.aesEncrypt(secret!, aesBase64);
      final encryptedIssuer = EncryptionHelper.aesEncrypt(issuer!, aesBase64);

      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        if (context.mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Error",
            text: "User not authenticated.",
          );
        }
        return;
      }
      // Prepare data for Supabase and local storage
      final id = Uuid().v4();
      print('Scanned ID: $id');
      final totpEntrySupabase = {
        'id': id,
        'name': encryptedName,
        'secret': encryptedSecret,
        'digits': digits,
        'issuer': encryptedIssuer,
        'user_id': user.id,
      };

      final totpEntryLocal = {
        'id': id,
        'name': name,
        'secret': secret,
        'digits': digits,
        'issuer': issuer,
      };

      await Supabase.instance.client
          .from('totp_entries')
          .insert(totpEntrySupabase);

      await TotpSecretStorageService().addEntry(
        TotpEntry.fromJson(totpEntryLocal),
      );

      await loadTotpEntries(context);
    } catch (error) {
      if (context.mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Error",
          text: error.toString(),
        );
      }
    } finally {
      setLoading(false);
    }
  }

  /// Extracts TOTP data from a URL
  /// This method assumes the URL is in the format:
  /// otpauth://totp/Issuer:AccountName?secret=SECRET&digits
  /// digits=6&issuer=Issuer
  /// /// Returns a map with keys: Name, Secret, Digits, Issuer
  ///

  Map<String, dynamic> extractDataFromUrl(String url) {
    final uri = Uri.parse(url);
    final queryParams = uri.queryParameters;

    return {
      "Name": uri.pathSegments.last,
      "Secret": queryParams['secret'],
      "Digits": int.tryParse(queryParams['digits'] ?? '6') ?? 6,
      "Issuer": queryParams['issuer'] ?? uri.host,
    };
  }

  /// Deletes a TOTP entry
  ///
  Future<void> deleteTotpEntry(TotpEntry entry) async {
    try {
      await TotpSecretStorageService().deleteEntryBySecret(entry.secret);
      _totpEntries.removeWhere((e) => e.secret == entry.secret);

      await Supabase.instance.client
          .from('totp_entries')
          .delete()
          .eq('id', entry.id)
          .select();

      notifyListeners();
    } catch (error) {
      setErrorMessage("Failed to delete TOTP entry: $error");
    }
  }

  final nameController = TextEditingController();
  final secretController = TextEditingController();
  final digitsController = TextEditingController();
  final issuerController = TextEditingController();

  Future<bool> manualEntry(BuildContext context) async {
    setLoading(true);
    try {
      final name = nameController.text.trim();
      final secret = secretController.text.trim();
      final issuer = issuerController.text.trim();
      final digits = int.tryParse(digitsController.text.trim()) ?? 6;

      if ([name, secret, issuer].any((e) => e.isEmpty) || digits <= 0) {
        if (context.mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Error",
            text: "Please fill out all fields correctly.",
          );
        }
        return false;
      }

      final aesString = await _secureStorage.getAesKey();
      if (aesString == null) {
        if (context.mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Error",
            text: "Encryption key not found.",
          );
        }
        return false;
      }

      final aesBase64 = EncryptionHelper.saltFromBase64(aesString);

      final encryptedName = EncryptionHelper.aesEncrypt(name, aesBase64);
      final encryptedSecret = EncryptionHelper.aesEncrypt(secret, aesBase64);
      final encryptedIssuer = EncryptionHelper.aesEncrypt(issuer, aesBase64);

      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        if (context.mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Error",
            text: "User not authenticated.",
          );
        }
        return false;
      }

      // Prepare data for Supabase and local storage
      final id = Uuid().v4();

      print('Manual ID: $id');

      final totpEntrySupabase = {
        'id': id,
        'name': encryptedName,
        'secret': encryptedSecret,
        'digits': digits,
        'issuer': encryptedIssuer,
        'user_id': user.id,
      };

      final totpEntryLocal = {
        'id': id,
        'name': name,
        'secret': secret,
        'digits': digits,
        'issuer': issuer,
      };

      await Supabase.instance.client
          .from('totp_entries')
          .insert(totpEntrySupabase);

      await TotpSecretStorageService().addEntry(
        TotpEntry.fromJson(totpEntryLocal),
      );

      nameController.clear();
      secretController.clear();
      digitsController.clear();
      issuerController.clear();

      await loadTotpEntries(context);
      return true;
    } catch (error) {
      if (context.mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Error",
          text: error.toString(),
        );
      }
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchFromSupabase() async {
    setLoading(true);
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        setErrorMessage("User not authenticated.");
        return;
      }

      final response =
          await Supabase.instance.client
                  .from('totp_entries')
                  .select()
                  .eq('user_id', user.id)
              as List;

      final aesString = await _secureStorage.getAesKey();
      if (aesString == null) {
        setErrorMessage("Encryption key not found.");
        return;
      }
      final aesBase64 = EncryptionHelper.saltFromBase64(aesString);

      final decryptedEntries = response.map((e) {
        final decrypted = {
          'id': e['id'],
          'name': EncryptionHelper.aesDecrypt(e['name'], aesBase64),
          'secret': EncryptionHelper.aesDecrypt(e['secret'], aesBase64),
          'digits': e['digits'],
          'issuer': EncryptionHelper.aesDecrypt(e['issuer'], aesBase64),
        };
        return TotpEntry.fromJson(decrypted);
      }).toList();

      await TotpSecretStorageService().saveEntries(decryptedEntries);

      setTotpEntries(decryptedEntries);
      _currentOtps = generateOtps();
    } catch (error) {
      setErrorMessage("Failed to fetch TOTP entries: $error");
    } finally {
      setLoading(false);
    }
  }
}
