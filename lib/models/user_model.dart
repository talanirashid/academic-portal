import 'package:cloud_firestore/cloud_firestore.dart';

Map<String, dynamic> _asMap(dynamic item) {
  if (item is Map) {
    return item.map((k, v) => MapEntry(k.toString(), v));
  }
  return <String, dynamic>{};
}

/// User Roles for Role-Based Access Control (RBAC).
enum UserRole { admin, student, guest }

/// Freemium Membership Tiers.
enum MembershipTier { free, annualSessionPass, practicalPass }

/// Subscription entry tracking academic class enrollments.
class UserSubscription {
  final String subscriptionId;
  final String board; // 'FBISE' | 'STBB'
  final String className; // '9th' | '10th' | '11th' | '12th'
  final String plan; // 'annualSessionPass' | 'practicalPass'
  final String status; // 'active' | 'expired' | 'renewed'
  final DateTime activatedAt;
  final DateTime? expiredAt;

  UserSubscription({
    required this.subscriptionId,
    required this.board,
    required this.className,
    required this.plan,
    required this.status,
    required this.activatedAt,
    this.expiredAt,
  });

  factory UserSubscription.fromMap(Map<String, dynamic> rawMap) {
    final map = _asMap(rawMap);
    final actTs = map['activatedAt'];
    final expTs = map['expiredAt'];

    DateTime actDate = DateTime.now();
    if (actTs is Timestamp) {
      actDate = actTs.toDate();
    }

    DateTime? expDate;
    if (expTs is Timestamp) {
      expDate = expTs.toDate();
    }

    return UserSubscription(
      subscriptionId: map['subscriptionId'] as String? ?? '',
      board: map['board'] as String? ?? 'FBISE',
      className: map['className'] as String? ?? '11th',
      plan: map['plan'] as String? ?? 'annualSessionPass',
      status: map['status'] as String? ?? 'active',
      activatedAt: actDate,
      expiredAt: expDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subscriptionId': subscriptionId,
      'board': board,
      'className': className,
      'plan': plan,
      'status': status,
      'activatedAt': Timestamp.fromDate(activatedAt),
      'expiredAt': expiredAt != null ? Timestamp.fromDate(expiredAt!) : null,
    };
  }
}

/// Model representing a PCSA student or admin user with Academic Progression and Subscriptions.
class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final UserRole role; // 'admin' | 'student' | 'guest'
  final String currentClass; // Tracks highest active or target class (e.g. '11th')
  final String registeredBoard; // 'FBISE' | 'STBB'
  final MembershipTier tier;
  final DateTime? subscriptionExpiry;
  final bool isAnonymous;
  final String? activeDeviceId;
  final String referralCode;
  final String? referredBy;
  final int successfulReferralsCount;
  final List<UserSubscription> subscriptions;
  final List<String> unlockedModules;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.role = UserRole.student,
    this.currentClass = '11th',
    this.registeredBoard = 'FBISE',
    this.tier = MembershipTier.free,
    this.subscriptionExpiry,
    this.isAnonymous = false,
    this.activeDeviceId,
    required this.referralCode,
    this.referredBy,
    this.successfulReferralsCount = 0,
    this.subscriptions = const [],
    this.unlockedModules = const [],
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isGuest => isAnonymous || role == UserRole.guest;

  bool get isPro =>
      role == UserRole.admin ||
      tier == MembershipTier.annualSessionPass ||
      subscriptions.any((sub) => sub.status == 'active') ||
      (subscriptionExpiry != null && subscriptionExpiry!.isAfter(DateTime.now()));

  bool get isPracticalUnlocked =>
      isPro ||
      tier == MembershipTier.practicalPass ||
      subscriptions.any((sub) => sub.status == 'active' && (sub.plan == 'practicalPass' || sub.plan == 'annualSessionPass'));

  /// Scope-locked check evaluating whether the user has access to a specific board and class
  bool hasAccessTo({
    required String targetBoard,
    required String targetClass,
    bool requiresPracticalOnly = false,
  }) {
    if (role == UserRole.admin) return true;
    return subscriptions.any((sub) =>
        sub.status == 'active' &&
        sub.board == targetBoard &&
        sub.className == targetClass &&
        (!requiresPracticalOnly || sub.plan == 'practicalPass' || sub.plan == 'annualSessionPass'));
  }

  /// Returns true if previous subscription ended and user has not enrolled in the next class
  bool get needsClassPromotion {
    final hasActive = subscriptions.any((sub) => sub.status == 'active');
    final hasExpired = subscriptions.any((sub) => sub.status == 'expired');
    return !hasActive && hasExpired;
  }

  factory UserModel.fromMap(Map<String, dynamic> rawMap, String id) {
    final map = _asMap(rawMap);
    final unlocked = map['unlockedModules'] as List<dynamic>? ?? map['enrolledCourses'] as List<dynamic>? ?? [];
    final rawSubs = map['subscriptions'] as List<dynamic>? ?? [];

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
      currentClass: map['currentClass'] as String? ?? map['activeClass'] as String? ?? map['grade'] as String? ?? '11th',
      registeredBoard: map['registeredBoard'] as String? ?? map['activeBoard'] as String? ?? map['board'] as String? ?? 'FBISE',
      tier: tierEnum,
      subscriptionExpiry: expiry,
      isAnonymous: map['isAnonymous'] as bool? ?? false,
      activeDeviceId: map['activeDeviceId'] as String?,
      referralCode: map['referralCode'] as String? ?? 'PCSA_${id.substring(0, 6).toUpperCase()}',
      referredBy: map['referredBy'] as String?,
      successfulReferralsCount: (map['successfulReferralsCount'] as num?)?.toInt() ?? 0,
      subscriptions: rawSubs.whereType<Map>().map((s) => UserSubscription.fromMap(_asMap(s))).toList(),
      unlockedModules: unlocked.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': role.name,
      'currentClass': currentClass,
      'registeredBoard': registeredBoard,
      'tier': tier.name,
      'subscriptionExpiry': subscriptionExpiry != null ? Timestamp.fromDate(subscriptionExpiry!) : null,
      'isAnonymous': isAnonymous,
      'activeDeviceId': activeDeviceId,
      'referralCode': referralCode,
      'referredBy': referredBy,
      'successfulReferralsCount': successfulReferralsCount,
      'subscriptions': subscriptions.map((s) => s.toMap()).toList(),
      'unlockedModules': unlockedModules,
      'lastLogin': FieldValue.serverTimestamp(),
    };
  }
}
