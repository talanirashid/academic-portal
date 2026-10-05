import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Robust Google Drive URL parser, file ID extractor, and document viewer launcher.
class GoogleDriveHelper {
  GoogleDriveHelper._();

  /// Extracts the Google Drive file ID from standard share links, open links, uc links, or bare ID strings.
  static String? extractFileId(String input) {
    final raw = input.trim();
    if (raw.isEmpty) return null;

    // Pattern 1: /file/d/FILE_ID/
    if (raw.contains('/file/d/')) {
      final regExp = RegExp(r'/file/d/([a-zA-Z0-9_-]{25,50})');
      final match = regExp.firstMatch(raw);
      if (match != null && match.groupCount >= 1) {
        return match.group(1);
      }
    }

    // Pattern 2: ?id=FILE_ID or &id=FILE_ID
    if (raw.contains('id=')) {
      final regExp = RegExp(r'id=([a-zA-Z0-9_-]{25,50})');
      final match = regExp.firstMatch(raw);
      if (match != null && match.groupCount >= 1) {
        return match.group(1);
      }
    }

    // Pattern 3: Bare ID string (25 to 50 alphanumeric characters)
    final bareRegExp = RegExp(r'^[a-zA-Z0-9_-]{25,50}$');
    if (bareRegExp.hasMatch(raw)) {
      return raw;
    }

    return null;
  }

  /// Returns inline preview URL for web embedding or browser viewing.
  static String getPreviewUrl(String input) {
    final fileId = extractFileId(input);
    if (fileId != null) {
      return 'https://drive.google.com/file/d/$fileId/preview';
    }
    return getDirectStreamUrl(input);
  }

  /// Returns direct download URL for one-click browser downloading.
  static String getDirectDownloadUrl(String input) {
    final fileId = extractFileId(input);
    if (fileId != null) {
      return 'https://drive.usercontent.google.com/download?id=$fileId&export=download&confirm=t';
    }
    return input;
  }

  /// Converts standard share links to uc export stream links (for SfPdfViewer).
  static String getDirectStreamUrl(String rawUrl) {
    final fileId = extractFileId(rawUrl);
    if (fileId != null) {
      return 'https://drive.google.com/uc?export=download&id=$fileId';
    }
    return rawUrl;
  }

  /// Resolves the preview/download link and launches it securely using url_launcher.
  static Future<void> launchDocumentViewer(BuildContext context, String input) async {
    final fileId = extractFileId(input);

    if (fileId == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid Google Drive link or document ID.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      return;
    }

    final String targetUrl = getPreviewUrl(input);
    final Uri uri = Uri.parse(targetUrl);

    try {
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      )) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open document: $targetUrl')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error launching document: ${e.toString()}')),
        );
      }
    }
  }
}
