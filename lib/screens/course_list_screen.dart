import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course_model.dart';
import 'course_detail_screen.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Matric (9th/10th)',
    'FSc Pre-Medical',
    'FSc Pre-Engineering',
    'ICS / CS',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive columns logic: 1 column for mobile (<600px), 2 for tablet (<1100px), 3 for web/desktop
    int crossAxisCount = 1;
    if (screenWidth >= 1100) {
      crossAxisCount = 3;
    } else if (screenWidth >= 600) {
      crossAxisCount = 2;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.school, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Pakistan Educational Portal',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF006633), // Green representing Pakistan identity
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            tooltip: 'About Portal',
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'Academic Portal Pakistan',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.school, size: 40, color: Color(0xFF006633)),
                children: [
                  const Text(
                    'A cross-platform educational platform providing free access to video lectures and lecture notes for Pakistani students.',
                  ),
                ],
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Top Header Banner
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
                  'Explore Courses & Lectures',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Access high-quality curriculum lectures, video tutorials, and PDF study notes.',
                  style: TextStyle(fontSize: 14, color: Colors.black70),
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
                            color: isSelected ? Colors.white : Colors.black80,
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
                if (snapshot.connectionState == ConnectionState.waiting) {
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
                var courses = docs.map((doc) => Course.fromFirestore(doc)).toList();

                // Apply Category Filter if not 'All'
                if (_selectedCategory != 'All') {
                  courses = courses.where((c) => c.category.contains(_selectedCategory)).toList();
                }

                if (courses.isEmpty) {
                  return _buildErrorOrEmptyState(
                    context,
                    title: 'No Courses Available',
                    message: 'No courses found in the selected category. You can add courses to Firestore under "/courses".',
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorOrEmptyState(BuildContext context, {required String title, required String message}) {
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
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006633),
                foregroundColor: Colors.white,
              ),
              onPressed: () => setState(() {}),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry / Refresh'),
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
            Icon(Icons.play_circle_outline, size: 48, color: Colors.white),
            SizedBox(height: 4),
            Text(
              'Educational Portal PK',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
