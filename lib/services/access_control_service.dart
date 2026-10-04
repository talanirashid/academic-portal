import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

/// Service providing dynamic access evaluation against global board session configs in `/system_configs/academic_sessions`.
class AccessControlService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream of active session config for a given board and class (e.g. 'FBISE_11_2026').
  Stream<SessionConfigModel?> getSessionConfigStream(String board, String className) {
    final docId = '${board}_${className}_2026'.replaceAll(' ', '_');
    return _firestore
        .collection('system_configs')
        .doc('academic_sessions')
        .collection('sessions')
        .doc(docId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) {
        // Return default fallback config if doc not yet created
        return SessionConfigModel(
          id: docId,
          board: board,
          className: className,
          theoryCutoffDate: DateTime.now().add(const Duration(days: 120)),
          practicalCutoffDate: DateTime.now().add(const Duration(days: 150)),
        );
      }
      return SessionConfigModel.fromMap(doc.data()!, doc.id);
    });
  }

  /// Admin Action: Updates or extends board exam cutoff deadlines for all enrolled students.
  Future<void> updateSessionCutoff({
    required String board,
    required String className,
    required DateTime theoryCutoff,
    required DateTime practicalCutoff,
    bool isSessionActive = true,
  }) async {
    final docId = '${board}_${className}_2026'.replaceAll(' ', '_');
    final docRef = _firestore
        .collection('system_configs')
        .doc('academic_sessions')
        .collection('sessions')
        .doc(docId);

    await docRef.set({
      'board': board,
      'className': className,
      'theoryCutoffDate': Timestamp.fromDate(theoryCutoff),
      'practicalCutoffDate': Timestamp.fromDate(practicalCutoff),
      'isSessionActive': isSessionActive,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Evaluates whether a student's membership tier is currently active for their board and class.
  bool evaluateAccess({
    required UserModel user,
    required SessionConfigModel? sessionConfig,
    bool isPracticalRequirement = false,
  }) {
    if (user.isAdmin) return true;

    // Check hard cutoff date if config exists
    if (sessionConfig != null) {
      if (!sessionConfig.isSessionActive) return false;
      if (isPracticalRequirement && !sessionConfig.isPracticalActive) return false;
      if (!isPracticalRequirement && !sessionConfig.isTheoryActive) return false;
    }

    if (isPracticalRequirement) {
      return user.isPracticalUnlocked;
    }

    return user.isPro;
  }
}
