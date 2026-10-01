// lib\services\plan_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/plan.dart';

class PlanService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String _tableName = 'plans';

  // Mendapatkan ID pengguna yang sedang login
  String? get currentUserId => _supabase.auth.currentUser?.id;

  Future<List<Plan>> fetchPlans() async {
    final userId = currentUserId;
    if (userId == null) {
      print("User is not logged in. Cannot fetch plans.");
      return [];
    }
    try {
      final response = await _supabase
          .from(_tableName)
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      // Mengubah List<Map<String, dynamic>> menjadi List<Plan>
      return (response as List).map((json) => Plan.fromJson(json)).toList();
    } catch (e, stacktrace) {
      print("Error fetching plans from Supabase: $e");
      print("Stacktrace: $stacktrace");
      rethrow;
    }
  }

  // <<< UBAH: Mengembalikan Plan untuk mendapatkan ID yang baru dibuat >>>
  Future<Plan> addPlan(
    String title,
    String description,
    String? category,
    String? difficultyLevel,
    DateTime? dueDate,
    int? priority,
  ) async {
    final userId = currentUserId;
    if (userId == null) {
      throw Exception("User is not logged in. Cannot add plan.");
    }
    try {
      // Supabase secara default akan mengembalikan baris yang di-insert jika 'select' ditambahkan
      final List response = await _supabase
          .from(_tableName)
          .insert({
            'user_id': userId,
            'title': title,
            'description': description,
            'category': category,
            'difficulty_level': difficultyLevel,
            'due_date': dueDate?.toIso8601String(),
            'priority': priority,
            'is_completed': false, // Nilai default saat membuat
          })
          .select() // <<< Meminta Supabase mengembalikan data yang baru di-insert >>>
          .limit(1);

      if (response.isEmpty) {
        throw Exception("Gagal mendapatkan data rencana yang baru ditambahkan.");
      }

      // Mengubah Map<String, dynamic> menjadi objek Plan
      return Plan.fromJson(response.first);

    } catch (e, stacktrace) {
      print("Error adding plan to Supabase: $e");
      print("Stacktrace: $stacktrace");
      rethrow;
    }
  }

  Future<void> updatePlan(
    int id,
    String title,
    String description,
    String? category,
    String? difficultyLevel,
    DateTime? dueDate,
    int? priority,
  ) async {
    final userId = currentUserId;
    if (userId == null) {
      throw Exception("User is not logged in. Cannot update plan.");
    }
    try {
      await _supabase.from(_tableName).update({
        'title': title,
        'description': description,
        'category': category,
        'difficulty_level': difficultyLevel,
        'due_date': dueDate?.toIso8601String(),
        'priority': priority,
        // Kolom 'is_completed' dan 'created_at' tidak diubah di sini
      }).eq('id', id).eq('user_id', userId);
    } catch (e, stacktrace) {
      print("Error updating plan in Supabase: $e");
      print("Stacktrace: $stacktrace");
      rethrow;
    }
  }

  // <<< BARU: Fungsi untuk menghapus rencana >>>
  Future<void> deletePlan(int id) async {
    final userId = currentUserId;
    if (userId == null) {
      throw Exception("User is not logged in. Cannot delete plan.");
    }
    try {
      await _supabase.from(_tableName).delete().eq('id', id).eq('user_id', userId);
    } catch (e, stacktrace) {
      print("Error deleting plan from Supabase: $e");
      print("Stacktrace: $stacktrace");
      rethrow;
    }
  }
}