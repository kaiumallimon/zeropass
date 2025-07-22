import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final supabase = Supabase.instance.client;

  Future<void> insertData(String table, Map<String, dynamic> data) async {
    try {
      final response = await supabase.from(table).insert(data);
    } catch (error) {
      debugPrint('Error inserting data: $error');
      rethrow;
    }
  }
}
