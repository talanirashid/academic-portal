import 'package:cloud_firestore/cloud_firestore.dart';

/// Service providing mock data and Firestore database seeding helpers.
class MockDataService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Force writes courses and nested sub-collection modules directly into Firestore.
  static Future<void> forceSeedDatabase() async {
    try {
      final coursesRef = _firestore.collection('courses');

      // 1. Class XI Computer Science
      final course1Doc = coursesRef.doc('cs_xi_fbise');
      await course1Doc.set({
        'title': 'Class XI Computer Science (FBISE & Sindh Board)',
        'subject': 'Computer Science',
        'category': 'ICS / CS',
        'grade': 'Class 11 / HSSC-I',
        'description':
            'Complete Class 11 Computer Science course covering Computer Systems, Office Automation, Network Communications, and Operating Systems for FBISE and Sindh Textbook Boards.',
        'instructor': 'Prof. Tariq Mahmood',
        'rating': 4.9,
        'thumbnailUrl':
            'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?q=80&w=800',
        'bannerUrl':
            'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?q=80&w=800',
        'isPaid': false,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      final modules1Ref = course1Doc.collection('modules');
      await modules1Ref.doc('mod_1').set({
        'title': '01: Overview of Computer Systems & Architecture',
        'description': 'Hardware, software hierarchy, processing cycles, and system buses',
        'youtubeVideoId': 'M576WGiDBdQ',
        'notesPdfUrl':
            'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        'pdfNotesUrl':
            'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        'duration': '18:40',
        'orderIndex': 1,
      }, SetOptions(merge: true));

      await modules1Ref.doc('mod_2').set({
        'title': '02: Number Systems & Digital Logic',
        'description': 'Binary, octal, hexadecimal, and 1s/2s complements',
        'youtubeVideoId': '3QhU9jd03a0',
        'notesPdfUrl':
            'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        'pdfNotesUrl':
            'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        'duration': '24:15',
        'orderIndex': 2,
      }, SetOptions(merge: true));

      await modules1Ref.doc('mod_3').set({
        'title': '03: Central Processing Unit & Memory Mechanisms',
        'description': 'ALU, Control Unit, RAM, ROM, and Cache memory systems',
        'youtubeVideoId': 'Z5JC9Ve1sfA',
        'notesPdfUrl':
            'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        'pdfNotesUrl':
            'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        'duration': '21:05',
        'orderIndex': 3,
      }, SetOptions(merge: true));

      // 2. Class XII Computer Science
      final course2Doc = coursesRef.doc('cs_xii_fbise');
      await course2Doc.set({
        'title': 'Class XII Computer Science - Programming & Databases',
        'subject': 'Computer Science',
        'category': 'ICS / CS',
        'grade': 'Class 12 / HSSC-II',
        'description':
            'Comprehensive Class 12 Computer Science course focusing on Data Structures, C++ Programming, and Database Management Systems (DBMS).',
        'instructor': 'Engr. Ayesha Khan',
        'rating': 4.8,
        'thumbnailUrl':
            'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?q=80&w=800',
        'bannerUrl':
            'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?q=80&w=800',
        'isPaid': false,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      final modules2Ref = course2Doc.collection('modules');
      await modules2Ref.doc('mod_1').set({
        'title': '01: Introduction to C / C++ Fundamentals',
        'description': 'Data types, loops, decision constructs, and syntax',
        'youtubeVideoId': 'vLnPwxZdW4w',
        'notesPdfUrl':
            'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        'pdfNotesUrl':
            'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        'duration': '22:10',
        'orderIndex': 1,
      }, SetOptions(merge: true));

      await modules2Ref.doc('mod_2').set({
        'title': '02: Database Concepts & SQL Queries',
        'description':
            'Relational models, ER diagrams, normalization and SQL SELECT statements',
        'youtubeVideoId': 'HXV3zeQKqGY',
        'notesPdfUrl':
            'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        'pdfNotesUrl':
            'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        'duration': '28:30',
        'orderIndex': 2,
      }, SetOptions(merge: true));

      // Log success message to console
      // ignore: avoid_print
      print('>>> [Firebase] Database successfully populated with courses and modules! <<<');
    } catch (e) {
      // ignore: avoid_print
      print('>>> [Firebase] Error seeding database: $e <<<');
    }
  }

  /// Helper to trigger force seed or checking emptiness
  static Future<bool> seedSampleCourses({bool force = false}) async {
    await forceSeedDatabase();
    return true;
  }
}
