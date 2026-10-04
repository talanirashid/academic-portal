import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Professional Academic Footer Component for PCSA Web Portal.
class AppFooterWidget extends StatelessWidget {
  const AppFooterWidget({super.key});

  static const String _whatsappCommunityUrl =
      'https://whatsapp.com/channel/0029Va9PCSA';

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
                        'Conceptual, Rigorous & High-Yield Learning Materials for FBISE, Sindh Board, and BIEK Karachi.',
                        style: TextStyle(fontSize: 12, color: Colors.white60, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),

                // Column 2: Quick Links
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Quick Navigation', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 14)),
                      const SizedBox(height: 8),
                      _footerLink(context, 'FBISE Solved Exercises', '/solved-exercises'),
                      _footerLink(context, 'Solved Board Past Papers', '/past-papers'),
                      _footerLink(context, 'Exam Night Cheat Sheet', '/cheat-sheet'),
                      _footerLink(context, 'Manual Payment Verification', '/payment'),
                      _footerLink(context, 'Admin Upload Console', '/admin'),
                    ],
                  ),
                ),
                const SizedBox(width: 24),

                // Column 3: Payment Accounts & Community
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Official Payment Gateways', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 14)),
                      const SizedBox(height: 8),
                      const Text('• EasyPaisa Title: Muhammad Rashid\n  Number: 03123656361', style: TextStyle(fontSize: 12, color: Colors.white70)),
                      const SizedBox(height: 6),
                      const Text('• HBL Bank Title: Muhammad Rashid\n  Account: 00717918821503', style: TextStyle(fontSize: 12, color: Colors.white70)),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () => _launchUrl(_whatsappCommunityUrl),
                        child: const Row(
                          children: [
                            Icon(Icons.chat, color: Color(0xFF25D366), size: 18),
                            SizedBox(width: 6),
                            Text('Join WhatsApp Channel', style: TextStyle(color: Color(0xFF25D366), fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
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
}
