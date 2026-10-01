// services/learning_style_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/learning_style_result.dart'; // Pastikan path ini benar

class LearningStyleService {
  final SupabaseClient _supabase = Supabase.instance.client; // Gunakan _ untuk konvensi private

  /// Menyimpan hasil gaya belajar pengguna ke database.
  /// Melempar [Exception] jika operasi gagal.
  Future<void> insertLearningStyle(String userId, String resultType, String description) async {
    try {
      await _supabase.from('learning_styles').insert({
        'user_id': userId,
        'result_type': resultType, // Sesuaikan dengan nama kolom di tabel Anda
        'description': description,
        'created_at': DateTime.now().toIso8601String(),
      });
      // Jika tidak ada exception yang dilempar, berarti berhasil.
      print('Gaya belajar berhasil disimpan untuk user ID: $userId');
    } on PostgrestException catch (e) {
      // Menangkap exception spesifik dari Postgrest (Supabase)
      print('Supabase error inserting learning style: ${e.message}');
      throw Exception('Gagal menyimpan hasil gaya belajar: ${e.message}');
    } catch (e) {
      // Menangkap exception umum lainnya (misal: masalah koneksi)
      print('Terjadi kesalahan tak terduga saat menyimpan gaya belajar: $e');
      throw Exception('Terjadi kesalahan saat menyimpan gaya belajar: $e');
    }
  }

  /// Mengambil hasil gaya belajar terbaru untuk pengguna tertentu.
  /// Mengembalikan [LearningStyleResult] jika ditemukan, atau `null` jika tidak ada atau terjadi kesalahan.
  Future<LearningStyleResult?> fetchLatestResult(String userId) async {
    try {
      final Map<String, dynamic>? data = await _supabase // Hapus <PostgrestList> di sini
          .from('learning_styles')
          .select() // Panggil select tanpa argumen tipe
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle(); // Mengembalikan Map<String, dynamic> atau null

      if (data == null) {
        return null; // Tidak ada hasil ditemukan
      }

      // data sudah dipastikan Map<String, dynamic> oleh `maybeSingle()` jika tidak null
      return LearningStyleResult.fromMap(data);

    } on PostgrestException catch (e) {
      print('Supabase error fetching latest result: ${e.message}');
      return null; // Mengembalikan null untuk penanganan di UI
    } catch (error) {
      print('Terjadi kesalahan tak terduga saat mengambil hasil gaya belajar terbaru: $error');
      return null;
    }
  }
}