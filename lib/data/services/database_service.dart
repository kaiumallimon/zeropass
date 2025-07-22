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

  Future<List<Map<String, dynamic>>> fetchData(
    String table, {
    bool ascending = true,
    String orderBy = 'created_at',
  }) async {
    try {
      final response = await supabase
          .from(table)
          .select()
          .order(orderBy, ascending: ascending);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      debugPrint('Error fetching data: $error');
      rethrow;
    }
  }
}
