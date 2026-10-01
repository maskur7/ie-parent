// lib\models\plan.dart

class Plan {
  final int id;
  final String title;
  final String description;
  final String? category; 
  final String? difficultyLevel; 
  final DateTime? dueDate; 
  final int? priority; 
  final DateTime createdAt;
  final String? userId; 
  final bool isCompleted; // <<< PROPERTI HILANG DITAMBAHKAN

  Plan({
    required this.id,
    required this.title,
    required this.description,
    this.category,
    this.difficultyLevel,
    this.dueDate,
    this.priority,
    required this.createdAt,
    this.userId, 
    this.isCompleted = false, // <<< DEFAULT KE FALSE
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String?, 
      difficultyLevel: json['difficulty_level'] as String?, 
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : null,
      priority: json['priority'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String), 
      userId: json['user_id'] as String?,
      isCompleted: json['is_completed'] as bool? ?? false, // <<< BACA DARI JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'difficulty_level': difficultyLevel,
      'due_date': dueDate?.toIso8601String(),
      'priority': priority,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
      'is_completed': isCompleted, // <<< SERTAKAN DALAM JSON
    };
  }
}