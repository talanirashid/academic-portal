import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/models.dart';
import '../services/auth_service.dart';
import '../widgets/syllabus_tracker_widget.dart';

/// Student Profile & Account Management Screen (/profile).
class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendPasswordReset() async {
    final user = _authService.currentUser;
    if (user == null || user.email == null || user.email!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No valid email found for password reset.')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: user.email!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password reset email sent to ${user.email}!'),
            backgroundColor: const Color(0xFF006633),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reset error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Student Profile & Progress'),
        backgroundColor: const Color(0xFF004D26),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<UserModel?>(
        stream: _authService.getUserModelStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF006633)));
          }

          final userModel = snapshot.data;
          final user = _authService.currentUser;

          if (userModel == null && user == null) {
            return const Center(child: Text('Please log in to view your profile.'));
          }

          final referralCode = userModel?.referralCode ?? 'PCSA_${user?.uid.substring(0, 6).toUpperCase() ?? "GUEST"}';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Overview Header Card
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color(0xFF006633),
                            radius: 30,
                            child: Icon(Icons.person, color: Colors.white, size: 36),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userModel?.displayName ?? user?.displayName ?? 'Registered Student',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                                ),
                                Text(
                                  user?.email ?? 'guest@academicportal.pk',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                const SizedBox(height: 4),
                                Chip(
                                  padding: EdgeInsets.zero,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  backgroundColor: userModel?.isPro == true ? Colors.amber[800] : const Color(0xFF004D26),
                                  label: Text(
                                    userModel?.isPro == true ? 'Pro Annual Pass Active' : 'Free Learning Tier',
                                    style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Referral Code & Credits Card
                  Card(
                    color: const Color(0xFF004D26),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('My Referral Code', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
                              Text(referralCode, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1)),
                              const Text('Share with peers for free Pro Pass rewards!', style: TextStyle(color: Colors.white70, fontSize: 10)),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.share, color: Colors.white),
                            tooltip: 'Share Code',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Referral code $referralCode copied to clipboard!'), backgroundColor: const Color(0xFF006633)),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Syllabus Tracker Widget
                  const SyllabusTrackerWidget(),
                  const SizedBox(height: 16),

                  // Password Reset Action
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF006633),
                        side: const BorderSide(color: Color(0xFF006633)),
                      ),
                      onPressed: _sendPasswordReset,
                      icon: const Icon(Icons.lock_reset),
                      label: const Text('Send Password Reset Email', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
