import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/course_model.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late YoutubePlayerController _controller;
  Module? _activeModule;

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
    });
    if (module.youtubeVideoId.isNotEmpty) {
      _controller.loadVideoById(videoId: module.youtubeVideoId);
    }
  }

  Future<void> _launchNotesUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open notes link: $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerControllerProvider(
      controller: _controller,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.course.title),
          backgroundColor: const Color(0xFF006633),
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              // Active Lecture Details & Notes Action
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

                    // Downloadable Notes Buttons using url_launcher
                    if (_activeModule?.pdfNotesUrl != null && _activeModule!.pdfNotesUrl!.isNotEmpty)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF006633),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () => _launchNotesUrl(_activeModule!.pdfNotesUrl!),
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text(
                          'Download Lecture Notes (PDF)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                    const Divider(height: 32, thickness: 1),

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

                    // Chapter List below the video
                    if (widget.course.modules.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'No chapters available for this course yet.',
                          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.course.modules.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final module = widget.course.modules[index];
                          final isSelected = _activeModule?.id == module.id ||
                              (_activeModule == null && index == 0);

                          return Container(
                            color: isSelected ? const Color(0xFF006633).withValues(alpha: 0.1) : null,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isSelected
                                    ? const Color(0xFF006633)
                                    : Colors.grey[200],
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black80,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                module.title,
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
                                      tooltip: 'Download PDF Notes',
                                      onPressed: () => _launchNotesUrl(module.pdfNotesUrl!),
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
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
