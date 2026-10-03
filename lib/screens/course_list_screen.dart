import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/course_model.dart';
import '../services/auth_service.dart';
import '../services/mock_data_service.dart';
import 'course_detail_screen.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isSeeding = false;

  final List<String> _categories = [
    'All',
    'Matric (9th/10th)',
    'FSc Pre-Medical',
    'FSc Pre-Engineering',
    'ICS / CS',
  ];

  static const String _whatsappCommunityUrl =
      'https://whatsapp.com/channel/0029Va9PCSA';
  static const String _apkDownloadUrl =
      'https://github.com/talanirashid/academic-portal/releases';

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

  void _showAccountModal(BuildContext context) {
    final user = _authService.currentUser;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.account_circle, size: 36, color: Color(0xFF006633)),
                  SizedBox(width: 12),
                  Text(
                    'Student Account Session',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(height: 24),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.person_outline),
                title: Text(user?.displayName ?? 'Guest Student'),
                subtitle: Text(user?.email ?? 'Identifier: ${user?.uid ?? "Offline"}'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF25D366),
                  radius: 18,
                  child: Icon(Icons.chat, color: Colors.white, size: 20),
                ),
                title: const Text(
                  'Join Official WhatsApp Community',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Ask syllabus questions, get past papers & updates'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () {
                  Navigator.pop(context);
                  _launchUrl(_whatsappCommunityUrl);
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.cloud_upload_outlined),
                      label: const Text('Seed Sample Catalog'),
                      onPressed: () {
                        Navigator.pop(context);
                        _handleSeedCourses();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (user == null)
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF006633),
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.login),
                        label: const Text('Guest Login'),
                        onPressed: () async {
                          await _authService.signInAnonymously();
                          if (context.mounted) Navigator.pop(context);
                          setState(() {});
                        },
                      ),
                    )
                  else
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.logout),
                        label: const Text('Sign Out'),
                        onPressed: () async {
                          await _authService.signOut();
                          if (context.mounted) Navigator.pop(context);
                          setState(() {});
                        },
                      ),
                    ),
                ],
              )
            ],
          ),
        );
      },
    );
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
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.amber[700],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shield, color: Color(0xFF004D26), size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              isMobile ? 'PCSA Portal' : 'Pakistan Computer Science Academy',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF004D26),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            tooltip: 'Student Account Session',
            onPressed: () => _showAccountModal(context),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            tooltip: 'About Academy',
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'Pakistan Computer Science Academy',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.shield, size: 40, color: Color(0xFF004D26)),
                children: [
                  const Text(
                    'Pakistan Computer Science Academy (PCSA) provides free, high-yield video lectures, chapter keybooks, board exam notes, and interactive quizzes for FBISE, Sindh Board, and competitive CS examinations.',
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '“Bridging Foundational Concepts with Modern Computing Excellence.”',
                    style: TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF004D26), fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => _launchUrl(_whatsappCommunityUrl),
                    child: const Row(
                      children: [
                        Icon(Icons.chat_bubble, size: 18, color: Color(0xFF25D366)),
                        SizedBox(width: 6),
                        Text(
                          'Join Official WhatsApp Community',
                          style: TextStyle(
                            color: Color(0xFF006633),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
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

          // Top Header Banner with Branding, Taglines & Search Field
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
                const SizedBox(height: 4),
                const Text(
                  'Master Intermediate & Advanced Computing — Conceptual, Rigorous, 100% Free.',
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                ),
                const SizedBox(height: 2),
                const Text(
                  'علم • تحقیق • کمپیوٹنگ | Excellence in Computer Science Education',
                  style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 14),

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

                // Category Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) {
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
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // StreamBuilder fetching from /courses
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('courses').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting || _isSeeding) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF006633)),
                  );
                }

                if (snapshot.hasError) {
                  return _buildErrorOrEmptyState(
                    context,
                    title: 'Error loading courses',
                    message: snapshot.error.toString(),
                  );
                }

                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return _buildErrorOrEmptyState(
                    context,
                    title: 'No Courses Available',
                    message:
                        'No courses found in the selected category. Click "Seed Sample Catalog" below to populate Firestore with sample courses.',
                    showSeedOption: true,
                  );
                }

                return FutureBuilder<List<Course>>(
                  future: Future.wait(docs.map((doc) => Course.fromFirestoreWithSubcollections(doc))),
                  builder: (context, coursesSnapshot) {
                    if (coursesSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Color(0xFF006633)),
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
                      return _buildErrorOrEmptyState(
                        context,
                        title: 'No Matching Courses Found',
                        message: _searchQuery.isNotEmpty
                            ? 'No courses matched "$_searchQuery". Try searching for topics like "Binary", "Logic", or "C++".'
                            : 'No courses match the selected category filter.',
                        showSeedOption: true,
                      );
                    }

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        return GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: crossAxisCount == 1 ? 1.2 : 0.85,
                          ),
                          itemCount: courses.length,
                          itemBuilder: (context, index) {
                            final course = courses[index];
                            return _CourseCard(
                              course: course,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CourseDetailScreen(course: course),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
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
  final VoidCallback onTap;

  const _CourseCard({required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
                    // Modules Count Footer
                    Row(
                      children: [
                        const Icon(Icons.video_library, size: 16, color: Color(0xFF006633)),
                        const SizedBox(width: 6),
                        Text(
                          '${course.modules.length} Modules / Chapters',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
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
