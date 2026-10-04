import 'quiz_question_model.dart';

Map<String, dynamic> _asMap(dynamic item) {
  if (item is Map) {
    return item.map((k, v) => MapEntry(k.toString(), v));
  }
  return <String, dynamic>{};
}

/// Model representing an individual module or lecture chapter within a course.
class Module {
  final String id;
  final String title;
  final String description;
  final String author;
  final String youtubeVideoId;
  final String? pdfNotesUrl;
  final String duration;
  final int orderIndex;
  final List<QuizQuestion> quizQuestions;

  Module({
    required this.id,
    required this.title,
    this.description = '',
    this.author = 'Rashid Talani, Lecturer Computer Science',
    required this.youtubeVideoId,
    this.pdfNotesUrl,
    this.duration = '',
    this.orderIndex = 0,
    this.quizQuestions = const [],
  });

  factory Module.fromMap(Map<String, dynamic> rawMap, {String? id}) {
    final map = _asMap(rawMap);
    final quizData = map['quizQuestions'] as List<dynamic>? ?? map['quiz'] as List<dynamic>? ?? [];
    return Module(
      id: id ?? map['id'] as String? ?? '',
      title: map['title'] as String? ?? 'Untitled Module',
      description: map['description'] as String? ?? '',
      author: map['author'] as String? ?? 'Rashid Talani, Lecturer Computer Science',
      youtubeVideoId: map['youtubeVideoId'] as String? ??
          map['videoId'] as String? ??
          'dQw4w9WgXcQ',
      pdfNotesUrl: map['pdfNotesUrl'] as String? ??
          map['notesPdfUrl'] as String? ??
          map['notesUrl'] as String?,
      duration: map['duration'] as String? ?? '',
      orderIndex: (map['orderIndex'] as num?)?.toInt() ?? 0,
      quizQuestions: quizData
          .whereType<Map>()
          .map((q) => QuizQuestion.fromMap(_asMap(q)))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'author': author,
      'youtubeVideoId': youtubeVideoId,
      'pdfNotesUrl': pdfNotesUrl,
      'notesPdfUrl': pdfNotesUrl,
      'duration': duration,
      'orderIndex': orderIndex,
      'quizQuestions': quizQuestions.map((q) => q.toMap()).toList(),
    };
  }
}
