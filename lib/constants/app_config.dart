class AppConfig {
  AppConfig._();

  static const String appName = 'PCSA';
  static const String appFullName = 'Pakistan Computer Science Academy';

  // Production URL definitions
  static const String primaryHostingDomain = 'pcsacademy.web.app';
  static const String fallbackHostingDomain = 'academic-portal-pk.web.app';
  static const String baseUrl = 'https://$primaryHostingDomain';

  // Support & Payment Accounts
  static const String officialWhatsAppNumber = '923336366291';
  static const String jazzCashAccountTitle = 'PCS Academy Operations';
  static const String easyPaisaAccountTitle = 'PCS Academy Operations';

  // Dynamic link & share generator
  static String buildShareableChapterUrl(String stream, String classId, String chapterId) {
    return '$baseUrl/#/curriculum/$stream/$classId/$chapterId';
  }

  static String buildWhatsAppInquiryUrl(String transactionId, String studentEmail) {
    final message = Uri.encodeComponent(
        'Salam PCSA Admin, I submitted payment verification. TID: $transactionId, Email: $studentEmail');
    return 'https://wa.me/$officialWhatsAppNumber?text=$message';
  }
}
