import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Professional Academic Footer Component for PCSA Web Portal.
class AppFooterWidget extends StatelessWidget {
  const AppFooterWidget({super.key});

  static const String _whatsappUrl = 'https://whatsapp.com/channel/0029Va9PCSA';
  static const String _youtubeUrl = 'https://youtube.com/@PCSA_Official';
  static const String _facebookUrl = 'https://facebook.com/PCSA.Official';
  static const String _instagramUrl = 'https://instagram.com/PCSA_Official';
  static const String _tiktokUrl = 'https://tiktok.com/@PCSA_Official';

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // Silent catch
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF00381B),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Column 1: Brand & Tagline
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.amber,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.shield, color: Color(0xFF004D26), size: 24),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'PCSA Portal',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Pakistan Computer Science Academy',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.amber),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '“Bridging Foundational Concepts with Modern Computing Excellence.”',
                        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Conceptual, Rigorous & High-Yield Learning Materials for Federal Board (FBISE - NBF Edition) and Sindh Textbook Board (STBB Unified Curriculum).',
                        style: TextStyle(fontSize: 12, color: Colors.white60, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),

                // Column 2: Public Student Quick Links
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Student Resources', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 14)),
                      const SizedBox(height: 8),
                      _footerLink(context, 'FBISE Solved Exercises', '/solved-exercises'),
                      _footerLink(context, 'Solved Board Past Papers', '/past-papers'),
                      _footerLink(context, 'Exam Night Cheat Sheet', '/cheat-sheet'),
                      _footerLink(context, 'Student Account Register', '/register'),
                    ],
                  ),
                ),
                const SizedBox(width: 24),

                // Column 3: Social Media Community Grid
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Academic Community & Socials', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 14)),
                      const SizedBox(height: 8),
                      const Text(
                        'Join our official social channels for daily board MCQs, syllabus updates, and live exam guidance:',
                        style: TextStyle(fontSize: 12, color: Colors.white70, height: 1.3),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _socialIconButton('WhatsApp', Icons.chat, const Color(0xFF25D366), _whatsappUrl),
                          _socialIconButton('YouTube', Icons.play_circle_fill, Colors.redAccent, _youtubeUrl),
                          _socialIconButton('Facebook', Icons.facebook, Colors.blue, _facebookUrl),
                          _socialIconButton('Instagram', Icons.camera_alt, Colors.pinkAccent, _instagramUrl),
                          _socialIconButton('TikTok', Icons.music_note, Colors.cyanAccent, _tiktokUrl),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 36, color: Colors.white24),
          const Text(
            '© 2026 Pakistan Computer Science Academy (PCSA). All rights reserved. | Built for Pakistani CS Students.',
            style: TextStyle(fontSize: 11, color: Colors.white54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _footerLink(BuildContext context, String label, String route) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Text(
          '• $label',
          style: const TextStyle(color: Colors.white70, fontSize: 12, decoration: TextDecoration.underline),
        ),
      ),
    );
  }

  Widget _socialIconButton(String label, IconData icon, Color color, String url) {
    return InkWell(
      onTap: () => _launchUrl(url),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
