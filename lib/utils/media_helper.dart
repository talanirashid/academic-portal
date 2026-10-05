import 'package:url_launcher/url_launcher.dart';

class MediaHelper {
  MediaHelper._();

  /// Converts any standard YouTube URL into a privacy-enhanced, embeddable URL
  static String normalizeYouTubeEmbedUrl(String rawUrl) {
    if (rawUrl.isEmpty) return '';

    String? videoId;
    final uri = Uri.tryParse(rawUrl.trim());
    if (uri == null) return rawUrl;

    if (uri.host.contains('youtube.com')) {
      if (uri.pathSegments.contains('embed')) {
        videoId = uri.pathSegments.last;
      } else {
        videoId = uri.queryParameters['v'];
      }
    } else if (uri.host.contains('youtu.be')) {
      videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    }

    if (videoId != null && videoId.isNotEmpty) {
      return 'https://www.youtube-nocookie.com/embed/$videoId?rel=0&modestbranding=1';
    }

    return rawUrl;
  }

  /// Resilient fallback for downloading PDF files on mobile and desktop
  static Future<void> launchOrDownloadPdf(String pdfUrl) async {
    final uri = Uri.parse(pdfUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not open document URL: $pdfUrl');
    }
  }
}
