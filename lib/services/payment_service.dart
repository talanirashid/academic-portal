import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/payment_request_model.dart';

/// Service managing student manual payment verification (EasyPaisa & HBL) and course enrollments.
class PaymentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Official Payment Gateway Account Details
  static const String easyPaisaTitle = 'Muhammad Rashid';
  static const String easyPaisaNumber = '03123656361';

  static const String hblTitle = 'Muhammad Rashid';
  static const String hblAccountNumber = '00717918821503';

  /// Submits a manual payment verification request under `/payment_requests/{reqId}`.
  Future<void> submitPaymentRequest(PaymentRequest req) async {
    final docRef = _firestore.collection('payment_requests').doc();
    await docRef.set(req.toMap(), SetOptions(merge: true));
  }

  /// Stream of pending payment requests for Admin Verification Panel.
  Stream<List<PaymentRequest>> getPendingPaymentRequestsStream() {
    return _firestore
        .collection('payment_requests')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PaymentRequest.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  /// Stream of all payment requests for a specific student.
  Stream<List<PaymentRequest>> getStudentPaymentRequestsStream(String studentUid) {
    return _firestore
        .collection('payment_requests')
        .where('studentUid', isEqualTo: studentUid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PaymentRequest.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  /// Stream of enrolled course IDs for a given student from `/users/{studentUid}`.
  Stream<List<String>> getEnrolledCoursesStream(String studentUid) {
    return _firestore
        .collection('users')
        .doc(studentUid)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return [];
      final data = snapshot.data();
      final list = data?['enrolledCourses'] as List<dynamic>? ?? [];
      return list.map((e) => e.toString()).toList();
    });
  }

  /// Admin Action: Approves payment request, updating status and adding `courseId` to student's `enrolledCourses` array.
  Future<void> approvePaymentRequest(PaymentRequest req) async {
    final batch = _firestore.batch();

    // 1. Update payment request status to approved
    final reqRef = _firestore.collection('payment_requests').doc(req.id);
    batch.update(reqRef, {
      'status': 'approved',
      'processedAt': FieldValue.serverTimestamp(),
    });

    // 2. Grant course enrollment access to student document
    final userRef = _firestore.collection('users').doc(req.studentUid);
    batch.set(userRef, {
      'enrolledCourses': FieldValue.arrayUnion([req.courseId]),
    }, SetOptions(merge: true));

    await batch.commit();
  }

  /// Admin Action: Rejects payment request with a reason.
  Future<void> rejectPaymentRequest(String reqId, String reason) async {
    await _firestore.collection('payment_requests').doc(reqId).update({
      'status': 'rejected',
      'rejectionReason': reason,
      'processedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Helper to check if a course is unlocked for the student.
  /// Free courses (`isPaid == false`) are ALWAYS unlocked!
  bool isCourseUnlocked(String courseId, bool isPaid, List<String> enrolledCourses) {
    if (!isPaid) return true; // 100% Free course material!
    return enrolledCourses.contains(courseId);
  }
}
