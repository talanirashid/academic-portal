import '../utils/google_drive_helper.dart';

/// Anti-Piracy PDF Watermarking Service providing student attribution stamping.
class PdfService {
  /// Generates a student attribution watermark text for anti-piracy protection.
  static String generateStudentWatermark({
    required String studentName,
    required String studentEmail,
    required String studentUid,
  }) {
    final shortUid = studentUid.length >= 8 ? studentUid.substring(0, 8) : studentUid;
    return 'Licensed to: $studentName ($studentEmail) • PCSA ID: $shortUid • PCSA Anti-Piracy DRM';
  }

  /// Parses and returns a direct streamable URL for PDF viewing.
  static String getStreamablePdfUrl(String rawPdfUrl) {
    return GoogleDriveHelper.getDirectStreamUrl(rawPdfUrl);
  }
}
