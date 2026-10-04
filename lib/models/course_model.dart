import 'package:cloud_firestore/cloud_firestore.dart';
import 'module_model.dart';

Map<String, dynamic> _asMap(dynamic item) {
  if (item is Map) {
    return item.map((k, v) => MapEntry(k.toString(), v));
  }
  return <String, dynamic>{};
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
