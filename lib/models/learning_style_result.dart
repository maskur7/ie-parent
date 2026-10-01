class LearningStyleResult {
  final String result;
  final String description;
  final DateTime createdAt;

  LearningStyleResult({
    required this.result,
    required this.description,
    required this.createdAt,
  });

  factory LearningStyleResult.fromMap(Map<String, dynamic> map) {
    return LearningStyleResult(
      result: map['result_type'] as String? ?? '', // Lebih eksplisit dengan 'as String?'
      description: map['description'] as String? ?? '', // Lebih eksplisit dengan 'as String?'
      createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ?? DateTime.now(), // Penanganan null/invalid string yang lebih aman
    );
  }
}