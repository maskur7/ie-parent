class Question {
  final String text;
  final String type;

  Question({required this.text, required this.type});

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      text: map['text'] ?? '',
      type: map['type'] ?? '',
    );
  }
}
