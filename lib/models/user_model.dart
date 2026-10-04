import 'package:cloud_firestore/cloud_firestore.dart';

Map<String, dynamic> _asMap(dynamic item) {
  if (item is Map) {
    return item.map((k, v) => MapEntry(k.toString(), v));
  }
  return <String, dynamic>{};
}

/// Model representing a PCSA student or admin user with Role-Based Access Control (RBAC).
class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String role; // 'admin', 'student', 'guest'
  final String board; // 'FBISE', 'STBB (Sindh Board)'
  final String grade; // 'Class 9th', 'Class 10th', 'Class 11th', 'Class 12th'
  final bool isAnonymous;
  final List<String> enrolledCourses;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.role = 'student',
    this.board = 'FBISE',
    this.grade = 'Class 11th',
    this.isAnonymous = false,
    this.enrolledCourses = const [],
  });

  bool get isAdmin => role == 'admin';
  bool get isStudent => role == 'student' && !isAnonymous;
  bool get isGuest => isAnonymous || role == 'guest';

  factory UserModel.fromMap(Map<String, dynamic> rawMap, String uid) {
    final map = _asMap(rawMap);
    final enrolled = map['enrolledCourses'] as List<dynamic>? ?? [];

    return UserModel(
      uid: uid,
      email: map['email'] as String? ?? 'guest@academicportal.pk',
      displayName: map['displayName'] as String? ?? (map['isAnonymous'] == true ? 'Guest Student' : 'Student'),
      role: map['role'] as String? ?? 'student',
      board: map['board'] as String? ?? 'FBISE',
      grade: map['grade'] as String? ?? 'Class 11th',
      isAnonymous: map['isAnonymous'] as bool? ?? false,
      enrolledCourses: enrolled.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': role,
      'board': board,
      'grade': grade,
      'isAnonymous': isAnonymous,
      'enrolledCourses': enrolledCourses,
      'lastLogin': FieldValue.serverTimestamp(),
    };
  }
}
