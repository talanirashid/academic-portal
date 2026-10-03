/// Helper utility for parsing and converting Google Drive sharing URLs to direct direct streamable/downloadable links.
class GoogleDriveHelper {
  /// Converts a standard Google Drive sharing URL (e.g. https://drive.google.com/file/d/FILE_ID/view)
  /// into a direct stream link suitable for Syncfusion PDF Viewer.
  static String getDirectStreamUrl(String rawUrl) {
    if (rawUrl.isEmpty) return rawUrl;

    if (rawUrl.contains('drive.google.com/file/d/')) {
      final regExp = RegExp(r'drive\.google\.com/file/d/([a-zA-Z0-9_-]+)');
      final match = regExp.firstMatch(rawUrl);
      if (match != null && match.groupCount >= 1) {
        final fileId = match.group(1);
        return 'https://drive.google.com/uc?export=download&id=$fileId';
      }
    } else if (rawUrl.contains('drive.google.com/open?id=')) {
      final regExp = RegExp(r'id=([a-zA-Z0-9_-]+)');
      final match = regExp.firstMatch(rawUrl);
      if (match != null && match.groupCount >= 1) {
        final fileId = match.group(1);
        return 'https://drive.google.com/uc?export=download&id=$fileId';
      }
    }

    return rawUrl;
  }
}
