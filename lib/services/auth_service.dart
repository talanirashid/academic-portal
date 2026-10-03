import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Service managing student authentication, profile syncing, and learning progress tracking in Cloud Firestore.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream of authentication state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Get currently signed-in user.
  User? get currentUser => _auth.currentUser;

  /// Ensures a Firestore user document exists at `/users/{uid}`.
  Future<void> ensureUserRecordExists(User user, {String? name}) async {
    final userRef = _firestore.collection('users').doc(user.uid);
    final doc = await userRef.get();

    if (!doc.exists) {
      await userRef.set({
        'uid': user.uid,
        'email': user.email ?? 'guest@academicportal.pk',
        'displayName': name ??
            user.displayName ??
            (user.isAnonymous ? 'Guest Student' : 'Registered Student'),
        'isAnonymous': user.isAnonymous,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
        'role': 'student',
      });
    } else {
      await userRef.update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Toggle or mark a chapter/module as completed in `/users/{uid}/progress/{courseId}`.
  Future<void> markChapterCompleted(String courseId, String moduleId, {bool completed = true}) async {
    final user = currentUser;
    if (user == null) return;

    final progressRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('progress')
        .doc(courseId);

    if (completed) {
      await progressRef.set({
        'completedModules': FieldValue.arrayUnion([moduleId]),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } else {
      await progressRef.set({
        'completedModules': FieldValue.arrayRemove([moduleId]),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  /// Stream of completed module IDs for a given course under `/users/{uid}/progress/{courseId}`.
  Stream<List<String>> getCompletedModulesStream(String courseId) {
    final user = currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('progress')
        .doc(courseId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return [];
      final data = snapshot.data();
      final list = data?['completedModules'] as List<dynamic>? ?? [];
      return list.map((e) => e.toString()).toList();
    });
  }

  /// Sign in anonymously for instant guest student access.
  Future<UserCredential?> signInAnonymously() async {
    try {
      final creds = await _auth.signInAnonymously();
      if (creds.user != null) {
        await ensureUserRecordExists(creds.user!);
      }
      return creds;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign in with Email and Password.
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      final creds = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (creds.user != null) {
        await ensureUserRecordExists(creds.user!);
      }
      return creds;
    } catch (e) {
      rethrow;
    }
  }

  /// Register a new student account with Email and Password.
  Future<UserCredential?> signUpWithEmail(
      String email, String password, String name) async {
    try {
      final creds = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (creds.user != null) {
        await creds.user!.updateDisplayName(name);
        await ensureUserRecordExists(creds.user!, name: name);
      }
      return creds;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out current student session.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
