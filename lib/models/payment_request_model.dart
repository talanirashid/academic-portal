import 'package:cloud_firestore/cloud_firestore.dart';

Map<String, dynamic> _asMap(dynamic item) {
  if (item is Map) {
    return item.map((k, v) => MapEntry(k.toString(), v));
  }
  return <String, dynamic>{};
}

/// Model representing a manual payment verification request for paid course enrollment.
class PaymentRequest {
  final String id;
  final String studentUid;
  final String studentEmail;
  final String studentName;
  final String courseId;
  final String courseTitle;
  final String gateway; // 'EasyPaisa' or 'HBL Bank'
  final String senderName;
  final String senderAccount;
  final String transactionId; // TRX ID
  final double amount;
  final String status; // 'pending', 'approved', 'rejected'
  final String? rejectionReason;
  final DateTime? createdAt;

  PaymentRequest({
    required this.id,
    required this.studentUid,
    required this.studentEmail,
    required this.studentName,
    required this.courseId,
    required this.courseTitle,
    required this.gateway,
    required this.senderName,
    required this.senderAccount,
    required this.transactionId,
    this.amount = 1500.0,
    this.status = 'pending',
    this.rejectionReason,
    this.createdAt,
  });

  factory PaymentRequest.fromMap(Map<String, dynamic> rawMap, String id) {
    final map = _asMap(rawMap);
    final ts = map['createdAt'];
    DateTime? created;
    if (ts is Timestamp) {
      created = ts.toDate();
    }

    return PaymentRequest(
      id: id,
      studentUid: map['studentUid'] as String? ?? '',
      studentEmail: map['studentEmail'] as String? ?? 'guest@academicportal.pk',
      studentName: map['studentName'] as String? ?? 'Student',
      courseId: map['courseId'] as String? ?? '',
      courseTitle: map['courseTitle'] as String? ?? 'Course Access',
      gateway: map['gateway'] as String? ?? 'EasyPaisa',
      senderName: map['senderName'] as String? ?? '',
      senderAccount: map['senderAccount'] as String? ?? '',
      transactionId: map['transactionId'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 1500.0,
      status: map['status'] as String? ?? 'pending',
      rejectionReason: map['rejectionReason'] as String?,
      createdAt: created,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentUid': studentUid,
      'studentEmail': studentEmail,
      'studentName': studentName,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'gateway': gateway,
      'senderName': senderName,
      'senderAccount': senderAccount,
      'transactionId': transactionId,
      'amount': amount,
      'status': status,
      'rejectionReason': rejectionReason,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
