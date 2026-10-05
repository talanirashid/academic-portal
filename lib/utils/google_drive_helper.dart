import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Cryptographic Google Drive Link Resolver, Normalizer, and Launcher.
class GoogleDriveHelper {
  GoogleDriveHelper._();

  /// Regex pattern to isolate standard Google Drive File / Folder IDs
  static final RegExp _driveIdRegex = RegExp(r'[-\w]{25,50}');

  /// Extracts the clean alphanumeric File ID from any share URL, embed URL, or base64 token
  static String? extractFileId(String? input) {
    if (input == null || input.trim().isEmpty) return null;
    final trimmed = input.trim();

    // Check if input is a base64 encoded string
    if (!trimmed.contains('/') && !trimmed.contains('?') && trimmed.length % 4 == 0) {
      try {
        final decoded = utf8.decode(base64.decode(trimmed));
        final match = _driveIdRegex.firstMatch(decoded);
        if (match != null) return match.group(0);
      } catch (_) {
        // Fall through to plain text parsing if not valid base64
      }
    }

    final match = _driveIdRegex.firstMatch(trimmed);
    return match?.group(0);
  }

  /// Encrypts/obfuscates a raw Drive ID to safely store inside Firestore records or share links
  static String obfuscateId(String rawId) {
    final cleanId = extractFileId(rawId) ?? rawId;
    return base64.encode(utf8.encode(cleanId));
  }

  /// Generates the direct browser preview URL for Flutter Web iframes or in-app viewers
  static String getPreviewUrl(String fileIdOrUrl) {
    final fileId = extractFileId(fileIdOrUrl);
    if (fileId == null) return '';
    return 'https://drive.google.com/file/d/$fileId/preview';
  }

  /// Generates the direct byte-download link bypassing Google preview chrome
  static String getDirectDownloadUrl(String fileIdOrUrl) {
    final fileId = extractFileId(fileIdOrUrl);
    if (fileId == null) return '';
    return 'https://drive.usercontent.google.com/download?id=$fileId&export=download&confirm=t';
  }

  /// Converts standard share links to uc export stream links (for SfPdfViewer)
  static String getDirectStreamUrl(String rawUrl) {
    final fileId = extractFileId(rawUrl);
    if (fileId != null) {
      return 'https://drive.google.com/uc?export=download&id=$fileId';
    }
    return rawUrl;
  }

  /// Resilient launcher handling both web downloads and native mobile intents
  static Future<void> launchDocumentViewer(BuildContext context, String rawInput) async {
    final fileId = extractFileId(rawInput);
    if (fileId == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Invalid or unresolvable document link.')),
        );
      }
      return;
    }

    final previewUri = Uri.parse(getPreviewUrl(fileId));
    try {
      if (await canLaunchUrl(previewUri)) {
        await launchUrl(previewUri, mode: LaunchMode.externalApplication, webOnlyWindowName: '_blank');
      } else {
        throw 'Could not launch URL';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to open document: $e')),
        );
      }
    }
  }
}
