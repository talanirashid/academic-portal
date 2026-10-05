Map<String, dynamic> _asMap(dynamic item) {
  if (item is Map) {
    return item.map((k, v) => MapEntry(k.toString(), v));
  }
  return <String, dynamic>{};
}

/// Sub-divided lecture part within a chapter (Part 1: Theory, Part 2: Practical, Part 3: Exercise).
class SubLecture {
  final String id;
  final String title;
  final String videoUrl; // Embedded video stream or Youtube ID
  final String durationMinutes;
  final bool isExerciseReview;

  SubLecture({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.durationMinutes,
    this.isExerciseReview = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'videoUrl': videoUrl,
        'durationMinutes': durationMinutes,
        'isExerciseReview': isExerciseReview,
      };

  factory SubLecture.fromMap(Map<String, dynamic> rawMap) {
    final map = _asMap(rawMap);
    return SubLecture(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      videoUrl: map['videoUrl'] as String? ?? '',
      durationMinutes: map['durationMinutes'] as String? ?? '20m',
      isExerciseReview: map['isExerciseReview'] as bool? ?? false,
    );
  }
}

/// Chapter model containing sub-divided lectures and exercise solution attachments.
class ChapterItem {
  final String chapterId;
  final int chapterNumber;
  final String chapterTitle;
  final String description;
  final List<SubLecture> lectures; // Sub-divided parts
  final String? exerciseSolutionPdfUrl; // Watermarked PDF
  final List<String> keyLearningOutcomes;

  ChapterItem({
    required this.chapterId,
    required this.chapterNumber,
    required this.chapterTitle,
    required this.description,
    required this.lectures,
    this.exerciseSolutionPdfUrl,
    required this.keyLearningOutcomes,
  });

  Map<String, dynamic> toMap() => {
        'chapterId': chapterId,
        'chapterNumber': chapterNumber,
        'chapterTitle': chapterTitle,
        'description': description,
        'lectures': lectures.map((l) => l.toMap()).toList(),
        'exerciseSolutionPdfUrl': exerciseSolutionPdfUrl,
        'keyLearningOutcomes': keyLearningOutcomes,
      };

  factory ChapterItem.fromMap(Map<String, dynamic> rawMap) {
    final map = _asMap(rawMap);
    final rawLecs = map['lectures'] as List<dynamic>? ?? [];
    final rawOutcomes = map['keyLearningOutcomes'] as List<dynamic>? ?? [];

    return ChapterItem(
      chapterId: map['chapterId'] as String? ?? '',
      chapterNumber: (map['chapterNumber'] as num?)?.toInt() ?? 1,
      chapterTitle: map['chapterTitle'] as String? ?? '',
      description: map['description'] as String? ?? '',
      lectures: rawLecs.whereType<Map>().map((l) => SubLecture.fromMap(_asMap(l))).toList(),
      exerciseSolutionPdfUrl: map['exerciseSolutionPdfUrl'] as String?,
      keyLearningOutcomes: rawOutcomes.map((e) => e.toString()).toList(),
    );
  }
}

/// Comprehensive course structure for the Publisher Module in CommandCenter.
class ComprehensiveCourse {
  final String courseId;
  final String boardId; // e.g., 'biek_karachi' or 'fbise_islamabad'
  final String curriculumStream; // 'federal' or 'sindh'
  final String targetClass; // '9th', '10th', '11th', '12th'
  final String subject; // 'Computer Science'
  final String courseTitle; // Manual custom title
  final String instructorName; // Manual custom instructor name
  final String description; // Manual markdown/plain description
  final String? thumbnailBannerUrl;
  final List<ChapterItem> chapters;
  final DateTime createdAt;
  final DateTime updatedAt;

  ComprehensiveCourse({
    required this.courseId,
    required this.boardId,
    required this.curriculumStream,
    required this.targetClass,
    required this.subject,
    required this.courseTitle,
    required this.instructorName,
    required this.description,
    this.thumbnailBannerUrl,
    required this.chapters,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
        'courseId': courseId,
        'boardId': boardId,
        'curriculumStream': curriculumStream,
        'targetClass': targetClass,
        'subject': subject,
        'courseTitle': courseTitle,
        'instructorName': instructorName,
        'description': description,
        'thumbnailBannerUrl': thumbnailBannerUrl,
        'chapters': chapters.map((c) => c.toMap()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory ComprehensiveCourse.fromMap(Map<String, dynamic> rawMap, String id) {
    final map = _asMap(rawMap);
    final rawChaps = map['chapters'] as List<dynamic>? ?? [];

    DateTime cAt = DateTime.now();
    DateTime uAt = DateTime.now();
    if (map['createdAt'] != null) {
      cAt = DateTime.tryParse(map['createdAt'].toString()) ?? cAt;
    }
    if (map['updatedAt'] != null) {
      uAt = DateTime.tryParse(map['updatedAt'].toString()) ?? uAt;
    }

    return ComprehensiveCourse(
      courseId: id,
      boardId: map['boardId'] as String? ?? 'fbise_islamabad',
      curriculumStream: map['curriculumStream'] as String? ?? 'federal',
      targetClass: map['targetClass'] as String? ?? '11th',
      subject: map['subject'] as String? ?? 'Computer Science',
      courseTitle: map['courseTitle'] as String? ?? 'Untitled Course',
      instructorName: map['instructorName'] as String? ?? 'PCSA Faculty',
      description: map['description'] as String? ?? '',
      thumbnailBannerUrl: map['thumbnailBannerUrl'] as String?,
      chapters: rawChaps.whereType<Map>().map((c) => ChapterItem.fromMap(_asMap(c))).toList(),
      createdAt: cAt,
      updatedAt: uAt,
    );
  }
}
