import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

/// Screen for viewing PDF lecture notes in-app with anti-piracy student attribution.
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

          // Watermark overlay for secure anti-piracy attribution
          Positioned(
            bottom: 16,
            right: 16,
            left: 16,
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Licensed to: ${widget.studentInfo} • PCSA Academic Portal',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    letterSpacing: 0.5,
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
