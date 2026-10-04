Map<String, dynamic> _asMap(dynamic item) {
  if (item is Map) {
    return item.map((k, v) => MapEntry(k.toString(), v));
  }
  return <String, dynamic>{};
}

/// Model representing a topic MCQ question for self-assessment.
class QuizQuestion {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;

  QuizQuestion({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    this.explanation = '',
  });

  factory QuizQuestion.fromMap(Map<String, dynamic> rawMap, {String? id}) {
    final map = _asMap(rawMap);
    final opts = map['options'] as List<dynamic>? ?? [];
    return QuizQuestion(
      id: id ?? map['id'] as String? ?? '',
      questionText: map['questionText'] as String? ?? map['question'] as String? ?? '',
      options: opts.map((e) => e.toString()).toList(),
      correctOptionIndex: (map['correctOptionIndex'] as num?)?.toInt() ?? 0,
      explanation: map['explanation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'questionText': questionText,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'explanation': explanation,
    };
  }
}
