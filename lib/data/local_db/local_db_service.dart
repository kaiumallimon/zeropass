import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../models/profile_model.dart';

class LocalDatabaseService {
  static const String _profileBox = 'profile';
  static const String _profileKey = 'current';
  static const String _welcomeBox = 'welcome';
  static const String _welcomeKey = 'shown';
  static const String _themeBox = 'theme';
  static const String _themeKey = 'isDark';

  static bool _isInitialized = false;

  static Future<void> init() async {
    if (_isInitialized) return;

    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ProfileModelAdapter());
    }

    await Hive.openBox<ProfileModel>(_profileBox);
    await Hive.openBox(_welcomeBox);

    _isInitialized = true;
  }

  // Save or replace the single profile
  static Future<void> saveProfile(ProfileModel profile) async {
    final box = Hive.box<ProfileModel>(_profileBox);
    await box.put(_profileKey, profile);
  }

  // Get the single profile
  static ProfileModel? getProfile() {
    final box = Hive.box<ProfileModel>(_profileBox);
    return box.get(_profileKey);
  }

  // Delete the profile
  static Future<void> deleteProfile() async {
    final box = Hive.box<ProfileModel>(_profileBox);
    await box.delete(_profileKey);
  }

  // Clear the box (removes the profile)
  static Future<void> clearProfile() async {
    await Hive.box<ProfileModel>(_profileBox).clear();
  }

  // Welcome page viewer methods
  static Future<void> setWelcomeShown(bool shown) async {
    final box = Hive.box(_welcomeBox);
    await box.put(_welcomeKey, shown);
  }

  static bool isWelcomeShown() {
    final box = Hive.box(_welcomeBox);
    return box.get(_welcomeKey, defaultValue: false) as bool;
  }

  // Check if a profile is logged in
  static bool isLoggedIn() {
    final box = Hive.box<ProfileModel>(_profileBox);
    return box.get(_profileKey) != null;
  }

  static Future<void> setDarkMode(bool isDark) async {
    final box = await Hive.openBox(_themeBox);
    await box.put(_themeKey, isDark);
  }

  static Future<bool> getDarkMode() async {
    final box = await Hive.openBox(_themeBox);
    return box.get(_themeKey, defaultValue: false);
  }

  // Logout: clear all except welcome
  static Future<void> logout() async {
    await Hive.box<ProfileModel>(_profileBox).clear();
    // Add other boxes to clear here if needed in the future
    // Do NOT clear the welcome box
  }

  // Close all boxes
  static Future<void> close() async {
    await Hive.close();
  }
}
