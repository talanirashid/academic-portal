/// Helper to safely convert any Map object to `Map<String, dynamic>` across Dart Web and Native.
Map<String, dynamic> _asMap(dynamic item) {
  if (item is Map) {
    return item.map((k, v) => MapEntry(k.toString(), v));
  }
  return <String, dynamic>{};
}

/// Model representing a solved board past paper or model examination paper.
class PastPaper {
  final String id;
  final String title;
  final String board; // FBISE, Sindh Board, Karachi Board
  final String year; // 2024, 2023, 2022, 2021...
  final String subject; // Computer Science
  final String grade; // Class 11, Class 12
  final String pdfUrl;
  final String description;

  PastPaper({
    required this.id,
    required this.title,
    required this.board,
    required this.year,
    required this.subject,
    required this.grade,
    required this.pdfUrl,
    this.description = '',
  });

  factory PastPaper.fromMap(Map<String, dynamic> rawMap, String id) {
    final map = _asMap(rawMap);
    return PastPaper(
      id: id,
      title: map['title'] as String? ?? 'Past Paper Solution',
      board: map['board'] as String? ?? 'FBISE',
      year: map['year'] as String? ?? '2024',
      subject: map['subject'] as String? ?? 'Computer Science',
      grade: map['grade'] as String? ?? 'Class 11',
      pdfUrl: map['pdfUrl'] as String? ?? '',
      description: map['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'board': board,
      'year': year,
      'subject': subject,
      'grade': grade,
      'pdfUrl': pdfUrl,
      'description': description,
    };
  }
}
