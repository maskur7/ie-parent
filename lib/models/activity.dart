class Activity {
  final String id;
  final String userId;
  final String title;
  final DateTime date;
  final String category; // Contoh: 'tracking', 'learning', 'education'
  final bool completed;  // Untuk checklist

  Activity({
    required this.id,
    required this.userId,
    required this.title,
    required this.date,
    required this.category,
    required this.completed,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      date: DateTime.tryParse(json['date'] as String) ?? DateTime.now(),
      category: json['category'] as String? ?? 'general',
      completed: json['completed'] == true,
    );
  }

  /// Getter tambahan untuk progress (0 → belum selesai, 100 → sudah selesai)
  int get progress => completed ? 100 : 0;

  /// Bisa juga custom berdasarkan kategori
  /// contoh: tracking = 50, learning = 70, education = 90, dll
  // int get progress {
  //   switch (category) {
  //     case 'tracking': return completed ? 100 : 50;
  //     case 'learning': return completed ? 100 : 70;
  //     case 'education': return completed ? 100 : 90;
  //     default: return completed ? 100 : 0;
  //   }
  // }

  // Untuk memberikan nilai dinamis, sementara ini return kategori sebagai type
  String get type => category;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'date': date.toIso8601String(),
      'category': category,
      'completed': completed,
    };
  }
}
