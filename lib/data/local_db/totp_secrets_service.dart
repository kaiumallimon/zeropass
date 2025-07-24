import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:zeropass/data/models/totp_entry_model.dart';

class TotpSecretStorageService {
  static const String _boxName = 'totp_entries_json';

  Future<Box<String>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<String>(_boxName);
    }
    return Hive.box<String>(_boxName);
  }

  Future<List<TotpEntry>> getEntries() async {
    final box = await _getBox();
    return box.values
        .map((jsonString) => TotpEntry.fromJson(jsonDecode(jsonString)))
        .toList();
  }

  Future<void> addEntry(TotpEntry entry) async {
    final box = await _getBox();
    await box.add(jsonEncode(entry.toJson()));
  }

  Future<void> saveEntries(List<TotpEntry> entries) async {
    final box = await _getBox();
    await box.clear();
    final jsonList = entries.map((e) => jsonEncode(e.toJson()));
    await box.addAll(jsonList);
  }

  Future<void> deleteEntryBySecret(String secret) async {
    final box = await _getBox();
    final keyToDelete = box.keys.firstWhere(
      (key) {
        final entry = jsonDecode(box.get(key)!);
        return entry['secret'] == secret;
      },
      orElse: () => null,
    );
    if (keyToDelete != null) {
      await box.delete(keyToDelete);
    }
  }

  Future<void> deleteAllEntries() async {
    final box = await _getBox();
    await box.clear();
  }
}
