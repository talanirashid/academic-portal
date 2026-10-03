import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Admin Dashboard Screen for managing curriculum content, lecture links, PDF keybooks, and quiz MCQs.
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  final _courseIdController = TextEditingController();
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController(text: 'Computer Science');
  final _gradeController = TextEditingController(text: 'Class 11 / HSSC-I');
  final _instructorController = TextEditingController(text: 'Prof. Tariq Mahmood');
  final _descriptionController = TextEditingController();

  final _moduleTitleController = TextEditingController();
  final _youtubeVideoIdController = TextEditingController();
  final _pdfNotesUrlController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _courseIdController.dispose();
    _titleController.dispose();
    _subjectController.dispose();
    _gradeController.dispose();
    _instructorController.dispose();
    _descriptionController.dispose();
    _moduleTitleController.dispose();
    _youtubeVideoIdController.dispose();
    _pdfNotesUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveCourseAndModule() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final courseId = _courseIdController.text.trim().toLowerCase().replaceAll(' ', '_');
      final courseRef = _firestore.collection('courses').doc(courseId);

      // Save top-level course doc
      await courseRef.set({
        'title': _titleController.text.trim(),
        'subject': _subjectController.text.trim(),
        'category': _subjectController.text.trim(),
        'grade': _gradeController.text.trim(),
        'instructor': _instructorController.text.trim(),
        'description': _descriptionController.text.trim(),
        'rating': 4.9,
        'thumbnailUrl': 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?q=80&w=800',
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Save initial module if provided
      if (_moduleTitleController.text.isNotEmpty) {
        final modRef = courseRef.collection('modules').doc();
        await modRef.set({
          'title': _moduleTitleController.text.trim(),
          'description': 'Chapter video lecture and study notes',
          'youtubeVideoId': _youtubeVideoIdController.text.trim(),
          'pdfNotesUrl': _pdfNotesUrlController.text.trim(),
          'notesPdfUrl': _pdfNotesUrlController.text.trim(),
          'duration': '20:00',
          'orderIndex': 1,
        }, SetOptions(merge: true));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Course and lecture module saved to Firestore!'),
            backgroundColor: Color(0xFF006633),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving content: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Content Upload Panel'),
        backgroundColor: const Color(0xFF004D26),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Publish New Course / Lecture Chapter',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
              ),
              const SizedBox(height: 6),
              const Text(
                'Add courses, YouTube lecture video IDs, and PDF notes directly into Cloud Firestore.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Course ID
              TextFormField(
                controller: _courseIdController,
                decoration: const InputDecoration(
                  labelText: 'Course Document ID (e.g. cs_xi_fbise)',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              // Course Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Course Title',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _subjectController,
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _gradeController,
                      decoration: const InputDecoration(
                        labelText: 'Grade / Target Class',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _instructorController,
                decoration: const InputDecoration(
                  labelText: 'Instructor Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Course Description',
                  border: OutlineInputBorder(),
                ),
              ),

              const Divider(height: 36, thickness: 1),

              const Text(
                'First Chapter / Lecture Details (Optional)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _moduleTitleController,
                decoration: const InputDecoration(
                  labelText: 'Chapter Title (e.g., 01: Overview of Systems)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _youtubeVideoIdController,
                decoration: const InputDecoration(
                  labelText: 'YouTube Video ID (e.g., M576WGiDBdQ)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _pdfNotesUrlController,
                decoration: const InputDecoration(
                  labelText: 'PDF Study Notes URL (Direct PDF Link)',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006633),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _isSaving ? null : _saveCourseAndModule,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.cloud_upload),
                  label: Text(_isSaving ? 'Publishing...' : 'Publish Content to Firestore'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
