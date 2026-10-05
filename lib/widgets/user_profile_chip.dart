import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../screens/student_auth_dialog.dart';

/// Modern User Profile Chip for Top App Bar Actions.
class UserProfileHeaderChip extends StatelessWidget {
  final VoidCallback? onOpenAuthModal;

  const UserProfileHeaderChip({super.key, this.onOpenAuthModal});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnap) {
        final user = authSnap.data;

        // If not logged in -> Show Sign In / Get Started buttons
        if (user == null || user.isAnonymous) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  if (onOpenAuthModal != null) {
                    onOpenAuthModal!();
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => const StudentAuthDialog(),
                    );
                  }
                },
                icon: const Icon(Icons.login, size: 16),
                label: const Text('Sign In'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white60),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  if (onOpenAuthModal != null) {
                    onOpenAuthModal!();
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => const StudentAuthDialog(),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  foregroundColor: Colors.black,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: const Text('Get Started'),
              ),
            ],
          );
        }

        // Fetch User profile from Firestore with smooth fallback to FirebaseAuth cache
        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
          builder: (context, profileSnap) {
            String name = user.displayName ?? (user.email?.split('@').first ?? 'Student');
            String email = user.email ?? '';
            String role = 'student';
            String? photoUrl = user.photoURL;

            if (profileSnap.hasData && profileSnap.data != null && profileSnap.data!.exists) {
              final data = profileSnap.data!.data();
              if (data != null) {
                name = data['displayName'] as String? ?? name;
                role = (data['role'] as String? ?? 'student').toLowerCase();
                photoUrl = data['photoUrl'] as String? ?? photoUrl;
              }
            }

            final bool isAdmin = (role == 'admin');

            return PopupMenuButton<String>(
              tooltip: 'Account Settings',
              offset: const Offset(0, 52),
              color: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isAdmin ? Colors.amber[400]! : Colors.white24,
                      width: isAdmin ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // User Avatar with fallback Initials
                      CircleAvatar(
                        radius: 17,
                        backgroundColor: isAdmin ? Colors.amber[800] : Colors.indigo[600],
                        backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                            ? NetworkImage(photoUrl)
                            : null,
                        child: (photoUrl == null || photoUrl.isEmpty)
                            ? Text(
                                name.isNotEmpty ? name[0].toUpperCase() : 'U',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 9),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 130),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            if (isAdmin)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: Colors.amber[400],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'ADMIN',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              )
                            else
                              Text(
                                email,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.75),
                                  fontSize: 10.5,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down, color: Colors.white70, size: 18),
                    ],
                  ),
                ),
              ),
              onSelected: (val) async {
                switch (val) {
                  case 'profile':
                    Navigator.pushNamed(context, '/profile');
                    break;
                  case 'admin':
                    Navigator.pushNamed(context, '/command-center');
                    break;
                  case 'logout':
                    await AuthService.signOutWeb(context);
                    break;
                }
              },
              itemBuilder: (context) => [
                // Top Header Card inside Dropdown
                PopupMenuItem(
                  enabled: false,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          email,
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
                const PopupMenuDivider(),
                if (isAdmin)
                  const PopupMenuItem(
                    value: 'admin',
                    child: Row(
                      children: [
                        Icon(Icons.dashboard_customize, color: Colors.amber, size: 20),
                        SizedBox(width: 12),
                        Text('Command Center', style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'profile',
                  child: Row(
                    children: [
                      Icon(Icons.badge_outlined, color: Colors.indigo, size: 20),
                      SizedBox(width: 12),
                      Text('My Profile & Active Passes'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.redAccent, size: 20),
                      SizedBox(width: 12),
                      Text('Sign Out', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
