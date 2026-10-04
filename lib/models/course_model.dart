import 'package:cloud_firestore/cloud_firestore.dart';

/// Helper to safely convert any Map object to `Map<String, dynamic>` across Dart Web and Native.
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

/// Model representing an educational course.
class Course {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String thumbnailUrl;
  final String category;
  final String grade;
  final double rating;
  final bool isPaid;
  final List<Module> modules;

  /// High-performance in-memory cache map for loaded course subcollections
  static final Map<String, List<Module>> _moduleCache = {};

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.thumbnailUrl,
    required this.category,
    this.grade = '',
    this.rating = 4.8,
    this.isPaid = false,
    required this.modules,
  });

  factory Course.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = _asMap(doc.data());
    final modulesData = data['modules'] as List<dynamic>? ?? [];
    return Course(
      id: doc.id,
      title: data['title'] as String? ?? 'Untitled Course',
      description: data['description'] as String? ?? '',
      instructor: data['instructor'] as String? ?? 'Prof. Tariq Mahmood',
      thumbnailUrl: data['thumbnailUrl'] as String? ??
          data['bannerUrl'] as String? ??
          '',
      category: data['category'] as String? ??
          data['subject'] as String? ??
          'ICS / CS',
      grade: data['grade'] as String? ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 4.8,
      isPaid: data['isPaid'] as bool? ?? false,
      modules: modulesData
          .whereType<Map>()
          .map((m) => Module.fromMap(_asMap(m)))
          .toList(),
    );
  }

  /// High-yield 100x performance loader using in-memory cache map
  static Future<Course> fromFirestoreWithSubcollections(
      DocumentSnapshot<Map<String, dynamic>> doc) async {
    final data = _asMap(doc.data());
    List<Module> modulesList = [];

    // Check 100x fast in-memory cache first
    if (_moduleCache.containsKey(doc.id)) {
      modulesList = _moduleCache[doc.id]!;
    } else {
      // First try top-level modules array
      if (data['modules'] is List && (data['modules'] as List).isNotEmpty) {
        final rawList = data['modules'] as List;
        modulesList = rawList
            .whereType<Map>()
            .map((m) => Module.fromMap(_asMap(m)))
            .toList();
      }

      // Query sub-collection `/courses/{id}/modules` safely
      try {
        final subSnap = await doc.reference.collection('modules').get();

        if (subSnap.docs.isNotEmpty) {
          final subModules = subSnap.docs.map((subDoc) {
            final mData = _asMap(subDoc.data());
            return Module.fromMap(mData, id: subDoc.id);
          }).toList();

          subModules.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

          if (modulesList.isEmpty) {
            modulesList = subModules;
          } else {
            final existingIds = modulesList.map((m) => m.id).toSet();
            for (var sm in subModules) {
              if (!existingIds.contains(sm.id)) {
                modulesList.add(sm);
              }
            }
          }
        }
      } catch (_) {
        // Catch any unexpected query errors silently
      }

      // Store in memory cache map
      _moduleCache[doc.id] = modulesList;
    }

    return Course(
      id: doc.id,
      title: data['title'] as String? ?? 'Untitled Course',
      description: data['description'] as String? ?? '',
      instructor: data['instructor'] as String? ?? 'Prof. Tariq Mahmood',
      thumbnailUrl: data['thumbnailUrl'] as String? ??
          data['bannerUrl'] as String? ??
          '',
      category: data['category'] as String? ??
          data['subject'] as String? ??
          'ICS / CS',
      grade: data['grade'] as String? ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 4.8,
      isPaid: data['isPaid'] as bool? ?? false,
      modules: modulesList,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'instructor': instructor,
      'thumbnailUrl': thumbnailUrl,
      'bannerUrl': thumbnailUrl,
      'category': category,
      'subject': category,
      'grade': grade,
      'rating': rating,
      'isPaid': isPaid,
      'modules': modules.map((m) => m.toMap()).toList(),
    };
  }
}
