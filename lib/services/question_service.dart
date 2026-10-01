import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/question.dart';

class QuestionService {
  final supabase = Supabase.instance.client;

  Future<List<Question>> fetchQuestions() async {
    final response = await supabase
        .from('learning_style_questions')
        .select()
        .order('id', ascending: true);

    return (response as List).map((q) => Question.fromMap(q)).toList();
  }
}
