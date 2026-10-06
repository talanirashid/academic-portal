import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../utils/google_drive_helper.dart';

Map<String, dynamic> _asMap(dynamic item) {
  if (item is Map) {
    return item.map((k, v) => MapEntry(k.toString(), v));
  }
  return <String, dynamic>{};
}

/// Model representing a curriculum unit resource slot in Cloud Firestore `/curriculum_resources/{id}`.
class ChapterResourceModel {
  final String id;
  final String curriculumStream; // 'stbb' | 'fbise'
  final String targetClass; // 'class_09' | 'class_10' | 'class_11' | 'class_12'
  final int unitNumber;
  final String unitTitle;
  final String description;
  final String? notesDriveUrl;
  final String? solvedExercisesDriveUrl;
  final String? labJournalDriveUrl;
  final String? pastPapersDriveUrl;
  final bool isPublished;

  ChapterResourceModel({
    required this.id,
    required this.curriculumStream,
    required this.targetClass,
    required this.unitNumber,
    required this.unitTitle,
    required this.description,
    this.notesDriveUrl,
    this.solvedExercisesDriveUrl,
    this.labJournalDriveUrl,
    this.pastPapersDriveUrl,
    this.isPublished = true,
  });

  /// Helper method to safely resolve any of the file URLs via GoogleDriveHelper.getPreviewUrl()
  String? getResolvedPreviewUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.trim().isEmpty) return null;
    return GoogleDriveHelper.getPreviewUrl(rawUrl);
  }

  factory ChapterResourceModel.fromFirestore(DocumentSnapshot doc) {
    final rawData = doc.data();
    final map = _asMap(rawData);

    return ChapterResourceModel(
      id: doc.id,
      curriculumStream: map['curriculumStream'] as String? ?? 'fbise',
      targetClass: map['targetClass'] as String? ?? 'class_11',
      unitNumber: (map['unitNumber'] as num?)?.toInt() ?? 1,
      unitTitle: map['unitTitle'] as String? ?? 'Unit Title',
      description: map['description'] as String? ?? '',
      notesDriveUrl: map['notesDriveUrl'] as String?,
      solvedExercisesDriveUrl: map['solvedExercisesDriveUrl'] as String?,
      labJournalDriveUrl: map['labJournalDriveUrl'] as String?,
      pastPapersDriveUrl: map['pastPapersDriveUrl'] as String?,
      isPublished: map['isPublished'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'curriculumStream': curriculumStream,
      'targetClass': targetClass,
      'unitNumber': unitNumber,
      'unitTitle': unitTitle,
      'description': description,
      'notesDriveUrl': notesDriveUrl,
      'solvedExercisesDriveUrl': solvedExercisesDriveUrl,
      'labJournalDriveUrl': labJournalDriveUrl,
      'pastPapersDriveUrl': pastPapersDriveUrl,
      'isPublished': isPublished,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
