import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class AppConstants {
  // Primary Domain & Base Web URLs
  static const String primaryBaseUrl = 'https://pcsacademy.web.app';
  static const String fallbackBaseUrl = 'https://academic-portal-pk.web.app';

  // Official Brand Asset Paths
  static const String appLogo = 'assets/images/pcsa_logo.png';
  static const String appTitle = 'Pakistan Computer Science Academy';
  static const String appShortTitle = 'PCSA';

  // Verified Institutional Contact
  static const String officialEmail = 'pcsacademy.pk@gmail.com';
  static const String officialWhatsAppNumber = '923336366291';

  // Unified Social Media Endpoints (@PCSAcademypk)
  static const String youtube = 'https://www.youtube.com/@PCSAcademypk';
  static const String facebook = 'https://www.facebook.com/PCSAcademypk';
  static const String instagram = 'https://www.instagram.com/PCSAcademypk';
  static const String tiktok = 'https://www.tiktok.com/@PCSAcademypk';
  static const String whatsappChannel = 'https://whatsapp.com/channel/PCSAcademypk';

  // Generic External Link Launcher
  static Future<void> launchLink(String urlString) async {
    final Uri uri = Uri.parse(urlString);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $urlString');
    }
  }

  // Pre-filled Support Email Launcher
  static Future<void> sendSupportEmail({
    String subject = "PCSA Student Inquiry",
    String body = "Hello PCSA Support Team,\n\nI need assistance regarding:",
  }) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: officialEmail,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );
    if (!await launchUrl(emailUri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not open mail client for $officialEmail');
    }
  }

  // Pre-filled WhatsApp Support Message Launcher
  static Future<void> openWhatsAppChat({String? prefilledMessage}) async {
    final String message = prefilledMessage ??
        "Hello PCSA Support! I need assistance regarding Class 11/12 Computer Science preparation.";
    final String encodedMessage = Uri.encodeComponent(message);
    final String whatsappUrl =
        "https://wa.me/$officialWhatsAppNumber?text=$encodedMessage";
    
    await launchLink(whatsappUrl);
  }

  // WhatsApp Payment Verification Chat Trigger
  static Future<void> openPaymentVerificationChat({
    required String studentName,
    required String board,
    required String className,
    required String tid,
    required String plan,
  }) async {
    final String text =
        "Hello PCSA Support! I have submitted my payment.\n"
        "• Name: $studentName\n"
        "• Board: $board\n"
        "• Class: $className\n"
        "• Plan: $plan\n"
        "• TID: $tid\n\n"
        "Please verify and activate my pass.";
    
    await openWhatsAppChat(prefilledMessage: text);
  }
}
