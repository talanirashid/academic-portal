import 'package:cloud_firestore/cloud_firestore.dart';

/// Model representing an individual module or lecture chapter within a course.
class Module {
  final String id;
  final String title;
  final String description;
  final String youtubeVideoId;
  final String? pdfNotesUrl;
  final String duration;
  final int orderIndex;

  Module({
    required this.id,
    required this.title,
    this.description = '',
    required this.youtubeVideoId,
    this.pdfNotesUrl,
    this.duration = '',
    this.orderIndex = 0,
  });

  factory Module.fromMap(Map<String, dynamic> map, {String? id}) {
    return Module(
      id: id ?? map['id'] as String? ?? '',
      title: map['title'] as String? ?? 'Untitled Module',
      description: map['description'] as String? ?? '',
      youtubeVideoId: map['youtubeVideoId'] as String? ??
          map['videoId'] as String? ??
          'dQw4w9WgXcQ',
      pdfNotesUrl: map['pdfNotesUrl'] as String? ??
          map['notesPdfUrl'] as String? ??
          map['notesUrl'] as String?,
      duration: map['duration'] as String? ?? '',
      orderIndex: (map['orderIndex'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'youtubeVideoId': youtubeVideoId,
      'pdfNotesUrl': pdfNotesUrl,
      'notesPdfUrl': pdfNotesUrl,
      'duration': duration,
      'orderIndex': orderIndex,
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
    final data = doc.data() ?? {};
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
          .whereType<Map<String, dynamic>>()
          .map((m) => Module.fromMap(m))
          .toList(),
    );
  }

  /// Asynchronously loads a course doc along with its sub-collection `/courses/{id}/modules`
  static Future<Course> fromFirestoreWithSubcollections(
      DocumentSnapshot<Map<String, dynamic>> doc) async {
    final data = doc.data() ?? {};
    List<Module> modulesList = [];

    // First try top-level modules array
    if (data['modules'] is List && (data['modules'] as List).isNotEmpty) {
      modulesList = (data['modules'] as List)
          .whereType<Map<String, dynamic>>()
          .map((m) => Module.fromMap(m))
          .toList();
    }

    // Also query sub-collection `/courses/{id}/modules`
    try {
      final subSnap = await doc.reference
          .collection('modules')
          .orderBy('orderIndex', descending: false)
          .get();

      if (subSnap.docs.isNotEmpty) {
        final subModules = subSnap.docs.map((subDoc) {
          final mData = subDoc.data();
          return Module.fromMap(mData, id: subDoc.id);
        }).toList();

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
      // Ignore error if sub-collection query is unavailable
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
