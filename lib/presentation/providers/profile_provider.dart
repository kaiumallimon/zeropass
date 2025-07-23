import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zeropass/data/local_db/local_db_service.dart';
import 'package:zeropass/data/local_db/secure_st_service.dart';
import 'package:zeropass/data/models/profile_model.dart';
import 'package:zeropass/presentation/providers/dashboard_wrapper_provider.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileModel? _profile;

  ProfileModel? get profile => _profile;

  ProfileProvider() {
    loadProfile();
  }

  void loadProfile() {
    _profile = LocalDatabaseService.getProfile();
    notifyListeners();
  }

  Future<void> refreshProfile() async {
    loadProfile();
  }

  void logout(BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'Logout',
      text: 'Are you sure you want to logout?',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      onConfirmBtnTap: () async {
        await LocalDatabaseService.clearProfile();
        Supabase.instance.client.auth.signOut();
        await SecureStorageService().deleteAesKey();
        context.read<DashboardWrapperProvider>().setTab(context, 0);
        _profile = null;
        notifyListeners();
        if (context.mounted) {
          context.go('/login');
        }
      },
    );
  }
}
