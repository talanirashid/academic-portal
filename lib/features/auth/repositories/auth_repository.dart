import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../models/student_profile_model.dart';
import '../../curriculum/models/curriculum_stream.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  User? get currentUser => _auth.currentUser;

  /// Registers a new student and creates their initial Firestore profile.
  Future<StudentProfileModel> signUpStudent({
    required String email,
    required String password,
    required String fullName,
    required BoardStream board,
    required AcademicClass targetClass,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final user = credential.user!;
    await user.updateDisplayName(fullName.trim());

    final profile = StudentProfileModel(
      uid: user.uid,
      fullName: fullName.trim(),
      email: email.trim(),
      boardStream: board.name,
      targetClass: targetClass.codeKey,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _firestore.collection('users').doc(user.uid).set(profile.toMap(), SetOptions(merge: true));

    return profile;
  }

  /// Updates post-login enrichment profile fields in Firestore.
  Future<void> updateStudentProfile(StudentProfileModel profile) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user session found.');

    await _firestore.collection('users').doc(user.uid).set(
          profile.toMap(),
          SetOptions(merge: true),
        );
  }

  /// Encodes image input bytes to Base64 and calls uploadStudentAvatar Cloud Function.
  Future<String> uploadProfilePicture(List<int> imageBytes) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Authentication required to upload avatar.');

    final base64String = base64Encode(imageBytes);

    final callable = _functions.httpsCallable('uploadStudentAvatar');
    final result = await callable.call({'base64Image': base64String});

    final data = result.data as Map<dynamic, dynamic>? ?? {};
    final avatarUrl = data['avatarUrl'] as String? ?? '';

    if (avatarUrl.isEmpty) {
      throw Exception('Failed to retrieve updated Google Drive avatar URL.');
    }

    return avatarUrl;
  }

  /// Wipes Firestore doc and deletes user account for Google Play compliance.
  Future<void> deleteStudentAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final uid = user.uid;

    // 1. Wipe Firestore user profile document
    await _firestore.collection('users').doc(uid).delete();

    // 2. Delete Auth Account
    await user.delete();
  }
}
