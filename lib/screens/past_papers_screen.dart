import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/past_paper_model.dart';
import '../services/auth_service.dart';
import 'pdf_viewer_screen.dart';

class PastPapersScreen extends StatefulWidget {
  const PastPapersScreen({super.key});

  @override
  State<PastPapersScreen> createState() => _PastPapersScreenState();
}

class _PastPapersScreenState extends State<PastPapersScreen> {
  final AuthService _authService = AuthService();
  String _selectedBoard = 'All';
  String _selectedYear = 'All';

  final List<String> _boards = ['All', 'FBISE', 'Sindh Board', 'Karachi Board'];
  final List<String> _years = ['All', '2024', '2023', '2022', '2021', '2020'];

  // Sample static past papers fallback if Firestore collection /past_papers is empty
  final List<PastPaper> _samplePastPapers = [
    PastPaper(
      id: 'fbise_2024_xi',
      title: 'FBISE Class 11 CS Solved Annual Board Paper 2024',
      board: 'FBISE',
      year: '2024',
      subject: 'Computer Science',
      grade: 'Class 11',
      pdfUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      description: 'Complete solved Section A (MCQs), Section B (Short Questions) & Section C (Long Questions).',
    ),
    PastPaper(
      id: 'fbise_2023_xii',
      title: 'FBISE Class 12 CS Solved Annual Board Paper 2023',
      board: 'FBISE',
      year: '2023',
      subject: 'Computer Science',
      grade: 'Class 12',
      pdfUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      description: 'Includes full C++ programming solutions, Data Structure diagrams, and SQL queries.',
    ),
    PastPaper(
      id: 'sindh_2024_xi',
      title: 'Sindh Board Class 11 CS Solved Past Paper 2024',
      board: 'Sindh Board',
      year: '2024',
      subject: 'Computer Science',
      grade: 'Class 11',
      pdfUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      description: 'Karachi Board & Sindh Textbook Board pattern model solutions with keybook references.',
    ),
  ];

  void _openInAppPdfViewer(PastPaper paper) {
    final studentInfo = _authService.currentUser?.email ??
        'Student ID: ${_authService.currentUser?.uid.substring(0, 8) ?? "Guest"}';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfViewerScreen(
          title: paper.title,
          pdfUrl: paper.pdfUrl,
          studentInfo: studentInfo,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Past Papers & Solved Solutions'),
        backgroundColor: const Color(0xFF004D26),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filter Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF006633).withValues(alpha: 0.08),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FBISE & Sindh Board Solved Archives',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Access 5-year solved board examination papers organized by year and section.',
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Board Filter
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedBoard,
                        decoration: const InputDecoration(
                          labelText: 'Board',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(),
                        ),
                        items: _boards
                            .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedBoard = val);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Year Filter
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedYear,
                        decoration: const InputDecoration(
                          labelText: 'Year',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(),
                        ),
                        items: _years
                            .map((y) => DropdownMenuItem(value: y, child: Text(y)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedYear = val);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // List of Past Papers
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('past_papers').snapshots(),
              builder: (context, snapshot) {
                var papers = _samplePastPapers;

                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  papers = snapshot.data!.docs
                      .map((doc) => PastPaper.fromMap(doc.data(), doc.id))
                      .toList();
                }

                // Filter by Board & Year
                if (_selectedBoard != 'All') {
                  papers = papers.where((p) => p.board == _selectedBoard).toList();
                }
                if (_selectedYear != 'All') {
                  papers = papers.where((p) => p.year == _selectedYear).toList();
                }

                if (papers.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text('No past papers found for selected filter.'),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: papers.length,
                  itemBuilder: (context, index) {
                    final paper = papers[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF006633),
                          child: Text(
                            paper.year,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11),
                          ),
                        ),
                        title: Text(
                          paper.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${paper.board} • ${paper.grade} • ${paper.subject}'),
                            if (paper.description.isNotEmpty)
                              Text(paper.description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        trailing: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF006633),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => _openInAppPdfViewer(paper),
                          icon: const Icon(Icons.picture_as_pdf, size: 16),
                          label: const Text('View Solved'),
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
}
