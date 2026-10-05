import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';
import '../services/auth_service.dart';
import '../services/payment_service.dart';
import 'admin_exam_session_manager.dart';

/// State-of-the-Art PCSA Command Center (Academic Management Hub).
class CommandCenterScreen extends StatefulWidget {
  const CommandCenterScreen({super.key});

  @override
  State<CommandCenterScreen> createState() => _CommandCenterScreenState();
}

class _CommandCenterScreenState extends State<CommandCenterScreen> with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final PaymentService _paymentService = PaymentService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TabController _tabController;

  // Module 1 Search & Filter
  String _paymentSearchQuery = '';
  String _paymentStatusFilter = 'pending'; // 'pending', 'approved', 'rejected'

  // Module 2 Publisher Form Fields
  String _selectedBoardId = 'biek_karachi';
  String _selectedClassId = '11th';
  final _courseTitleController = TextEditingController();
  final _instructorController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isPublishing = false;

  // Module 3 Directory Search
  String _studentSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _courseTitleController.dispose();
    _instructorController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _publishCourse() async {
    if (_courseTitleController.text.trim().isEmpty) return;

    setState(() => _isPublishing = true);

    try {
      final board = AcademicBoard.findById(_selectedBoardId);
      final courseId = 'course_${_selectedBoardId}_$_selectedClassId';

      final newCourse = ComprehensiveCourse(
        courseId: courseId,
        boardId: board.id,
        curriculumStream: board.stream.name,
        targetClass: _selectedClassId,
        subject: 'Computer Science',
        courseTitle: _courseTitleController.text.trim(),
        instructorName: _instructorController.text.trim().isNotEmpty ? _instructorController.text.trim() : 'PCSA Faculty',
        description: _descriptionController.text.trim(),
        chapters: [
          ChapterItem(
            chapterId: 'chap_1',
            chapterNumber: 1,
            chapterTitle: 'Unit 1: Overview of Computer Systems & Architecture',
            description: 'Core hardware, software hierarchy, processing cycles and system buses.',
            keyLearningOutcomes: ['Understand Von Neumann Architecture', 'Differentiate System Bus vs Expansion Bus'],
            lectures: [
              SubLecture(id: 'lec_1', title: 'Part 1: Theoretical Concepts & Foundation', videoUrl: 'M576WGiDBdQ', durationMinutes: '20m'),
              SubLecture(id: 'lec_2', title: 'Part 2: Bus Architecture & Hardware Tracing', videoUrl: '3QhU9jd03a0', durationMinutes: '18m'),
              SubLecture(id: 'lec_3', title: 'Part 3: Chapter Exercise & Solved SLO MCQs', videoUrl: 'Z5JC9Ve1sfA', durationMinutes: '25m', isExerciseReview: true),
            ],
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('curriculums').doc(board.stream.name).collection('courses').doc(courseId).set(newCourse.toMap(), SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Course "${newCourse.courseTitle}" published successfully!'),
            backgroundColor: const Color(0xFF006633),
          ),
        );
        _courseTitleController.clear();
        _descriptionController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Publishing error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isPublishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel?>(
      stream: _authService.getUserModelStream(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final bool isAdmin = user?.isAdmin == true;

        if (!isAdmin) {
          return Scaffold(
            appBar: AppBar(title: const Text('Access Denied'), backgroundColor: Colors.red[800], foregroundColor: Colors.white),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.gavel, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Command Center Restricted to Admin Role', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Please sign in with administrator credentials.', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Row(
              children: [
                Icon(Icons.dashboard_customize, color: Colors.amber),
                SizedBox(width: 10),
                Text('PCSA Command Center | Institutional Hub'),
              ],
            ),
            backgroundColor: const Color(0xFF004D26),
            foregroundColor: Colors.white,
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.amber,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.amber,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: const [
                Tab(icon: Icon(Icons.verified_user), text: '1. Payment Verification'),
                Tab(icon: Icon(Icons.publish), text: '2. Course Publisher'),
                Tab(icon: Icon(Icons.people), text: '3. Student Directory'),
                Tab(icon: Icon(Icons.analytics), text: '4. Regional Analytics'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              // MODULE 1: Student Payment Verification Pipeline
              _buildModule1PaymentVerification(),

              // MODULE 2: Curriculum & Course Publisher
              _buildModule2CoursePublisher(),

              // MODULE 3: Student Directory & Active Passes
              _buildModule3StudentDirectory(),

              // MODULE 4: Board Analytics & Regional Filtering
              _buildModule4RegionalAnalytics(),
            ],
          ),
        );
      },
    );
  }

  // MODULE 1: Fast Approval Pipeline
  Widget _buildModule1PaymentVerification() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminExamSessionManager(),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Student Payment Requests Queue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF004D26))),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('Pending'),
                    selected: _paymentStatusFilter == 'pending',
                    selectedColor: const Color(0xFF006633),
                    labelStyle: TextStyle(color: _paymentStatusFilter == 'pending' ? Colors.white : Colors.black87),
                    onSelected: (_) => setState(() => _paymentStatusFilter = 'pending'),
                  ),
                  const SizedBox(width: 6),
                  ChoiceChip(
                    label: const Text('Approved'),
                    selected: _paymentStatusFilter == 'approved',
                    selectedColor: const Color(0xFF006633),
                    labelStyle: TextStyle(color: _paymentStatusFilter == 'approved' ? Colors.white : Colors.black87),
                    onSelected: (_) => setState(() => _paymentStatusFilter = 'approved'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Search Field
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search by Student Name, Email or TRX ID...',
              prefixIcon: Icon(Icons.search, color: Color(0xFF006633)),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onChanged: (val) => setState(() => _paymentSearchQuery = val.trim().toLowerCase()),
          ),
          const SizedBox(height: 12),

          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _firestore.collection('payment_requests').where('status', isEqualTo: _paymentStatusFilter).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF006633)));
              }

              var docs = snapshot.data?.docs ?? [];
              var list = docs.map((d) => PaymentRequest.fromMap(d.data(), d.id)).toList();

              if (_paymentSearchQuery.isNotEmpty) {
                list = list.where((r) => r.studentName.toLowerCase().contains(_paymentSearchQuery) || r.studentEmail.toLowerCase().contains(_paymentSearchQuery) || r.transactionId.toLowerCase().contains(_paymentSearchQuery)).toList();
              }

              if (list.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: Text('No matching payment verification requests.', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final req = list[index];
                  final isRenewal = req.courseId.contains('class_promotion');
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text('${req.studentName} (${req.studentEmail})', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Plan: ${req.courseTitle} • Gateway: ${req.gateway} • TRX: ${req.transactionId}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Chip(
                            backgroundColor: isRenewal ? Colors.amber[100] : const Color(0xFF004D26),
                            label: Text(isRenewal ? 'RENEWAL' : 'NEW', style: TextStyle(color: isRenewal ? const Color(0xFF004D26) : Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                          if (_paymentStatusFilter == 'pending') ...[
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF006633), foregroundColor: Colors.white),
                              onPressed: () async {
                                await _paymentService.approvePaymentRequest(req);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Approved ${req.studentName}!'), backgroundColor: const Color(0xFF006633)));
                                }
                              },
                              child: const Text('Approve Pass'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // MODULE 2: Cascading Board & Class Publisher
  Widget _buildModule2CoursePublisher() {
    final currentBoard = AcademicBoard.findById(_selectedBoardId);
    final permittedClasses = currentBoard.permittedClasses;

    // Auto-adjust selected class if current choice is not in permitted list
    if (!permittedClasses.any((c) => c.id == _selectedClassId)) {
      _selectedClassId = permittedClasses.first.id;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Curriculum & Chapter Publisher Form', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF004D26))),
              const SizedBox(height: 16),

              // 1. Board Selector
              DropdownButtonFormField<String>(
                initialValue: _selectedBoardId,
                decoration: const InputDecoration(labelText: 'Target Academic Board Authority', border: OutlineInputBorder()),
                items: AcademicBoard.registry.map((b) => DropdownMenuItem(value: b.id, child: Text('${b.shortCode} - ${b.fullName}'))).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedBoardId = val);
                },
              ),
              const SizedBox(height: 12),

              // 2. Cascading Class Selector (Restricted to Board Permitted Classes)
              DropdownButtonFormField<String>(
                key: ValueKey(_selectedBoardId), // Rebinds when board changes
                initialValue: _selectedClassId,
                decoration: InputDecoration(
                  labelText: 'Target Class Grade (${currentBoard.shortCode} Stream)',
                  border: const OutlineInputBorder(),
                  helperText: 'Filtered permitted classes for ${currentBoard.shortCode}',
                ),
                items: permittedClasses.map((c) => DropdownMenuItem(value: c.id, child: Text(c.label))).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedClassId = val);
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _courseTitleController,
                decoration: const InputDecoration(labelText: 'Course Title', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _instructorController,
                decoration: const InputDecoration(labelText: 'Instructor Name', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Course Overview / Description', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF006633), foregroundColor: Colors.white),
                  onPressed: _isPublishing ? null : _publishCourse,
                  icon: const Icon(Icons.publish),
                  label: Text(_isPublishing ? 'Publishing...' : 'Publish Course & Sub-Divided Chapters', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // MODULE 3: Student Directory
  Widget _buildModule3StudentDirectory() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search Directory by Name or Email...',
              prefixIcon: Icon(Icons.search, color: Color(0xFF006633)),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onChanged: (val) => setState(() => _studentSearchQuery = val.trim().toLowerCase()),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _firestore.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF006633)));
                }

                var docs = snapshot.data?.docs ?? [];
                if (_studentSearchQuery.isNotEmpty) {
                  docs = docs.where((d) {
                    final data = d.data();
                    final name = (data['displayName'] as String? ?? '').toLowerCase();
                    final email = (data['email'] as String? ?? '').toLowerCase();
                    return name.contains(_studentSearchQuery) || email.contains(_studentSearchQuery);
                  }).toList();
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data();
                    final uid = docs[index].id;
                    final name = data['displayName'] as String? ?? 'Student';
                    final email = data['email'] as String? ?? '';
                    final role = data['role'] as String? ?? 'student';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: role == 'admin' ? Colors.amber[800] : const Color(0xFF006633),
                          child: Text(name.isNotEmpty ? name[0].toUpperCase() : 'S', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        title: Text('$name ($role)'),
                        subtitle: Text('$email • UID: ${uid.substring(0, 8)}'),
                        trailing: Chip(
                          backgroundColor: role == 'admin' ? Colors.amber[100] : Colors.grey[200],
                          label: Text(role.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: role == 'admin' ? const Color(0xFF004D26) : Colors.black87)),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // MODULE 4: Regional Analytics
  Widget _buildModule4RegionalAnalytics() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Regional Board Analytics & Revenue Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF004D26))),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildMetricCard('FBISE Federal Board', 'PKR 145,000', '145 Enrollments', const Color(0xFF006633))),
              const SizedBox(width: 12),
              Expanded(child: _buildMetricCard('STBB Sindh Unified', 'PKR 198,000', '198 Enrollments', Colors.purple[800]!)),
              const SizedBox(width: 12),
              Expanded(child: _buildMetricCard('BIEK Karachi Inter', 'PKR 112,000', '112 Enrollments', Colors.amber[900]!)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String revenue, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color)),
          const SizedBox(height: 6),
          Text(revenue, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          Text(count, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}
