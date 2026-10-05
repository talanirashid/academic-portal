import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/models.dart';
import '../services/auth_service.dart';
import '../services/mock_data_service.dart';
import '../widgets/app_footer_widget.dart';
import '../widgets/brand_logo.dart';
import '../widgets/cs_practical_lab_section.dart';
import '../widgets/exam_countdown_widget.dart';
import '../widgets/student_badges_widget.dart';
import '../widgets/user_profile_chip.dart';
import 'course_detail_screen.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();

  String _selectedBoard = 'Federal Board (FBISE - NBF Edition)';
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isSeeding = false;

  final List<String> _boards = [
    'Federal Board (FBISE - NBF Edition)',
    'Sindh Textbook Board (STBB Unified)',
  ];

  final List<String> _categories = [
    'All',
    'Class 9th (SSC-I)',
    'Class 10th (SSC-II)',
    'FSc Pre-Medical',
    'FSc Pre-Engineering',
    'ICS / CS',
  ];

  static const String _apkDownloadUrl =
      'https://github.com/talanirashid/academic-portal/releases/download/v1.0.0/PCSA-Academic-Portal-v1.0.0-arm64.apk';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open link: $url')),
        );
      }
    }
  }

  Future<void> _handleSeedCourses() async {
    setState(() => _isSeeding = true);
    await MockDataService.forceSeedDatabase();
    setState(() => _isSeeding = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sample courses and subcollection modules seeded successfully!'),
          backgroundColor: Color(0xFF006633),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount = 1;
    if (screenWidth >= 1100) {
      crossAxisCount = 3;
    } else if (screenWidth >= 600) {
      crossAxisCount = 2;
    }

    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: PCSABrandLogo(
          height: 36,
          showText: !isMobile,
          onTap: () {},
        ),
        backgroundColor: const Color(0xFF004D26),
        elevation: 2,
        actions: const [
          // Sleek User Profile Chip with Live Session & Role State
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: UserProfileHeaderChip(),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Target Board Exam Countdown Widget Header
                const RepaintBoundary(child: ExamCountdownWidget()),

                // Web Direct APK Download Banner (Visible only on Web)
                if (kIsWeb)
                  Container(
                    width: double.infinity,
                    color: const Color(0xFF004D26),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.android, color: Colors.amber, size: 20),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            '📱 Download Android App (.apk) for faster on-the-go study & offline notes!',
                            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[700],
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () => _launchUrl(_apkDownloadUrl),
                          child: const Text('Download APK'),
                        ),
                      ],
                    ),
                  ),

                // Top Header Banner with Board Architecture & Search Field
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF006633).withValues(alpha: 0.08),
                    border: const Border(
                      bottom: BorderSide(color: Color(0x22006633)),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pakistan Computer Science Academy',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        '“Bridging Foundational Concepts with Modern Computing Excellence.”',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF006633), fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 12),

                      // Board Architecture Selector
                      Row(
                        children: [
                          const Text('Board Syllabus: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF004D26))),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _selectedBoard,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                border: OutlineInputBorder(),
                              ),
                              items: _boards.map((b) => DropdownMenuItem(value: b, child: Text(b, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)))).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedBoard = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Search Bar Input
                      TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val.trim().toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search courses, subjects, instructors, or chapters...',
                          prefixIcon: const Icon(Icons.search, color: Color(0xFF006633)),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Color(0xFF006633)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: const Color(0xFF006633).withValues(alpha: 0.3)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Color(0xFF006633), width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Separated Class Streams Chips & Quick Tools
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ..._categories.map((category) {
                              final isSelected = _selectedCategory == category;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ChoiceChip(
                                  label: Text(category),
                                  selected: isSelected,
                                  selectedColor: const Color(0xFF006633),
                                  labelStyle: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black87,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _selectedCategory = category;
                                      });
                                    }
                                  },
                                ),
                              );
                            }),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ActionChip(
                                avatar: const Icon(Icons.quiz, size: 16, color: Colors.white),
                                backgroundColor: const Color(0xFF006633),
                                label: const Text('FBISE Solved Exercises & Quizzes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                onPressed: () => Navigator.pushNamed(context, '/solved-exercises'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ActionChip(
                                avatar: const Icon(Icons.menu_book, size: 16, color: Colors.white),
                                backgroundColor: const Color(0xFF004D26),
                                label: const Text('Exam Cheat Sheet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                onPressed: () => Navigator.pushNamed(context, '/cheat-sheet'),
                              ),
                            ),
                            ActionChip(
                              avatar: const Icon(Icons.description, size: 16, color: Colors.white),
                              backgroundColor: const Color(0xFF004D26),
                              label: const Text('Solved Past Papers', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              onPressed: () => Navigator.pushNamed(context, '/past-papers'),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Gamified Student Badges
                      const RepaintBoundary(child: StudentBadgesWidget()),
                      const SizedBox(height: 12),

                      // Rebranded CS Practical & Interactive Lab Section
                      const RepaintBoundary(child: CsPracticalLabSection()),
                      const SizedBox(height: 16),

                      const Text(
                        'Course Catalog & Curriculum Chapters',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Courses Stream Section
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('courses').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting || _isSeeding) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF006633)),
                  ),
                );
              }

              if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: _buildErrorOrEmptyState(
                    context,
                    title: 'Error loading courses',
                    message: snapshot.error.toString(),
                  ),
                );
              }

              final docs = snapshot.data?.docs ?? [];
              if (docs.isEmpty) {
                return SliverToBoxAdapter(
                  child: _buildErrorOrEmptyState(
                    context,
                    title: 'No Courses Available',
                    message:
                        'No courses found in the selected category. Click "Seed Sample Catalog" below to populate Firestore with sample courses.',
                    showSeedOption: true,
                  ),
                );
              }

              return FutureBuilder<List<Course>>(
                future: Future.wait(docs.map((doc) => Course.fromFirestoreWithSubcollections(doc))),
                builder: (context, coursesSnapshot) {
                  if (coursesSnapshot.connectionState == ConnectionState.waiting) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(color: Color(0xFF006633)),
                      ),
                    );
                  }

                  var courses = coursesSnapshot.data ?? [];

                  // Apply Category Filter
                  if (_selectedCategory != 'All') {
                    courses = courses
                        .where((c) =>
                            c.category.contains(_selectedCategory) ||
                            c.grade.contains(_selectedCategory))
                        .toList();
                  }

                  // Apply Real-time Search Query Filter
                  if (_searchQuery.isNotEmpty) {
                    courses = courses.where((c) {
                      final titleMatch = c.title.toLowerCase().contains(_searchQuery);
                      final categoryMatch = c.category.toLowerCase().contains(_searchQuery);
                      final instructorMatch = c.instructor.toLowerCase().contains(_searchQuery);
                      final moduleMatch = c.modules.any((m) =>
                          m.title.toLowerCase().contains(_searchQuery) ||
                          m.description.toLowerCase().contains(_searchQuery));
                      return titleMatch || categoryMatch || instructorMatch || moduleMatch;
                    }).toList();
                  }

                  if (courses.isEmpty) {
                    return SliverToBoxAdapter(
                      child: _buildErrorOrEmptyState(
                        context,
                        title: 'No Matching Courses Found',
                        message: _searchQuery.isNotEmpty
                            ? 'No courses matched "$_searchQuery". Try searching for topics like "Binary", "Logic", or "C++".'
                            : 'No courses match the selected category filter.',
                        showSeedOption: true,
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: crossAxisCount == 1 ? 1.1 : 0.82,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final course = courses[index];
                          return RepaintBoundary(
                            child: _CourseCard(
                              course: course,
                              authService: _authService,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CourseDetailScreen(course: course),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        childCount: courses.length,
                      ),
                    ),
                  );
                },
              );
            },
          ),

          // App Footer Section
          const SliverToBoxAdapter(
            child: AppFooterWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorOrEmptyState(
    BuildContext context, {
    required String title,
    required String message,
    bool showSeedOption = false,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school_outlined, size: 72, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006633),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => setState(() {}),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
                if (showSeedOption) ...[
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF006633),
                    ),
                    onPressed: _handleSeedCourses,
                    icon: const Icon(Icons.cloud_upload_outlined),
                    label: const Text('Seed Sample Catalog'),
                  ),
                ],
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final Course course;
  final AuthService authService;
  final VoidCallback onTap;

  const _CourseCard({
    required this.course,
    required this.authService,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final totalModules = course.modules.isEmpty ? 1 : course.modules.length;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail Image or Header Placeholder
            AspectRatio(
              aspectRatio: 16 / 9,
              child: course.thumbnailUrl.isNotEmpty
                  ? Image.network(
                      course.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Chip & Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          labelStyle: const TextStyle(fontSize: 10, color: Colors.white),
                          backgroundColor: const Color(0xFF006633),
                          label: Text(course.category),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              course.rating > 0 ? course.rating.toStringAsFixed(1) : '4.8',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Course Title
                    Text(
                      course.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Instructor
                    Text(
                      'By ${course.instructor}',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const Spacer(),

                    // Progress Bar Indicator
                    StreamBuilder<List<String>>(
                      stream: authService.getCompletedModulesStream(course.id),
                      builder: (context, progressSnapshot) {
                        final completedList = progressSnapshot.data ?? [];
                        final completedCount = completedList.length;
                        final percent = (completedCount / totalModules).clamp(0.0, 1.0);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '$completedCount of ${course.modules.length} Completed',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF006633)),
                                ),
                                Text(
                                  '${(percent * 100).toInt()}%',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: percent,
                              backgroundColor: Colors.grey[200],
                              color: const Color(0xFF006633),
                              minHeight: 6,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFF004D26),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shield, size: 48, color: Colors.amber),
            SizedBox(height: 4),
            Text(
              'PCSA Portal',
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
