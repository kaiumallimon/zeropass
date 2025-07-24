import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:otp/otp.dart';
import 'package:quickalert/quickalert.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
        otps[entry.name] = otp;
      } catch (_) {
        otps[entry.name] = "Error";
      }
    }
    return otps;
  }

  @override
  void dispose() {
    _mainTimer?.cancel();
    super.dispose();
  }

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

  Future<void> scanQrCode(BuildContext context, String data) async {
    setLoading(true);
    try {
      setScannedData(data);
      final extractedData = extractDataFromUrl(data);

      final name = extractedData['Name'];
      final secret = extractedData['Secret'];
      final digits = extractedData['Digits'] ?? 6;
      final issuer = extractedData['Issuer'];

      if ([name, secret, issuer].any((e) => e == null || e!.isEmpty) || digits <= 0) {
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

      final totpEntrySupabase = {
        'name': encryptedName,
        'secret': encryptedSecret,
        'digits': digits,
        'issuer': encryptedIssuer,
        'user_id': user.id,
      };

      final totpEntryLocal = {
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
}
