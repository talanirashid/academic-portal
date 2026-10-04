import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

/// Service managing student authentication, profile syncing, and learning progress tracking in Cloud Firestore.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream of authentication state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Get currently signed-in user.
  User? get currentUser => _auth.currentUser;

  /// Stream of UserModel for reactive RBAC and tier checking.
  Stream<UserModel?> getUserModelStream() {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        return UserModel(
          uid: user.uid,
          email: user.email ?? 'guest@academicportal.pk',
          displayName: user.displayName ?? (user.isAnonymous ? 'Guest Student' : 'Student'),
          role: user.isAnonymous ? UserRole.guest : UserRole.student,
          isAnonymous: user.isAnonymous,
          referralCode: 'PCSA_${user.uid.substring(0, 6).toUpperCase()}',
        );
      }
      return UserModel.fromMap(doc.data()!, user.uid);
    });
  }

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
        'role': user.isAnonymous ? 'guest' : 'student',
        'tier': 'free',
        'isAnonymous': user.isAnonymous,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      });
    } else {
      await userRef.update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Robust Google Web authentication handler with safe rootNavigator dialog dismissal & profile sync
  static Future<void> signInWithGoogleWeb(BuildContext context) async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider.addScope('email');
      googleProvider.addScope('profile');

      UserCredential userCredential = await FirebaseAuth.instance.signInWithPopup(googleProvider);
      User? user = userCredential.user;

      if (user != null) {
        final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
        final docSnap = await userDocRef.get();

        if (!docSnap.exists) {
          await userDocRef.set({
            'uid': user.uid,
            'email': user.email ?? '',
            'displayName': user.displayName ?? (user.email?.split('@').first ?? 'Student'),
            'photoUrl': user.photoURL ?? '',
            'role': 'student',
            'registeredBoard': 'FBISE',
            'currentClass': '11th',
            'tier': 'free',
            'subscriptions': [],
            'createdAt': FieldValue.serverTimestamp(),
            'lastLogin': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        } else {
          await userDocRef.update({
            'lastLogin': FieldValue.serverTimestamp(),
          });
        }

        // Safe dialog dismissal using rootNavigator
        if (context.mounted) {
          final navigator = Navigator.of(context, rootNavigator: true);
          if (navigator.canPop()) {
            navigator.pop();
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuth Error: ${e.code} - ${e.message}');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.code == 'popup-closed-by-user'
                ? 'Sign-in cancelled by user.'
                : 'Authentication failed: ${e.message}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      debugPrint('Unexpected Sign-in Error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Error: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  /// Sign out current student session and safely navigate home.
  static Future<void> signOutWeb(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } catch (e) {
      debugPrint('Sign-out error: $e');
    }
  }

  /// Links guest credentials to a permanent email/password account without resetting active session progress.
  Future<UserCredential?> convertGuestToPermanentAccount(
      String email, String password, String name) async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final credential = EmailAuthProvider.credential(email: email, password: password);
    try {
      final userCred = await user.linkWithCredential(credential);
      await userCred.user?.updateDisplayName(name);

      await _firestore.collection('users').doc(user.uid).set({
        'email': email,
        'displayName': name,
        'role': 'student',
        'isAnonymous': false,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return userCred;
    } catch (e) {
      rethrow;
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

  /// Sign in with Google Provider (using GoogleAuthProvider for Web and Native).
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleProvider = GoogleAuthProvider();
      final creds = await _auth.signInWithPopup(googleProvider);
      if (creds.user != null) {
        await ensureUserRecordExists(creds.user!, name: creds.user!.displayName);
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
