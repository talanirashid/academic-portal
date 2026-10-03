import 'package:flutter/material.dart';

class CppProgram {
  final String title;
  final String code;
  final String output;
  final String traceExplanation;

  const CppProgram({
    required this.title,
    required this.code,
    required this.output,
    required this.traceExplanation,
  });
}

/// Interactive C++ Code Runner & Memory Variable Trace Visualizer for Class 12 CS.
class CppCodeRunnerWidget extends StatefulWidget {
  const CppCodeRunnerWidget({super.key});

  @override
  State<CppCodeRunnerWidget> createState() => _CppCodeRunnerWidgetState();
}

class _CppCodeRunnerWidgetState extends State<CppCodeRunnerWidget> {
  int _selectedProgramIndex = 0;

  final List<CppProgram> _programs = const [
    CppProgram(
      title: '1. Array Traversal & Sum',
      code: '''#include <iostream>
using namespace std;

int main() {
    int arr[5] = {10, 20, 30, 40, 50};
    int sum = 0;
    for(int i = 0; i < 5; i++) {
        sum += arr[i];
    }
    cout << "Total Sum = " << sum << endl;
    return 0;
}''',
      output: 'Total Sum = 150',
      traceExplanation:
          'i=0: sum=10 | i=1: sum=30 | i=2: sum=60 | i=3: sum=100 | i=4: sum=150. Loop terminates when i=5.',
    ),
    CppProgram(
      title: '2. Pointer Memory Allocation',
      code: '''#include <iostream>
using namespace std;

int main() {
    int var = 25;
    int* ptr = &var;
    cout << "Value = " << *ptr << endl;
    cout << "Memory Address = " << ptr << endl;
    return 0;
}''',
      output: 'Value = 25\nMemory Address = 0x7ffeefbff5bc',
      traceExplanation:
          '*ptr dereferences the memory address to yield 25. ptr holds the hexadecimal RAM address.',
    ),
    CppProgram(
      title: '3. Structure (struct Student)',
      code: '''#include <iostream>
using namespace std;

struct Student {
    int rollNo;
    float marks;
};

int main() {
    Student s1 = {101, 88.5};
    cout << "Roll No: " << s1.rollNo << ", Marks: " << s1.marks << endl;
    return 0;
}''',
      output: 'Roll No: 101, Marks: 88.5',
      traceExplanation:
          'Student struct aggregates integer rollNo and float marks in contiguous memory.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final prog = _programs[_selectedProgramIndex];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.code, color: Color(0xFF006633)),
                    SizedBox(width: 8),
                    Text(
                      'Class 12 C++ Code Runner & Memory Tracer',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                    ),
                  ],
                ),
                DropdownButton<int>(
                  value: _selectedProgramIndex,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF006633)),
                  underline: const SizedBox(),
                  items: _programs.asMap().entries.map((entry) {
                    return DropdownMenuItem(value: entry.key, child: Text(entry.value.title));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedProgramIndex = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Code View
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0B132B),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                prog.code,
                style: const TextStyle(
                  fontFamily: 'Courier',
                  color: Color(0xFF10B981),
                  fontSize: 13,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Simulated Terminal Output
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Terminal Output stdout:', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  const SizedBox(height: 4),
                  Text(
                    prog.output,
                    style: const TextStyle(color: Colors.white, fontFamily: 'Courier', fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Memory Variable Trace
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.memory, color: Colors.blue, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Variable Memory Trace: ${prog.traceExplanation}',
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
