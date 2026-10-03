import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course_model.dart';

/// Service providing mock data and Firestore database seeding helpers for testing.
class MockDataService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Seeds sample Pakistani curriculum courses into Cloud Firestore under `/courses`.
  /// Includes a safe check so it only writes if the collection is empty (unless [force] is true).
  static Future<bool> seedSampleCourses({bool force = false}) async {
    try {
      final collectionRef = _firestore.collection('courses');
      final snapshot = await collectionRef.get();

      if (snapshot.docs.isNotEmpty && !force) {
        return false; // Collection already has documents, skip seeding
      }

      final List<Course> sampleCourses = [
        Course(
          id: 'cs_11_fbise',
          title: 'Class XI Computer Science (FBISE & Sindh Board)',
          description:
              'Complete Class 11 Computer Science course covering Computer Systems, Office Automation, Network Communications, and Operating Systems for FBISE and Sindh Textbook Boards.',
          instructor: 'Prof. Tariq Mahmood',
          thumbnailUrl:
              'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800',
          category: 'ICS / CS',
          rating: 4.9,
          modules: [
            Module(
              id: 'm1',
              title: 'Chapter 1: Overview of Computer System',
              description: 'Hardware, software, processing cycles and system components.',
              youtubeVideoId: 'M576WGiDBdQ',
              pdfNotesUrl:
                  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
              duration: '18:40',
            ),
            Module(
              id: 'm2',
              title: 'Chapter 2: Data Communication & Computer Networks',
              description: 'Network topologies, OSI model, IP addresses and data transfer.',
              youtubeVideoId: '3QhU9jd03a0',
              pdfNotesUrl:
                  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
              duration: '24:15',
            ),
            Module(
              id: 'm3',
              title: 'Chapter 3: Central Processing Unit & Memory',
              description: 'ALU, Control Unit, RAM, ROM, and Cache memory mechanisms.',
              youtubeVideoId: 'Z5JC9Ve1sfA',
              pdfNotesUrl:
                  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
              duration: '21:05',
            ),
          ],
        ),
        Course(
          id: 'cs_12_prep',
          title: 'Class XII Computer Science - Complete Prep',
          description:
              'Comprehensive Class 12 Computer Science course focusing on Data Structures, C++ Programming, and Database Management Systems (DBMS).',
          instructor: 'Engr. Ayesha Khan',
          thumbnailUrl:
              'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=800',
          category: 'ICS / CS',
          rating: 4.8,
          modules: [
            Module(
              id: 'm1',
              title: 'Chapter 1: Data Structures & C++ Arrays',
              description: 'Arrays, Pointers, Stacks, Queues and memory allocation in C++.',
              youtubeVideoId: 'vLnPwxZdW4w',
              pdfNotesUrl:
                  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
              duration: '22:10',
            ),
            Module(
              id: 'm2',
              title: 'Chapter 2: Database Concepts & SQL Queries',
              description:
                  'Relational models, ER diagrams, normalization and SQL SELECT statements.',
              youtubeVideoId: 'HXV3zeQKqGY',
              pdfNotesUrl:
                  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
              duration: '28:30',
            ),
          ],
        ),
      ];

      for (var course in sampleCourses) {
        await collectionRef.doc(course.id).set(course.toFirestore());
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
