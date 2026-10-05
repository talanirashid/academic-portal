import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentTransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String sanitizeTid(String rawTid) {
    return rawTid.trim().toUpperCase().replaceAll(RegExp(r'[^A-Z0-9\-_]'), '');
  }

  /// Student Side: Prevents duplicate TID submissions
  Future<void> submitPaymentProof({
    required String uid,
    required String studentEmail,
    required String rawTid,
    required String boardId,
    required String targetGrade,
    required double amount,
    required String provider, // 'Easypaisa' | 'JazzCash' | 'HBL'
  }) async {
    final cleanTid = sanitizeTid(rawTid);
    if (cleanTid.length < 6) {
      throw Exception('Invalid Transaction ID format.');
    }

    final query = await _firestore
        .collection('payment_verifications')
        .where('tid', isEqualTo: cleanTid)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      throw Exception('This Transaction ID (TID) has already been submitted.');
    }

    final docRef = _firestore.collection('payment_verifications').doc();
    await docRef.set({
      'verificationId': docRef.id,
      'uid': uid,
      'studentEmail': studentEmail,
      'tid': cleanTid,
      'boardId': boardId,
      'targetGrade': targetGrade,
      'amount': amount,
      'provider': provider,
      'status': 'pending', // 'pending' | 'approved' | 'rejected'
      'rejectionReason': null,
      'submittedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Admin Side: Atomic approval with pass activation
  Future<void> approvePaymentPass({
    required String verificationId,
    required String studentUid,
    required String boardId,
    required String targetGrade,
    required String adminUid,
  }) async {
    final verifyRef = _firestore.collection('payment_verifications').doc(verificationId);
    final userPassRef = _firestore
        .collection('users')
        .doc(studentUid)
        .collection('active_passes')
        .doc('${boardId}_$targetGrade');

    await _firestore.runTransaction((transaction) async {
      final verifySnapshot = await transaction.get(verifyRef);
      if (!verifySnapshot.exists) {
        throw Exception('Verification record does not exist.');
      }

      transaction.update(verifyRef, {
        'status': 'approved',
        'reviewedBy': adminUid,
        'approvedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      transaction.set(userPassRef, {
        'passId': '${boardId}_$targetGrade',
        'boardId': boardId,
        'targetGrade': targetGrade,
        'isActive': true,
        'activatedAt': FieldValue.serverTimestamp(),
        'grantedBy': adminUid,
      }, SetOptions(merge: true));
    });
  }

  /// Admin Side: Rejection pipeline
  Future<void> rejectPaymentPass({
    required String verificationId,
    required String adminUid,
    required String reason,
  }) async {
    await _firestore.collection('payment_verifications').doc(verificationId).update({
      'status': 'rejected',
      'rejectionReason': reason,
      'reviewedBy': adminUid,
      'rejectedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
