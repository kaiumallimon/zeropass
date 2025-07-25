import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zeropass/data/local_db/secure_st_service.dart';
import 'package:zeropass/data/models/password_model.dart';
import 'package:zeropass/presentation/providers/category_provider.dart';
import 'package:zeropass/utils/encryptor_helper.dart';

class HomeProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingPasswords = false;
  bool get isLoadingPasswords => _isLoadingPasswords;

  int _categoriesCount = 0;
  int get categoriesCount => _categoriesCount;

  int _passwordsCount = 0;
  int get passwordsCount => _passwordsCount;

  int _authenticatorsCount = 0;
  int get authenticatorsCount => _authenticatorsCount;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<PasswordModel> _passwords = [];
  List<PasswordModel> get passwords => _passwords;

  Future<void> init(BuildContext context) async {
    _setLoading(true);
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception("User not authenticated");

      final categoryProvider = context.read<CategoryProvider>();
      _categoriesCount = categoryProvider.categories.length;

      final passwordsRes = await _supabase
          .from('passwords')
          .select()
          .eq('user_id', userId);
      _passwordsCount = passwordsRes.length;

      final totpRes = await _supabase
          .from('totp_entries')
          .select()
          .eq('user_id', userId);
      _authenticatorsCount = totpRes.length;

      _errorMessage = null;

      await fetchPasswords();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchPasswords() async {
    _isLoadingPasswords = true;
    notifyListeners();
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        _errorMessage = "User not authenticated";
        return;
      }

      final response = await _supabase
          .from('passwords')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(5);

      final aesString = await SecureStorageService().getAesKey();
      final aesKey = EncryptionHelper.saltFromBase64(aesString!);

      _passwords = response.map<PasswordModel>((item) {
        item['name'] = EncryptionHelper.aesDecrypt(item['name'], aesKey);
        item['url'] = item['url'] == null
            ? 'N/A'
            : EncryptionHelper.aesDecrypt(item['url'], aesKey);
        item['username'] = EncryptionHelper.aesDecrypt(item['username'], aesKey);
        item['password'] = EncryptionHelper.aesDecrypt(item['password'], aesKey);
        item['note'] = item['note'] == null
            ? 'N/A'
            : EncryptionHelper.aesDecrypt(item['note'], aesKey);
        return PasswordModel.fromJson(item);
      }).toList();

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingPasswords = false;
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
