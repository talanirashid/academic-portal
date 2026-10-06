import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Professional Academic Footer Component for PCSA Web Portal.
class AppFooterWidget extends StatelessWidget {
  const AppFooterWidget({super.key});

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
                // Column 1: Brand & Institutional Contact
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              AppConstants.appLogo,
                              height: 36,
                              width: 36,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.amber,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.shield, color: Color(0xFF004D26), size: 24),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            AppConstants.appShortTitle,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        AppConstants.appTitle,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.amber),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '“Bridging Foundational Concepts with Modern Computing Excellence.”',
                        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.white70),
                      ),
                      const SizedBox(height: 12),

                      // Verified Contact Handlers
                      InkWell(
                        onTap: () => AppConstants.sendSupportEmail(),
                        child: const Row(
                          children: [
                            Icon(Icons.email, color: Colors.amber, size: 16),
                            SizedBox(width: 6),
                            Text(
                              AppConstants.officialEmail,
                              style: TextStyle(color: Colors.white70, fontSize: 12, decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: () => AppConstants.openWhatsAppChat(),
                        child: const Row(
                          children: [
                            Icon(Icons.chat, color: Color(0xFF25D366), size: 16),
                            SizedBox(width: 6),
                            Text(
                              '+92 333 6366291 (Helpline)',
                              style: TextStyle(color: Color(0xFF25D366), fontWeight: FontWeight.bold, fontSize: 12, decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
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
                      _footerLink(context, 'Privacy & Student Policy', '/privacy'),
                    ],
                  ),
                ),
                const SizedBox(width: 24),

                // Column 3: Unified Social Media Grid (@PCSAcademypk)
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Official Community @PCSAcademypk', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 14)),
                      const SizedBox(height: 8),
                      const Text(
                        'Join our official channels for daily board MCQs, syllabus updates, and live exam guidance:',
                        style: TextStyle(fontSize: 12, color: Colors.white70, height: 1.3),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _socialIconButton('WhatsApp', Icons.chat, const Color(0xFF25D366), AppConstants.whatsappChannel),
                          _socialIconButton('YouTube', Icons.play_circle_fill, Colors.redAccent, AppConstants.youtube),
                          _socialIconButton('Facebook', Icons.facebook, Colors.blue, AppConstants.facebook),
                          _socialIconButton('Instagram', Icons.camera_alt, Colors.pinkAccent, AppConstants.instagram),
                          _socialIconButton('TikTok', Icons.music_note, Colors.cyanAccent, AppConstants.tiktok),
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
      onTap: () => AppConstants.launchLink(url),
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
