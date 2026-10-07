import 'package:cloud_firestore/cloud_firestore.dart';

/// Service providing mock data and Firestore database seeding helpers.
class MockDataService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Official publication Google Drive link for Unit 1 Keybook
  static const String unit1GoogleDriveKeybookUrl =
      'https://drive.google.com/open?id=1VHFjBTNHy7FT0n2gZbTT-tGGy1KZ5Fm3&usp=drive_fs';

  /// 1-Click Browser Seeder for Official STBB Class 11 Unit 1 Syllabus Bundle
  static Future<void> seedSTBBUnit01ToFirestore() async {
    final docId = 'stbb_cs_class11_unit01';
    final payload = {
      'id': docId,
      'board': 'STBB',
      'curriculumStream': 'stbb',
      'class': 11,
      'targetClass': 'class_11',
      'unitNumber': 1,
      'unitTitle': 'Computer Systems & Logic Design',
      'description':
          'Official 2026 STBB Curriculum: Discrete vs Continuous Quantities, Boolean Algebra & 7 Logic Gates, Canonical Forms & K-Maps, Logisim Evolution v3.9+, 6 SDLC Phases, and Waterfall & Agile Case Studies.',
      'isLocked': false, // Free preview MVP
      'isPublished': true,
      'topics': [
        'Discrete vs Continuous',
        'Digital Signals',
        'Boolean Algebra',
        'Logic Gates',
        'K-Maps',
        'Logisim Evolution',
        'SDLC Phases',
        'Waterfall & Agile Models',
      ],
      'notesDriveUrl': 'https://drive.google.com/open?id=1vpIz70_LusjYmSNMObzBQXGeEcK0zhO7',
      'solvedExercisesDriveUrl': 'https://drive.google.com/open?id=1vpIz70_LusjYmSNMObzBQXGeEcK0zhO7',
      'labJournalDriveUrl': 'https://drive.google.com/open?id=1vpIz70_LusjYmSNMObzBQXGeEcK0zhO7',
      'pastPapersDriveUrl': 'https://drive.google.com/open?id=1vpIz70_LusjYmSNMObzBQXGeEcK0zhO7',
      'updatedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('curriculum_resources').doc(docId).set(payload, SetOptions(merge: true));
  }

  /// Force writes courses and nested sub-collection modules directly into Firestore.
  static Future<void> forceSeedDatabase() async {
    try {
      final coursesRef = _firestore.collection('courses');

      // 1. Class 11th Computer Science
      final course1Doc = coursesRef.doc('cs_xi_fbise');
      await course1Doc.set({
        'title': 'Class 11th Computer Science (HSSC-I / 1st Year)',
        'subject': 'Computer Science',
        'category': 'Class 11th (HSSC-I / 1st Year)',
        'grade': 'Class 11th (HSSC-I / 1st Year)',
        'description':
            'Complete Class 11 Computer Science course covering Computer Systems, Office Automation, Network Communications, and Operating Systems for FBISE and Sindh Textbook Boards.',
        'instructor': 'Rashid Talani, Lecturer Computer Science',
        'rating': 4.9,
        'thumbnailUrl':
            'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?q=80&w=800',
        'bannerUrl':
            'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?q=80&w=800',
        'isPaid': false,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      final modules1Ref = course1Doc.collection('modules');

      // Unit 1 Updated Module Entry
      await modules1Ref.doc('mod_1').set({
        'title': 'Unit 1: Computer Systems & Digital Logic Architecture',
        'description':
            'Official PCSA Oxford-style keybook notes, logic diagrams, exam traps, and SLO exercises.',
        'author': 'Rashid Talani, Lecturer Computer Science',
        'youtubeVideoId': 'M576WGiDBdQ',
        'notesPdfUrl': unit1GoogleDriveKeybookUrl,
        'pdfNotesUrl': unit1GoogleDriveKeybookUrl,
        'duration': '18:40',
        'orderIndex': 1,
        'quizQuestions': [
          {
            'id': 'q1',
            'questionText':
                'Which bus is bidirectional in a computer system architecture?',
            'options': ['Control Bus', 'Address Bus', 'Data Bus', 'Power Bus'],
            'correctOptionIndex': 2,
            'explanation':
                'The Data Bus is bidirectional as data travels into and out of CPU/memory registers.'
          },
          {
            'id': 'q2',
            'questionText': 'What is the binary equivalent of decimal 25?',
            'options': ['11001', '10101', '11100', '10011'],
            'correctOptionIndex': 0,
            'explanation': '25 in base-2 binary is 16 + 8 + 1 = 11001_2.'
          }
        ]
      }, SetOptions(merge: true));

      await modules1Ref.doc('mod_2').set({
        'title': '02: Number Systems & Digital Logic',
        'description': 'Binary, octal, hexadecimal, and 1s/2s complements',
        'author': 'Rashid Talani, Lecturer Computer Science',
        'youtubeVideoId': '3QhU9jd03a0',
        'notesPdfUrl':
            'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        'pdfNotesUrl':
            'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        'duration': '24:15',
        'orderIndex': 2,
        'quizQuestions': [
          {
            'id': 'q3',
            'questionText':
                'Which logic gate produces HIGH output only when all inputs are HIGH?',
            'options': ['OR Gate', 'AND Gate', 'NAND Gate', 'XOR Gate'],
            'correctOptionIndex': 1,
            'explanation':
                'An AND gate gives output 1 (HIGH) only when both input signals A and B are 1.'
          }
        ]
      }, SetOptions(merge: true));

      await modules1Ref.doc('mod_3').set({
        'title': '03: Central Processing Unit & Memory Mechanisms',
        'description': 'ALU, Control Unit, RAM, ROM, and Cache memory systems',
        'author': 'Rashid Talani, Lecturer Computer Science',
        'youtubeVideoId': 'Z5JC9Ve1sfA',
        'notesPdfUrl':
            'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        'pdfNotesUrl':
            'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        'duration': '21:05',
        'orderIndex': 3,
        'quizQuestions': [
          {
            'id': 'q4',
            'questionText':
                'Which memory type is volatile and loses data when power is off?',
            'options': ['ROM', 'Flash Drive', 'RAM', 'Hard Disk'],
            'correctOptionIndex': 2,
            'explanation':
                'RAM (Random Access Memory) is volatile primary memory.'
          }
        ]
      }, SetOptions(merge: true));

      // 2. Class 12th Computer Science
      final course2Doc = coursesRef.doc('cs_xii_fbise');
      await course2Doc.set({
        'title': 'Class 12th Computer Science (HSSC-II / 2nd Year)',
        'subject': 'Computer Science',
        'category': 'Class 12th (HSSC-II / 2nd Year)',
        'grade': 'Class 12th (HSSC-II / 2nd Year)',
        'description':
            'Comprehensive Class 12 Computer Science course focusing on Data Structures, C++ Programming, and Database Management Systems (DBMS).',
        'instructor': 'Rashid Talani, Lecturer Computer Science',
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
        'author': 'Rashid Talani, Lecturer Computer Science',
        'youtubeVideoId': 'vLnPwxZdW4w',
        'notesPdfUrl':
            'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        'pdfNotesUrl':
            'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        'duration': '22:10',
        'orderIndex': 1,
        'quizQuestions': [
          {
            'id': 'q5',
            'questionText':
                'Which data structure works on LIFO (Last In First Out) principle?',
            'options': ['Queue', 'Stack', 'Tree', 'Array'],
            'correctOptionIndex': 1,
            'explanation':
                'A Stack operates under LIFO, where the last element inserted is the first one removed.'
          }
        ]
      }, SetOptions(merge: true));

      await modules2Ref.doc('mod_2').set({
        'title': '02: Database Concepts & SQL Queries',
        'description':
            'Relational models, ER diagrams, normalization and SQL SELECT statements',
        'author': 'Rashid Talani, Lecturer Computer Science',
        'youtubeVideoId': 'HXV3zeQKqGY',
        'notesPdfUrl':
            'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        'pdfNotesUrl':
            'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        'duration': '28:30',
        'orderIndex': 2,
        'quizQuestions': [
          {
            'id': 'q6',
            'questionText':
                'Which SQL clause is used to filter query results?',
            'options': ['ORDER BY', 'GROUP BY', 'WHERE', 'HAVING'],
            'correctOptionIndex': 2,
            'explanation':
                'The WHERE clause filters rows based on a specified boolean condition.'
          }
        ]
      }, SetOptions(merge: true));

      // 3. Class 9th Computer Science
      final course3Doc = coursesRef.doc('cs_ix_fbise');
      await course3Doc.set({
        'title': 'Class 9th Computer Science (SSC-I / Matric)',
        'subject': 'Computer Science',
        'category': 'Class 9th (SSC-I)',
        'grade': 'Class 9th (SSC-I)',
        'description':
            'Class 9 Computer Science covering Problem Solving, Flowcharts, Algorithm Design, and Basics of Computing.',
        'instructor': 'Rashid Talani, Lecturer Computer Science',
        'rating': 4.9,
        'thumbnailUrl':
            'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?q=80&w=800',
        'bannerUrl':
            'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?q=80&w=800',
        'isPaid': false,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // 4. Class 10th Computer Science
      final course4Doc = coursesRef.doc('cs_x_fbise');
      await course4Doc.set({
        'title': 'Class 10th Computer Science (SSC-II / Matric)',
        'subject': 'Computer Science',
        'category': 'Class 10th (SSC-II)',
        'grade': 'Class 10th (SSC-II)',
        'description':
            'Class 10 Computer Science covering Programming in C, Control Structures, Functions, and Logic Concepts.',
        'instructor': 'Rashid Talani, Lecturer Computer Science',
        'rating': 4.8,
        'thumbnailUrl':
            'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?q=80&w=800',
        'bannerUrl':
            'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?q=80&w=800',
        'isPaid': false,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Auto-seed official STBB Unit 1 bundle as well
      await seedSTBBUnit01ToFirestore();

      // ignore: avoid_print
      print(
          '>>> [Firebase] Database successfully populated with updated Unit 1 Google Drive Keybook & STBB Syllabus Bundle! <<<');
    } catch (e) {
      // ignore: avoid_print
      print('>>> [Firebase] Error seeding database: $e <<<');
    }
  }

  static Future<bool> seedSampleCourses({bool force = false}) async {
    await forceSeedDatabase();
    return true;
  }
}
