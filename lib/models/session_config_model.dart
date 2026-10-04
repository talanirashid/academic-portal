import 'package:cloud_firestore/cloud_firestore.dart';

Map<String, dynamic> _asMap(dynamic item) {
  if (item is Map) {
    return item.map((k, v) => MapEntry(k.toString(), v));
  }
  return <String, dynamic>{};
}

/// Model representing global annual board exam session configurations in `/system_configs/academic_sessions/{id}`.
class SessionConfigModel {
  final String id; // e.g. 'FBISE_11_2026', 'STBB_11_2026'
  final String board; // 'FBISE' or 'STBB'
  final String className; // '9th', '10th', '11th', '12th'
  final DateTime theoryCutoffDate;
  final DateTime practicalCutoffDate;
  final bool isSessionActive;

  SessionConfigModel({
    required this.id,
    required this.board,
    required this.className,
    required this.theoryCutoffDate,
    required this.practicalCutoffDate,
    this.isSessionActive = true,
  });

  bool get isTheoryActive =>
      isSessionActive && theoryCutoffDate.isAfter(DateTime.now());

  bool get isPracticalActive =>
      isSessionActive && practicalCutoffDate.isAfter(DateTime.now());

  int get remainingTheoryDays {
    final diff = theoryCutoffDate.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }

  int get remainingPracticalDays {
    final diff = practicalCutoffDate.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }

  factory SessionConfigModel.fromMap(Map<String, dynamic> rawMap, String id) {
    final map = _asMap(rawMap);
    final theoryTs = map['theoryCutoffDate'];
    final practicalTs = map['practicalCutoffDate'];

    DateTime tDate = DateTime.now().add(const Duration(days: 120));
    if (theoryTs is Timestamp) {
      tDate = theoryTs.toDate();
    }

    DateTime pDate = DateTime.now().add(const Duration(days: 150));
    if (practicalTs is Timestamp) {
      pDate = practicalTs.toDate();
    }

    return SessionConfigModel(
      id: id,
      board: map['board'] as String? ?? 'FBISE',
      className: map['className'] as String? ?? '11th',
      theoryCutoffDate: tDate,
      practicalCutoffDate: pDate,
      isSessionActive: map['isSessionActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'board': board,
      'className': className,
      'theoryCutoffDate': Timestamp.fromDate(theoryCutoffDate),
      'practicalCutoffDate': Timestamp.fromDate(practicalCutoffDate),
      'isSessionActive': isSessionActive,
      'lastUpdated': FieldValue.serverTimestamp(),
    };
  }
}
