import 'package:cloud_firestore/cloud_firestore.dart';

/// Model representing an individual module or lecture chapter within a course.
class Module {
  final String id;
  final String title;
  final String description;
  final String youtubeVideoId;
  final String? pdfNotesUrl;
  final String duration;

  Module({
    required this.id,
    required this.title,
    this.description = '',
    required this.youtubeVideoId,
    this.pdfNotesUrl,
    this.duration = '',
  });

  factory Module.fromMap(Map<String, dynamic> map, {String? id}) {
    return Module(
      id: id ?? map['id'] as String? ?? '',
      title: map['title'] as String? ?? 'Untitled Module',
      description: map['description'] as String? ?? '',
      youtubeVideoId: map['youtubeVideoId'] as String? ?? map['videoId'] as String? ?? '',
      pdfNotesUrl: map['pdfNotesUrl'] as String? ?? map['notesUrl'] as String?,
      duration: map['duration'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'youtubeVideoId': youtubeVideoId,
      'pdfNotesUrl': pdfNotesUrl,
      'duration': duration,
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
  final double rating;
  final List<Module> modules;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.thumbnailUrl,
    required this.category,
    this.rating = 0.0,
    required this.modules,
  });

  factory Course.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final modulesData = data['modules'] as List<dynamic>? ?? [];
    return Course(
      id: doc.id,
      title: data['title'] as String? ?? 'Untitled Course',
      description: data['description'] as String? ?? '',
      instructor: data['instructor'] as String? ?? 'Unknown Instructor',
      thumbnailUrl: data['thumbnailUrl'] as String? ?? '',
      category: data['category'] as String? ?? 'General Education',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      modules: modulesData
          .whereType<Map<String, dynamic>>()
          .map((m) => Module.fromMap(m))
          .toList(),
    );
  }

  factory Course.fromMap(Map<String, dynamic> map, String id) {
    final modulesData = map['modules'] as List<dynamic>? ?? [];
    return Course(
      id: id,
      title: map['title'] as String? ?? 'Untitled Course',
      description: map['description'] as String? ?? '',
      instructor: map['instructor'] as String? ?? 'Unknown Instructor',
      thumbnailUrl: map['thumbnailUrl'] as String? ?? '',
      category: map['category'] as String? ?? 'General Education',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      modules: modulesData
          .whereType<Map<String, dynamic>>()
          .map((m) => Module.fromMap(m))
          .toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'instructor': instructor,
      'thumbnailUrl': thumbnailUrl,
      'category': category,
      'rating': rating,
      'modules': modules.map((m) => m.toMap()).toList(),
    };
  }
}
