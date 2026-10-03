import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../models/course_model.dart';
import '../services/auth_service.dart';
import '../services/payment_service.dart';
import '../widgets/bilingual_tooltip_widget.dart';
import '../widgets/kmap_solver_widget.dart';
import '../widgets/logic_gate_simulator_widget.dart';
import 'payment_submission_dialog.dart';
import 'pdf_viewer_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  final AuthService _authService = AuthService();
  final PaymentService _paymentService = PaymentService();
  late YoutubePlayerController _controller;
  Module? _activeModule;
  double _currentPlaybackSpeed = 1.0;

  // Track quiz selections: questionId -> selectedOptionIndex
  final Map<String, int> _quizAnswers = {};

  @override
  void initState() {
    super.initState();
    if (widget.course.modules.isNotEmpty) {
      _activeModule = widget.course.modules.first;
    }

    final initialVideoId = _activeModule?.youtubeVideoId ?? 'dQw4w9WgXcQ';

    _controller = YoutubePlayerController.fromVideoId(
      videoId: initialVideoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  void _selectModule(Module module) {
    setState(() {
      _activeModule = module;
      _quizAnswers.clear(); // Reset quiz choices when changing chapter
    });
    if (module.youtubeVideoId.isNotEmpty) {
      _controller.loadVideoById(videoId: module.youtubeVideoId);
    }
  }

  void _setPlaybackRate(double speed) {
    setState(() {
      _currentPlaybackSpeed = speed;
    });
    _controller.setPlaybackRate(speed);
  }

  void _navigateToNextModule() {
    if (_activeModule == null || widget.course.modules.isEmpty) return;
    final currentIndex = widget.course.modules.indexWhere((m) => m.id == _activeModule!.id);
    if (currentIndex != -1 && currentIndex < widget.course.modules.length - 1) {
      _selectModule(widget.course.modules[currentIndex + 1]);
    }
  }

  void _navigateToPreviousModule() {
    if (_activeModule == null || widget.course.modules.isEmpty) return;
    final currentIndex = widget.course.modules.indexWhere((m) => m.id == _activeModule!.id);
    if (currentIndex > 0) {
      _selectModule(widget.course.modules[currentIndex - 1]);
    }
  }

  void _openInAppPdfViewer(String title, String url) {
    final studentInfo = _authService.currentUser?.email ??
        'Student ID: ${_authService.currentUser?.uid.substring(0, 8) ?? "Guest"}';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfViewerScreen(
          title: title,
          pdfUrl: url,
          studentInfo: studentInfo,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeQuizList = _activeModule?.quizQuestions ?? [];
    final user = _authService.currentUser;

    return YoutubePlayerControllerProvider(
      controller: _controller,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.course.title),
          backgroundColor: const Color(0xFF006633),
          foregroundColor: Colors.white,
        ),
        body: StreamBuilder<List<String>>(
          stream: user != null
              ? _paymentService.getEnrolledCoursesStream(user.uid)
              : Stream.value([]),
          builder: (context, enrollmentSnapshot) {
            final enrolledCourses = enrollmentSnapshot.data ?? [];
            final isUnlocked = _paymentService.isCourseUnlocked(
              widget.course.id,
              widget.course.isPaid,
              enrolledCourses,
            );

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Paid Premium Course Locked Banner
                  if (widget.course.isPaid && !isUnlocked)
                    Container(
                      color: Colors.amber[100],
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.lock, color: Color(0xFF004D26)),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Premium Paid Course: Unlock full access via EasyPaisa or HBL Bank',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF004D26)),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF006633),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => PaymentSubmissionDialog(course: widget.course),
                              );
                            },
                            child: const Text('Unlock Access'),
                          ),
                        ],
                      ),
                    ),

                  // Youtube Player Container
                  Container(
                    color: Colors.black,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: YoutubePlayer(
                        controller: _controller,
                        aspectRatio: 16 / 9,
                      ),
                    ),
                  ),

                  // Video Controls Bar (Previous, Playback Speed, Next)
                  Container(
                    color: const Color(0xFF00381B),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          style: TextButton.styleFrom(foregroundColor: Colors.white),
                          onPressed: _navigateToPreviousModule,
                          icon: const Icon(Icons.skip_previous),
                          label: const Text('Previous'),
                        ),
                        Row(
                          children: [
                            const Text('Speed: ', style: TextStyle(color: Colors.white70, fontSize: 13)),
                            DropdownButton<double>(
                              dropdownColor: const Color(0xFF00381B),
                              value: _currentPlaybackSpeed,
                              style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                              underline: const SizedBox(),
                              items: const [
                                DropdownMenuItem(value: 1.0, child: Text('1.0x')),
                                DropdownMenuItem(value: 1.25, child: Text('1.25x')),
                                DropdownMenuItem(value: 1.5, child: Text('1.5x')),
                                DropdownMenuItem(value: 2.0, child: Text('2.0x')),
                              ],
                              onChanged: (val) {
                                if (val != null) _setPlaybackRate(val);
                              },
                            ),
                          ],
                        ),
                        TextButton.icon(
                          style: TextButton.styleFrom(foregroundColor: Colors.white),
                          onPressed: _navigateToNextModule,
                          icon: const Icon(Icons.skip_next),
                          label: const Text('Next'),
                        ),
                      ],
                    ),
                  ),

                  // Active Lecture Details & In-App PDF Action
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_activeModule != null) ...[
                          Text(
                            _activeModule!.title,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          if (_activeModule!.description.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              _activeModule!.description,
                              style: TextStyle(color: Colors.grey[700], fontSize: 14),
                            ),
                          ],
                          const SizedBox(height: 12),
                        ],

                        // In-App Notes Viewer Action using SfPdfViewer
                        if (_activeModule?.pdfNotesUrl != null && _activeModule!.pdfNotesUrl!.isNotEmpty)
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF006633),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () => _openInAppPdfViewer(
                              _activeModule!.title,
                              _activeModule!.pdfNotesUrl!,
                            ),
                            icon: const Icon(Icons.picture_as_pdf),
                            label: const Text(
                              'View Chapter Notes (In-App PDF)',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),

                        const Divider(height: 32, thickness: 1),

                        // Interactive Logic Gate Simulator Widget
                        const LogicGateSimulatorWidget(),

                        const SizedBox(height: 16),

                        // Interactive K-Map 2-Variable Solver Widget
                        const KMapSolverWidget(),

                        const SizedBox(height: 16),

                        // Bilingual Technical Terms Glossary Widget
                        const BilingualTooltipWidget(),

                        const Divider(height: 32, thickness: 1),

                        // Interactive Topic MCQs Practice Quiz Section
                        if (activeQuizList.isNotEmpty) ...[
                          Row(
                            children: [
                              const Icon(Icons.quiz, color: Color(0xFF006633)),
                              const SizedBox(width: 8),
                              Text(
                                'Practice MCQs & Self-Assessment (${activeQuizList.length})',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildInteractiveQuizCard(activeQuizList),
                          const Divider(height: 32, thickness: 1),
                        ],

                        // Course Info Summary
                        Text(
                          'Course Overview',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF006633),
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.course.description,
                          style: const TextStyle(fontSize: 14, height: 1.4),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.person, size: 18, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text('Instructor: ${widget.course.instructor}',
                                style: const TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),

                        const Divider(height: 32, thickness: 1),

                        // Chapter / Module List Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Course Chapters (${widget.course.modules.length})',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Icon(Icons.list_alt, color: Color(0xFF006633)),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Chapter List below the video with StreamBuilder Progress Checkboxes
                        StreamBuilder<List<String>>(
                          stream: _authService.getCompletedModulesStream(widget.course.id),
                          builder: (context, progressSnapshot) {
                            final completedModuleIds = progressSnapshot.data ?? [];

                            if (widget.course.modules.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  'No chapters available for this course yet.',
                                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                                ),
                              );
                            }

                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.course.modules.length,
                              separatorBuilder: (context, index) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final module = widget.course.modules[index];
                                final isSelected = _activeModule?.id == module.id ||
                                    (_activeModule == null && index == 0);
                                final isCompleted = completedModuleIds.contains(module.id);

                                return Container(
                                  color: isSelected ? const Color(0xFF006633).withValues(alpha: 0.1) : null,
                                  child: ListTile(
                                    leading: IconButton(
                                      icon: Icon(
                                        isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                                        color: isCompleted ? const Color(0xFF006633) : Colors.grey,
                                      ),
                                      tooltip: isCompleted ? 'Completed' : 'Mark Completed',
                                      onPressed: () {
                                        _authService.markChapterCompleted(
                                          widget.course.id,
                                          module.id,
                                          completed: !isCompleted,
                                        );
                                      },
                                    ),
                                    title: Text(
                                      module.title,
                                      style: TextStyle(
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                                      ),
                                    ),
                                    subtitle: module.duration.isNotEmpty
                                        ? Text('Duration: ${module.duration}')
                                        : null,
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (module.pdfNotesUrl != null && module.pdfNotesUrl!.isNotEmpty)
                                          IconButton(
                                            icon: const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
                                            tooltip: 'View PDF Notes',
                                            onPressed: () => _openInAppPdfViewer(
                                              module.title,
                                              module.pdfNotesUrl!,
                                            ),
                                          ),
                                        Icon(
                                          isSelected ? Icons.play_circle_fill : Icons.play_circle_outline,
                                          color: isSelected ? const Color(0xFF006633) : Colors.grey,
                                        ),
                                      ],
                                    ),
                                    onTap: () => _selectModule(module),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInteractiveQuizCard(List<QuizQuestion> questions) {
    int totalQuestions = questions.length;
    int answeredCount = _quizAnswers.length;
    int correctCount = 0;

    for (var q in questions) {
      if (_quizAnswers.containsKey(q.id) && _quizAnswers[q.id] == q.correctOptionIndex) {
        correctCount++;
      }
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quiz Header Score Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Topic Knowledge Check',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                ),
                Chip(
                  backgroundColor: const Color(0xFF006633).withValues(alpha: 0.1),
                  label: Text(
                    'Done: $answeredCount/$totalQuestions • Score: $correctCount',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF006633)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Questions List
            ...questions.asMap().entries.map((entry) {
              final idx = entry.key;
              final q = entry.value;
              final selectedOption = _quizAnswers[q.id];
              final isAnswered = selectedOption != null;

              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Q${idx + 1}: ${q.questionText}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 8),

                    // Options List
                    ...q.options.asMap().entries.map((optEntry) {
                      final optIdx = optEntry.key;
                      final optText = optEntry.value;

                      Color? tileColor;
                      IconData icon = Icons.circle_outlined;
                      Color iconColor = Colors.grey;

                      if (isAnswered) {
                        if (optIdx == q.correctOptionIndex) {
                          tileColor = Colors.green[100];
                          icon = Icons.check_circle;
                          iconColor = Colors.green[800]!;
                        } else if (optIdx == selectedOption) {
                          tileColor = Colors.red[100];
                          icon = Icons.cancel;
                          iconColor = Colors.red[800]!;
                        }
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          color: tileColor ?? Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isAnswered && optIdx == q.correctOptionIndex
                                ? Colors.green
                                : isAnswered && optIdx == selectedOption
                                    ? Colors.red
                                    : Colors.grey[300]!,
                          ),
                        ),
                        child: ListTile(
                          dense: true,
                          leading: Icon(icon, color: iconColor, size: 20),
                          title: Text(
                            optText,
                            style: TextStyle(
                              fontWeight: selectedOption == optIdx ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _quizAnswers[q.id] = optIdx;
                            });
                          },
                        ),
                      );
                    }),

                    // Explanation Box
                    if (isAnswered && q.explanation.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline, color: Colors.blue, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Explanation: ${q.explanation}',
                                style: const TextStyle(fontSize: 13, color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
