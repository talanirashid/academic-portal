import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/config/drive_vault_config.dart';
import '../models/chapter_resource_model.dart';

/// Repository managing curriculum unit streams and offline/empty fallback record generation.
class CurriculumRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream of ChapterResourceModel units filtered by curriculumStream and targetClass, sorted by unitNumber.
  Stream<List<ChapterResourceModel>> streamUnits({
    required String stream,
    required String targetClass,
  }) {
    return _firestore
        .collection('curriculum_resources')
        .where('curriculumStream', isEqualTo: stream.toLowerCase())
        .where('targetClass', isEqualTo: targetClass.toLowerCase())
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return generateFallbackUnits(stream: stream, targetClass: targetClass);
      }

      final items = snapshot.docs
          .map((doc) => ChapterResourceModel.fromFirestore(doc))
          .toList();

      items.sort((a, b) => a.unitNumber.compareTo(b.unitNumber));
      return items;
    });
  }

  /// Fallback generator producing verified textbook unit records from DriveVaultConfig if Firestore is empty or offline.
  List<ChapterResourceModel> generateFallbackUnits({
    required String stream,
    required String targetClass,
  }) {
    List<String> rawUnitTitles = [];

    if (stream.toLowerCase() == 'stbb') {
      if (targetClass.contains('12')) {
        rawUnitTitles = DriveVaultConfig.stbbClass12Units;
      } else {
        rawUnitTitles = DriveVaultConfig.stbbClass11Units;
      }
    } else {
      if (targetClass.contains('12')) {
        rawUnitTitles = DriveVaultConfig.fbiseClass12Units;
      } else {
        rawUnitTitles = DriveVaultConfig.fbiseClass11Units;
      }
    }

    return List.generate(rawUnitTitles.length, (index) {
      final unitNum = index + 1;
      final title = rawUnitTitles[index];

      return ChapterResourceModel(
        id: '${stream}_${targetClass}_unit_$unitNum',
        curriculumStream: stream.toLowerCase(),
        targetClass: targetClass.toLowerCase(),
        unitNumber: unitNum,
        unitTitle: title,
        description: 'Official 2026 textbook syllabus unit. High-yield theory, solved MCQs, ERQs, and board practical code.',
        notesDriveUrl: DriveVaultConfig.masterFolderUrl,
        solvedExercisesDriveUrl: DriveVaultConfig.masterFolderUrl,
        labJournalDriveUrl: DriveVaultConfig.masterFolderUrl,
        pastPapersDriveUrl: DriveVaultConfig.masterFolderUrl,
        isPublished: true,
      );
    });
  }
}
