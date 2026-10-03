import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

/// Screen for viewing PDF lecture notes in-app with anti-piracy dynamic watermark jitter.
class PdfViewerScreen extends StatefulWidget {
  final String title;
  final String pdfUrl;
  final String studentInfo;

  const PdfViewerScreen({
    super.key,
    required this.title,
    required this.pdfUrl,
    required this.studentInfo,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  bool _isLoading = true;
  Timer? _watermarkTimer;
  Alignment _watermarkAlignment = Alignment.bottomCenter;

  final List<Alignment> _alignments = [
    Alignment.bottomCenter,
    Alignment.topCenter,
    Alignment.centerRight,
    Alignment.centerLeft,
    Alignment.bottomLeft,
    Alignment.topRight,
  ];
  int _alignmentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Dynamic position jitter shifting watermark location every 4 seconds to deter automated cropping
    _watermarkTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          _alignmentIndex = (_alignmentIndex + 1) % _alignments.length;
          _watermarkAlignment = _alignments[_alignmentIndex];
        });
      }
    });
  }

  @override
  void dispose() {
    _watermarkTimer?.cancel();
    _pdfViewerController.dispose();
    super.dispose();
  }

  Future<void> _openExternal() async {
    final Uri uri = Uri.parse(widget.pdfUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $uri')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF006633),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new),
            tooltip: 'Open in External Browser',
            onPressed: _openExternal,
          ),
        ],
      ),
      body: Stack(
        children: [
          // PDF Viewer
          SfPdfViewer.network(
            widget.pdfUrl,
            controller: _pdfViewerController,
            onDocumentLoaded: (PdfDocumentLoadedDetails details) {
              setState(() {
                _isLoading = false;
              });
            },
            onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
              setState(() {
                _isLoading = false;
              });
            },
          ),

          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFF006633)),
            ),

          // Dynamic jitter watermark overlay for secure anti-piracy attribution
          Align(
            alignment: _watermarkAlignment,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: IgnorePointer(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    'Licensed to: ${widget.studentInfo} • PCSA DRM',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
