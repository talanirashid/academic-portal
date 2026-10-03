import 'package:flutter/material.dart';
import '../models/fbise_exercise_model.dart';
import '../services/auth_service.dart';
import '../services/payment_service.dart';
import 'payment_submission_dialog.dart';
import '../models/course_model.dart';

/// Screen providing Solved Textbook Exercises, Conceptual Questions, and Practice Quizzes for FBISE Class 11 CS.
class FbiseSolvedExercisesScreen extends StatefulWidget {
  const FbiseSolvedExercisesScreen({super.key});

  @override
  State<FbiseSolvedExercisesScreen> createState() => _FbiseSolvedExercisesScreenState();
}

class _FbiseSolvedExercisesScreenState extends State<FbiseSolvedExercisesScreen> {
  final AuthService _authService = AuthService();
  final PaymentService _paymentService = PaymentService();

  int _selectedUnitNumber = 0; // 0 = All Units
  String _selectedFilterType = 'All'; // 'All', 'short_q', 'long_q', 'mcq'

  final Map<String, int> _userQuizAnswers = {};

  final List<FbiseExerciseItem> _sampleExercises = [
    // Unit 1
    FbiseExerciseItem(
      id: 'fb1_q1',
      unitNumber: 1,
      unitTitle: 'Unit 1: Overview of Computer System',
      questionType: 'short_q',
      questionText: 'Differentiate between System Bus and Expansion Bus with examples.',
      answerText: 'System Bus connects the CPU to main memory (RAM) and consists of Data, Address, and Control buses operating at CPU clock speed. Expansion Bus connects CPU to peripheral devices (PCIe, USB, SATA) via expansion slots.',
      isPaid: false,
    ),
    FbiseExerciseItem(
      id: 'fb1_mcq1',
      unitNumber: 1,
      unitTitle: 'Unit 1: Overview of Computer System',
      questionType: 'mcq',
      questionText: 'Which system bus is unidirectional?',
      answerText: 'Address Bus',
      options: ['Data Bus', 'Address Bus', 'Control Bus', 'PCIe Bus'],
      correctOptionIndex: 1,
      explanation: 'The Address Bus carries memory addresses generated solely by the CPU to RAM, making it strictly unidirectional.',
      isPaid: false,
    ),

    // Unit 2
    FbiseExerciseItem(
      id: 'fb2_q1',
      unitNumber: 2,
      unitTitle: 'Unit 2: Computer Memory',
      questionType: 'short_q',
      questionText: 'Why is SRAM faster than DRAM?',
      answerText: 'SRAM uses flip-flops (4-6 transistors per bit) and requires no periodic refreshing. DRAM uses capacitors that leak charge and must be constantly refreshed thousands of times per second, making it slower.',
      isPaid: false,
    ),

    // Unit 3
    FbiseExerciseItem(
      id: 'fb3_long1',
      unitNumber: 3,
      unitTitle: 'Unit 3: Central Processing Unit',
      questionType: 'long_q',
      questionText: 'Explain the Fetch-Decode-Execute Cycle with a block diagram and register roles.',
      answerText: '1. Fetch: PC provides memory address -> MAR -> Memory -> MDR -> IR. PC increments.\n2. Decode: Control Unit decodes opcode in IR.\n3. Execute: ALU performs arithmetic/logic operation and stores result in ACC.',
      isPaid: true, // Premium Expected Board Question
    ),
    FbiseExerciseItem(
      id: 'fb3_mcq1',
      unitNumber: 3,
      unitTitle: 'Unit 3: Central Processing Unit',
      questionType: 'mcq',
      questionText: 'Which CPU register holds the address of the next instruction to be fetched?',
      answerText: 'Program Counter (PC)',
      options: ['Instruction Register (IR)', 'Program Counter (PC)', 'Memory Data Register (MDR)', 'Accumulator (ACC)'],
      correctOptionIndex: 1,
      explanation: 'Program Counter (PC) automatically increments to point to the next sequential instruction address in RAM.',
      isPaid: false,
    ),

    // Unit 5
    FbiseExerciseItem(
      id: 'fb5_q1',
      unitNumber: 5,
      unitTitle: 'Unit 5: Data Communication & Networks',
      questionType: 'short_q',
      questionText: 'Compare Star Topology and Mesh Topology in terms of reliability and cost.',
      answerText: 'Star Topology uses a central Switch; if one node fails, the rest function normally (moderate cost). Mesh Topology provides dedicated point-to-point links between all nodes; highest fault tolerance but high cable cost.',
      isPaid: false,
    ),

    // Unit 7
    FbiseExerciseItem(
      id: 'fb7_long1',
      unitNumber: 7,
      unitTitle: 'Unit 7: Database Fundamentals & DBMS',
      questionType: 'long_q',
      questionText: 'Define Normalization. Explain 1NF, 2NF, and 3NF with an example student table.',
      answerText: 'Normalization is the process of organizing relational database data to reduce redundancy and anomalies.\n- 1NF: Atomic values, no repeating groups.\n- 2NF: In 1NF and no partial key dependencies.\n- 3NF: In 2NF and no transitive non-key dependencies.',
      isPaid: true, // Premium Expected Board Question
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    var filtered = _sampleExercises.where((item) {
      final unitMatch = _selectedUnitNumber == 0 || item.unitNumber == _selectedUnitNumber;
      final typeMatch = _selectedFilterType == 'All' || item.questionType == _selectedFilterType;
      return unitMatch && typeMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('FBISE Class 11 Solved Exercises & Quizzes'),
        backgroundColor: const Color(0xFF004D26),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<String>>(
        stream: user != null
            ? _paymentService.getEnrolledCoursesStream(user.uid)
            : Stream.value([]),
        builder: (context, enrollmentSnapshot) {
          final enrolledCourses = enrollmentSnapshot.data ?? [];

          return Column(
            children: [
              // Top Unit & Material Type Filters
              Container(
                color: const Color(0xFF006633).withValues(alpha: 0.08),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // Unit Selector
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ChoiceChip(
                            label: const Text('All Units'),
                            selected: _selectedUnitNumber == 0,
                            selectedColor: const Color(0xFF006633),
                            labelStyle: TextStyle(
                              color: _selectedUnitNumber == 0 ? Colors.white : Colors.black87,
                              fontWeight: _selectedUnitNumber == 0 ? FontWeight.bold : FontWeight.normal,
                            ),
                            onSelected: (_) => setState(() => _selectedUnitNumber = 0),
                          ),
                          ...List.generate(8, (i) {
                            final unit = i + 1;
                            final isSel = _selectedUnitNumber == unit;
                            return Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: ChoiceChip(
                                label: Text('Unit $unit'),
                                selected: isSel,
                                selectedColor: const Color(0xFF006633),
                                labelStyle: TextStyle(
                                  color: isSel ? Colors.white : Colors.black87,
                                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                ),
                                onSelected: (_) => setState(() => _selectedUnitNumber = unit),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Material Type Selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTypeChip('All', 'All Items'),
                        const SizedBox(width: 8),
                        _buildTypeChip('short_q', 'Short Questions'),
                        const SizedBox(width: 8),
                        _buildTypeChip('long_q', 'Long Board Questions'),
                        const SizedBox(width: 8),
                        _buildTypeChip('mcq', 'MCQs Quiz'),
                      ],
                    ),
                  ],
                ),
              ),

              // Exercises List
              Expanded(
                child: filtered.isEmpty
                    ? const Center(
                        child: Text(
                          'No solved items match the selected filter.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          final isUnlocked = !item.isPaid || enrolledCourses.contains('fbise_cs_11');

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item.unitTitle,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF006633)),
                                      ),
                                      Chip(
                                        padding: EdgeInsets.zero,
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        backgroundColor: item.isPaid ? Colors.amber[800] : const Color(0xFF004D26),
                                        label: Text(
                                          item.isPaid ? 'Premium Expected Board Q' : 'Free Solved Answer',
                                          style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // Question
                                  Text(
                                    item.questionText,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  const SizedBox(height: 8),

                                  // If Locked Premium Content
                                  if (item.isPaid && !isUnlocked) ...[
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.amber[50],
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.amber[300]!),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.lock, color: Color(0xFF004D26)),
                                          const SizedBox(width: 8),
                                          const Expanded(
                                            child: Text(
                                              'Premium Expected Board Question Answer Locked.',
                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF006633),
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (_) => PaymentSubmissionDialog(
                                                  course: Course(
                                                    id: 'fbise_cs_11',
                                                    title: 'FBISE Grade 11 CS Complete Solved Solutions',
                                                    instructor: 'PCSA Faculty',
                                                    description: 'Full solved exercises and expected board questions',
                                                    category: 'FBISE',
                                                    grade: 'Class 11',
                                                    isPaid: true,
                                                    thumbnailUrl: '',
                                                    modules: const [],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Text('Unlock EasyPaisa/HBL', style: TextStyle(fontSize: 11)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ] else if (item.questionType == 'mcq') ...[
                                    // Interactive MCQ Choices
                                    ...item.options.asMap().entries.map((optEntry) {
                                      final optIdx = optEntry.key;
                                      final optText = optEntry.value;
                                      final selectedOpt = _userQuizAnswers[item.id];
                                      final isAns = selectedOpt != null;

                                      Color? tileColor;
                                      IconData icon = Icons.circle_outlined;
                                      Color iconColor = Colors.grey;

                                      if (isAns) {
                                        if (optIdx == item.correctOptionIndex) {
                                          tileColor = Colors.green[100];
                                          icon = Icons.check_circle;
                                          iconColor = Colors.green[800]!;
                                        } else if (optIdx == selectedOpt) {
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
                                          border: Border.all(color: Colors.grey[300]!),
                                        ),
                                        child: ListTile(
                                          dense: true,
                                          leading: Icon(icon, color: iconColor, size: 18),
                                          title: Text(optText, style: const TextStyle(fontSize: 13)),
                                          onTap: () {
                                            setState(() => _userQuizAnswers[item.id] = optIdx);
                                          },
                                        ),
                                      );
                                    }),
                                    if (_userQuizAnswers.containsKey(item.id) && item.explanation.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6.0),
                                        child: Text(
                                          'Explanation: ${item.explanation}',
                                          style: const TextStyle(fontSize: 12, color: Color(0xFF006633), fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                  ] else ...[
                                    // Text Answer
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey[300]!),
                                      ),
                                      child: SelectableText(
                                        item.answerText,
                                        style: const TextStyle(fontSize: 13, height: 1.4, color: Colors.black87),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTypeChip(String type, String label) {
    final isSelected = _selectedFilterType == type;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: const Color(0xFF004D26),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 11,
      ),
      onSelected: (_) => setState(() => _selectedFilterType = type),
    );
  }
}
