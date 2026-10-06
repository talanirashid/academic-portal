import 'package:cloud_firestore/cloud_firestore.dart';

Map<String, dynamic> _asMap(dynamic item) {
  if (item is Map) {
    return item.map((k, v) => MapEntry(k.toString(), v));
  }
  return <String, dynamic>{};
}

class StudentProfileModel {
  final String uid;
  final String fullName;
  final String email;
  final String boardStream; // 'stbb' | 'fbise'
  final String targetClass; // 'class_09' | 'class_10' | 'class_11' | 'class_12'
  final String? avatarDriveFileId;
  final String? avatarUrl;
  final String? collegeName;
  final String? city;
  final String? phoneNumber;
  final String? academicBio;
  final DateTime createdAt;
  final DateTime updatedAt;

  StudentProfileModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.boardStream,
    required this.targetClass,
    this.avatarDriveFileId,
    this.avatarUrl,
    this.collegeName,
    this.city,
    this.phoneNumber,
    this.academicBio,
    required this.createdAt,
    required this.updatedAt,
  });

  String get displayAvatarUrl {
    if (avatarUrl != null && avatarUrl!.trim().isNotEmpty) {
      return avatarUrl!;
    }
    if (avatarDriveFileId != null && avatarDriveFileId!.trim().isNotEmpty) {
      return 'https://lh3.googleusercontent.com/d/${avatarDriveFileId!}';
    }
    return '';
  }

  factory StudentProfileModel.fromFirestore(DocumentSnapshot doc) {
    final rawData = doc.data();
    final map = _asMap(rawData);

    return StudentProfileModel(
      uid: doc.id,
      fullName: map['fullName'] as String? ?? map['displayName'] as String? ?? 'Student',
      email: map['email'] as String? ?? '',
      boardStream: map['boardStream'] as String? ?? 'fbise',
      targetClass: map['targetClass'] as String? ?? 'class_11',
      avatarDriveFileId: map['avatarDriveFileId'] as String?,
      avatarUrl: map['avatarUrl'] as String? ?? map['photoUrl'] as String?,
      collegeName: map['collegeName'] as String?,
      city: map['city'] as String?,
      phoneNumber: map['phoneNumber'] as String? ?? map['phone'] as String?,
      academicBio: map['academicBio'] as String?,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'displayName': fullName,
      'email': email,
      'boardStream': boardStream,
      'targetClass': targetClass,
      'avatarDriveFileId': avatarDriveFileId,
      'avatarUrl': avatarUrl,
      'collegeName': collegeName,
      'city': city,
      'phoneNumber': phoneNumber,
      'academicBio': academicBio,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  StudentProfileModel copyWith({
    String? fullName,
    String? email,
    String? boardStream,
    String? targetClass,
    String? avatarDriveFileId,
    String? avatarUrl,
    String? collegeName,
    String? city,
    String? phoneNumber,
    String? academicBio,
    DateTime? updatedAt,
  }) {
    return StudentProfileModel(
      uid: uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      boardStream: boardStream ?? this.boardStream,
      targetClass: targetClass ?? this.targetClass,
      avatarDriveFileId: avatarDriveFileId ?? this.avatarDriveFileId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      collegeName: collegeName ?? this.collegeName,
      city: city ?? this.city,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      academicBio: academicBio ?? this.academicBio,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
