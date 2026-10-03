import 'package:cloud_firestore/cloud_firestore.dart';

Map<String, dynamic> _asMap(dynamic item) {
  if (item is Map) {
    return item.map((k, v) => MapEntry(k.toString(), v));
  }
  return <String, dynamic>{};
}

/// Model representing FBISE Class 11 textbook solved exercise items.
class FbiseExerciseItem {
  final String id;
  final int unitNumber;
  final String unitTitle;
  final String questionType; // 'short_q', 'long_q', 'mcq'
  final String questionText;
  final String answerText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final bool isPaid; // false = Free for all, true = Premium Paid Material

  FbiseExerciseItem({
    required this.id,
    required this.unitNumber,
    required this.unitTitle,
    required this.questionType,
    required this.questionText,
    required this.answerText,
    this.options = const [],
    this.correctOptionIndex = 0,
    this.explanation = '',
    this.isPaid = false,
  });

  factory FbiseExerciseItem.fromMap(Map<String, dynamic> rawMap, String id) {
    final map = _asMap(rawMap);
    final opts = map['options'] as List<dynamic>? ?? [];

    return FbiseExerciseItem(
      id: id,
      unitNumber: (map['unitNumber'] as num?)?.toInt() ?? 1,
      unitTitle: map['unitTitle'] as String? ?? 'Unit 1: Computer Systems',
      questionType: map['questionType'] as String? ?? 'short_q',
      questionText: map['questionText'] as String? ?? '',
      answerText: map['answerText'] as String? ?? '',
      options: opts.map((e) => e.toString()).toList(),
      correctOptionIndex: (map['correctOptionIndex'] as num?)?.toInt() ?? 0,
      explanation: map['explanation'] as String? ?? '',
      isPaid: map['isPaid'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'unitNumber': unitNumber,
      'unitTitle': unitTitle,
      'questionType': questionType,
      'questionText': questionText,
      'answerText': answerText,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'explanation': explanation,
      'isPaid': isPaid,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
