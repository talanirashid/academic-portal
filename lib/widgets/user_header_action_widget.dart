import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../screens/student_auth_dialog.dart';

/// Reactive Header Action Widget displaying Login/Register or Live User Session Avatar, Name, and Admin Badge.
class UserHeaderActionWidget extends StatelessWidget {
  final VoidCallback? onOpenAuthModal;

  const UserHeaderActionWidget({super.key, this.onOpenAuthModal});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        final User? user = authSnapshot.data;

        // 1. GUEST STATE (Not Logged In or Anonymous Session)
        if (user == null || user.isAnonymous) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.login, size: 16),
                label: const Text('Login'),
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
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white70),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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
                  foregroundColor: const Color(0xFF004D26),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                child: const Text('Register'),
              ),
            ],
          );
        }

        // 2. AUTHENTICATED STATE -> Stream Firestore profile for live role/name changes
        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
          builder: (context, profileSnapshot) {
            String displayName = user.displayName ?? (user.email?.split('@').first ?? 'Student');
            String role = 'student';
            String? photoUrl = user.photoURL;

            if (profileSnapshot.hasData && profileSnapshot.data != null && profileSnapshot.data!.exists) {
              final data = profileSnapshot.data!.data();
              if (data != null) {
                displayName = data['displayName'] as String? ?? displayName;
                role = (data['role'] as String? ?? 'student').toLowerCase();
                if (data['photoUrl'] != null && (data['photoUrl'] as String).isNotEmpty) {
                  photoUrl = data['photoUrl'] as String;
                }
              }
            }

            final bool isAdmin = (role == 'admin');

            return PopupMenuButton<String>(
              tooltip: 'Account Menu',
              offset: const Offset(0, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isAdmin ? Colors.amber[400]! : Colors.white24,
                    width: isAdmin ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Profile Photo / Initials Avatar
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: isAdmin ? Colors.amber[800] : Colors.indigo[700],
                      backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                          ? NetworkImage(photoUrl)
                          : null,
                      child: (photoUrl == null || photoUrl.isEmpty)
                          ? Text(
                              displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            )
                          : null,
                    ),
                    const SizedBox(width: 8),

                    // Name & Badges
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 140),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          if (isAdmin)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0.5),
                              decoration: BoxDecoration(
                                color: Colors.amber[700],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'ADMIN',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            )
                          else
                            Text(
                              user.email ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 10.5),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_drop_down, color: Colors.white70, size: 20),
                  ],
                ),
              ),
              onSelected: (action) async {
                switch (action) {
                  case 'admin_console':
                    Navigator.pushNamed(context, '/admin');
                    break;
                  case 'profile':
                    Navigator.pushNamed(context, '/profile');
                    break;
                  case 'logout':
                    await AuthService.signOutWeb(context);
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  enabled: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      Text(
                        user.email ?? '',
                        style: const TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                if (isAdmin)
                  const PopupMenuItem(
                    value: 'admin_console',
                    child: Row(
                      children: [
                        Icon(Icons.admin_panel_settings, color: Colors.redAccent, size: 20),
                        SizedBox(width: 10),
                        Text('Admin Console', style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'profile',
                  child: Row(
                    children: [
                      Icon(Icons.badge_outlined, color: Colors.indigo, size: 20),
                      SizedBox(width: 10),
                      Text('My Passes & Profile'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red, size: 20),
                      SizedBox(width: 10),
                      Text('Sign Out', style: TextStyle(color: Colors.red)),
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
