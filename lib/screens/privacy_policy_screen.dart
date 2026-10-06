import 'package:flutter/material.dart';
import '../widgets/app_footer_widget.dart';

/// Public Privacy Policy & Student Data Protection Compliance Screen (/privacy).
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy & Student Data Protection'),
        backgroundColor: const Color(0xFF004D26),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PCSA Privacy Policy & Student Data Protection Notice',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Effective Date: January 2026 | Compliant with Google Play Developer Policies & Student Data Protection Standards',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const Divider(height: 32),

                    const Text(
                      '1. Commitment to Student Privacy',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Pakistan Computer Science Academy (PCSA) is committed to protecting the privacy and academic data of secondary (Matric 9th/10th) and higher secondary (Intermediate 11th/12th) students across Pakistani educational boards.',
                      style: TextStyle(fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      '2. Information We Collect',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '• Student Identity: Full Name, Email Address, and WhatsApp Mobile Number provided during registration.\n'
                      '• Academic Profile: Selected Educational Board (FBISE, STBB, etc.) and Class Grade.\n'
                      '• Transaction Records: Manual EasyPaisa/HBL payment Transaction IDs (TIDs) submitted for pass activation.\n'
                      '• Device Security: Single-device active session ID to prevent account credential sharing.',
                      style: TextStyle(fontSize: 13, height: 1.6),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      '3. Zero Third-Party Data Selling or Ad Tracking',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'PCSA strictly does NOT sell, lease, trade, or share student personal information or mobile numbers with third-party advertisers or data brokers. All collected data is used exclusively to deliver educational services, verify course enrollments, and stamp dynamic anti-piracy watermarks on downloadable study materials.',
                      style: TextStyle(fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      '4. Security & Encryption Standards',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'All user profile data and Firestore database streams are secured with Google Cloud Firebase enterprise encryption in transit and at rest. Access control is strictly guarded using least-privilege security rules.',
                      style: TextStyle(fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      '5. Contact Institutional Privacy Officer',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'If you have questions regarding this privacy policy or wish to request data deletion, please contact our support desk:\n'
                      '• Support Email: pcsacademy.pk@gmail.com\n'
                      '• WhatsApp Helpline: +92 333 6366291',
                      style: TextStyle(fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Footer
            const AppFooterWidget(),
          ],
        ),
      ),
    );
  }
}
