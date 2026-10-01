import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/activity.dart';

class ActivityService {
  final supabase = Supabase.instance.client;

  Future<List<Activity>> fetchActivities() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception("Pengguna tidak ditemukan. Silakan login terlebih dahulu.");
      }

      // Melakukan query untuk mengambil aktivitas berdasarkan user_id
      final response = await supabase
          .from('activities')
          .select('*')  // Mengambil semua kolom
          .eq('user_id', user.id)
          .order('date', ascending: false)  // Urutkan berdasarkan tanggal secara menurun
          .limit(10);  // Opsional, jika ingin membatasi jumlah data

      // Memeriksa apakah ada error dalam response
      if (response.error != null) {
        throw Exception("Gagal memuat aktivitas: ${response.error?.message}");
      }

      // Memastikan response.data adalah List, lalu mapping data menjadi List<Activity>
      if (response.data is List) {
        return (response.data as List)
            .map((item) => Activity.fromJson(item))
            .toList();
      } else {
        throw Exception("Data aktivitas tidak sesuai.");
      }
    } catch (e) {
      print('Error saat mengambil aktivitas: $e');
      return [];
    }
  }
}

extension on PostgrestList {
  get error => null;
  
  get data => null;
}
