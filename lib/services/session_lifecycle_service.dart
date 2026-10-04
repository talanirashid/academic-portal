import '../models/models.dart';

/// Service managing academic class progression paths, promotion mapping, and session-end triggers.
class SessionLifecycleService {
  /// Automated Promotion Path Mapping across Pakistani Boards
  static const Map<String, String> promotionMap = {
    '9th': '10th',
    '10th': '11th',
    '11th': '12th',
    '12th': '12th', // Graduated / Alumnus
  };

  /// Returns the next recommended class in the academic progression pipeline.
  static String getNextClass(String currentClass) {
    return promotionMap[currentClass] ?? '11th';
  }

  /// Evaluates whether a student's active subscription has expired due to session cutoff and requires promotion.
  static bool checkRequiresClassProgression({
    required UserModel user,
    required SessionConfigModel? sessionConfig,
  }) {
    if (user.isAdmin || user.isGuest) return false;

    if (sessionConfig != null && !sessionConfig.isTheoryActive) {
      return user.needsClassPromotion || user.subscriptions.any((sub) => sub.status == 'active' && sub.className == user.currentClass);
    }

    return user.needsClassPromotion;
  }
}
