import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../screens/student_auth_dialog.dart';

/// Zero-Trust Authentication Guard Interceptor.
class AuthGuard {
  AuthGuard._();

  /// Runs the callback [onAuthenticated] if student is logged in.
  /// If unauthenticated, displays a polished dark-mode login dialog.
  static Future<void> runWithAuth(
    BuildContext context, {
    required VoidCallback onAuthenticated,
    String? targetPackageId,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    // Check if real authenticated user session exists (not null and not anonymous if needed)
    if (user != null && !user.isAnonymous) {
      onAuthenticated();
      return;
    }

    // Unauthenticated or Anonymous user -> Display Login Modal
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0F172A), // Dark slate
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF334155)),
          ),
          title: const Row(
            children: [
              Icon(Icons.lock_outline, color: Colors.amber, size: 24),
              SizedBox(width: 10),
              Text(
                'Sign In Required',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          content: const Text(
            'Please log in or register to link this course package permanently to your student profile and access keybooks anytime.',
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006633),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                Navigator.pop(dialogContext); // Close warning dialog
                await showDialog(
                  context: context,
                  builder: (_) => const StudentAuthDialog(),
                );

                // After login attempt check session again
                final updatedUser = FirebaseAuth.instance.currentUser;
                if (updatedUser != null && !updatedUser.isAnonymous) {
                  onAuthenticated();
                }
              },
              child: const Text('Sign In / Register', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
