import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import '../../auth/models/student_profile_model.dart';
import '../../auth/repositories/auth_repository.dart';

/// Full Student Profile & Avatar Hub Screen (/profile).
class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  final AuthRepository _repository = AuthRepository();
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _collegeController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();

  bool _isLoading = false;
  bool _isUploadingAvatar = false;
  StudentProfileModel? _currentProfile;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _collegeController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final profile = StudentProfileModel.fromFirestore(doc);
        setState(() {
          _currentProfile = profile;
          _fullNameController.text = profile.fullName;
          _collegeController.text = profile.collegeName ?? '';
          _cityController.text = profile.city ?? '';
          _phoneController.text = profile.phoneNumber ?? '';
          _bioController.text = profile.academicBio ?? '';
        });
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }
  }

  Future<void> _pickAndUploadAvatar() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    final Uint8List? bytes = result.files.first.bytes;
    if (bytes == null) return;

    setState(() => _isUploadingAvatar = true);

    try {
      await _repository.uploadProfilePicture(bytes);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Avatar uploaded to PCSA Drive Vault successfully!'),
            backgroundColor: Color(0xFF006633),
          ),
        );
        _loadProfileData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Avatar Upload Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploadingAvatar = false);
    }
  }

  Future<void> _saveChanges() async {
    if (_currentProfile == null) return;

    setState(() => _isLoading = true);

    try {
      final updated = _currentProfile!.copyWith(
        fullName: _fullNameController.text.trim(),
        collegeName: _collegeController.text.trim(),
        city: _cityController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        academicBio: _bioController.text.trim(),
      );

      await _repository.updateStudentProfile(updated);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Color(0xFF006633),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Save Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.redAccent),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.redAccent, size: 24),
            SizedBox(width: 8),
            Text('Delete Account & Data', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete your account? This action permanently wipes your profile, enrolled pass history, and saved progress from our servers.',
          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await _repository.deleteStudentAccount();
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Account deleted successfully.')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Deletion Error: ${e.toString()}')),
                  );
                }
              }
            },
            child: const Text('Confirm Permanent Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final initials = (_currentProfile?.fullName.isNotEmpty == true)
        ? _currentProfile!.fullName[0].toUpperCase()
        : 'S';

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Student Profile Hub', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar & Header Section
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: const Color(0xFF006633),
                          backgroundImage: (_currentProfile?.displayAvatarUrl.isNotEmpty == true)
                              ? NetworkImage(_currentProfile!.displayAvatarUrl)
                              : null,
                          child: (_currentProfile?.displayAvatarUrl.isEmpty ?? true)
                              ? Text(initials, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white))
                              : null,
                        ),
                        if (_isUploadingAvatar)
                          const Positioned.fill(
                            child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: CircularProgressIndicator(color: Colors.amberAccent),
                            ),
                          ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: _isUploadingAvatar ? null : _pickAndUploadAvatar,
                            child: const CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.amber,
                              child: Icon(Icons.camera_alt, size: 16, color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(_currentProfile?.fullName ?? 'Student Name', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text(user?.email ?? '', style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Chip(
                          backgroundColor: const Color(0xFF004D26),
                          label: Text(_currentProfile?.boardStream.toUpperCase() ?? 'STBB', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                        ),
                        const SizedBox(width: 6),
                        Chip(
                          backgroundColor: Colors.amber[800],
                          label: Text(_currentProfile?.targetClass.toUpperCase() ?? 'CLASS_11', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text('Post-Login Profile Enrichment', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 12),

              // Full Name
              TextFormField(
                controller: _fullNameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Full Student Name',
                  labelStyle: TextStyle(color: Color(0xFF94A3B8)),
                  prefixIcon: Icon(Icons.person, color: Color(0xFF38BDF8)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF38BDF8))),
                ),
              ),
              const SizedBox(height: 12),

              // College / School Name
              TextFormField(
                controller: _collegeController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'College / School Name',
                  labelStyle: TextStyle(color: Color(0xFF94A3B8)),
                  prefixIcon: Icon(Icons.account_balance, color: Color(0xFF38BDF8)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF38BDF8))),
                ),
              ),
              const SizedBox(height: 12),

              // City / District
              TextFormField(
                controller: _cityController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'City / District (e.g. Karachi, Islamabad)',
                  labelStyle: TextStyle(color: Color(0xFF94A3B8)),
                  prefixIcon: Icon(Icons.location_city, color: Color(0xFF38BDF8)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF38BDF8))),
                ),
              ),
              const SizedBox(height: 12),

              // Phone Number
              TextFormField(
                controller: _phoneController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'WhatsApp Mobile Number (For critical exam alerts)',
                  labelStyle: TextStyle(color: Color(0xFF94A3B8)),
                  prefixIcon: Icon(Icons.phone, color: Color(0xFF38BDF8)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF38BDF8))),
                ),
              ),
              const SizedBox(height: 12),

              // Academic Goal / Bio
              TextFormField(
                controller: _bioController,
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Academic Target / Bio',
                  hintText: 'Targeting 90%+ in Board Computer Science',
                  labelStyle: TextStyle(color: Color(0xFF94A3B8)),
                  prefixIcon: Icon(Icons.flag, color: Color(0xFF38BDF8)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF38BDF8))),
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF006633), foregroundColor: Colors.white),
                  onPressed: _isLoading ? null : _saveChanges,
                  icon: const Icon(Icons.save),
                  label: Text(_isLoading ? 'Saving...' : 'Save Profile Changes', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Color(0xFF334155))),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        if (context.mounted) Navigator.pop(context);
                      },
                      icon: const Icon(Icons.logout, size: 16),
                      label: const Text('Sign Out'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent, side: const BorderSide(color: Colors.redAccent)),
                      onPressed: _confirmDeleteAccount,
                      icon: const Icon(Icons.delete_forever, size: 16),
                      label: const Text('Delete Account'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
