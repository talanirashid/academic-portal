import 'package:cloud_firestore/cloud_firestore.dart';

Map<String, dynamic> _asMap(dynamic item) {
  if (item is Map) {
    return item.map((k, v) => MapEntry(k.toString(), v));
  }
  return <String, dynamic>{};
}

/// User Roles for Role-Based Access Control (RBAC).
enum UserRole { admin, student, guest }

/// Freemium Membership Tiers (Rebranded to Annual Session Pass).
enum MembershipTier { free, annualSessionPass, practicalPass }

/// Model representing a PCSA student or admin user with Role-Based Access Control (RBAC), Session-Bound Access, and Referrals.
class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final UserRole role;
  final MembershipTier tier;
  final DateTime? subscriptionExpiry;
  final String activeBoard; // 'FBISE' or 'STBB'
  final String activeClass; // '9th', '10th', '11th', '12th'
  final bool isAnonymous;
  final String? activeDeviceId;
  final String referralCode;
  final String? referredBy;
  final int successfulReferralsCount;
  final List<String> unlockedModules;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.role = UserRole.student,
    this.tier = MembershipTier.free,
    this.subscriptionExpiry,
    this.activeBoard = 'FBISE',
    this.activeClass = '11th',
    this.isAnonymous = false,
    this.activeDeviceId,
    required this.referralCode,
    this.referredBy,
    this.successfulReferralsCount = 0,
    this.unlockedModules = const [],
  });

  bool get isAdmin => role == UserRole.admin;

  bool get isPro =>
      role == UserRole.admin ||
      tier == MembershipTier.annualSessionPass ||
      (subscriptionExpiry != null && subscriptionExpiry!.isAfter(DateTime.now()));

  bool get isPracticalUnlocked => isPro || tier == MembershipTier.practicalPass;

  factory UserModel.fromMap(Map<String, dynamic> rawMap, String id) {
    final map = _asMap(rawMap);
    final unlocked = map['unlockedModules'] as List<dynamic>? ?? map['enrolledCourses'] as List<dynamic>? ?? [];

    UserRole roleEnum = UserRole.student;
    final roleStr = map['role'] as String? ?? 'student';
    if (roleStr == 'admin') {
      roleEnum = UserRole.admin;
    } else if (roleStr == 'guest' || map['isAnonymous'] == true) {
      roleEnum = UserRole.guest;
    }

    MembershipTier tierEnum = MembershipTier.free;
    final tierStr = map['tier'] as String? ?? 'free';
    if (tierStr == 'annualSessionPass' || tierStr == 'semesterPass') {
      tierEnum = MembershipTier.annualSessionPass;
    } else if (tierStr == 'practicalPass') {
      tierEnum = MembershipTier.practicalPass;
    }

    DateTime? expiry;
    final expTs = map['subscriptionExpiry'];
    if (expTs is Timestamp) {
      expiry = expTs.toDate();
    }

    return UserModel(
      uid: id,
      email: map['email'] as String? ?? 'guest@academicportal.pk',
      displayName: map['displayName'] as String? ?? (map['isAnonymous'] == true ? 'Guest Student' : 'Student'),
      role: roleEnum,
      tier: tierEnum,
      subscriptionExpiry: expiry,
      activeBoard: map['activeBoard'] as String? ?? map['board'] as String? ?? 'FBISE',
      activeClass: map['activeClass'] as String? ?? map['grade'] as String? ?? '11th',
      isAnonymous: map['isAnonymous'] as bool? ?? false,
      activeDeviceId: map['activeDeviceId'] as String?,
      referralCode: map['referralCode'] as String? ?? 'PCSA_${id.substring(0, 6).toUpperCase()}',
      referredBy: map['referredBy'] as String?,
      successfulReferralsCount: (map['successfulReferralsCount'] as num?)?.toInt() ?? 0,
      unlockedModules: unlocked.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': role.name,
      'tier': tier.name,
      'subscriptionExpiry': subscriptionExpiry != null ? Timestamp.fromDate(subscriptionExpiry!) : null,
      'activeBoard': activeBoard,
      'activeClass': activeClass,
      'isAnonymous': isAnonymous,
      'activeDeviceId': activeDeviceId,
      'referralCode': referralCode,
      'referredBy': referredBy,
      'successfulReferralsCount': successfulReferralsCount,
      'unlockedModules': unlockedModules,
      'lastLogin': FieldValue.serverTimestamp(),
    };
  }
}
