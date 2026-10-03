import 'package:flutter/material.dart';

class CheatSheetUnit {
  final String title;
  final List<String> bulletPoints;

  const CheatSheetUnit({required this.title, required this.bulletPoints});
}

/// 1-Page "Exam Night" Cheat Sheet Screen for high-yield board revision.
class ExamCheatSheetScreen extends StatelessWidget {
  const ExamCheatSheetScreen({super.key});

  final List<CheatSheetUnit> _units = const [
    CheatSheetUnit(
      title: 'Unit 1: Computer Systems & Architecture',
      bulletPoints: [
        'ALU performs arithmetic (+, -) and logical (AND, OR) operations; Control Unit supervises instruction cycle.',
        'Data Bus is bidirectional; Address Bus is unidirectional (CPU -> Memory).',
        'RAM is volatile primary storage; ROM contains permanent BIOS boot code.',
        'Cache Memory (L1, L2, L3) sits between CPU and RAM to bridge speed gaps.',
      ],
    ),
    CheatSheetUnit(
      title: 'Unit 2: Data Communication & Networks',
      bulletPoints: [
        'OSI Model 7 Layers: Physical, Data Link, Network, Transport, Session, Presentation, Application.',
        'Star Topology uses central Hub/Switch; Ring Topology uses token passing.',
        'IP Address (IPv4: 32 bits / 4 octets); MAC Address (48 bits hexadecimal hardware ID).',
      ],
    ),
    CheatSheetUnit(
      title: 'Unit 3: Operating Systems & Process Management',
      bulletPoints: [
        'Operating System manages CPU scheduling, memory allocation, and file systems.',
        'Process States: New -> Ready -> Running -> Waiting -> Terminated.',
        'FCFS is non-preemptive; Round Robin uses time-quantum slicing.',
      ],
    ),
    CheatSheetUnit(
      title: 'Unit 4: Class 12 C++ Programming & Data Structures',
      bulletPoints: [
        'Stack works on LIFO (Last-In First-Out); Queue works on FIFO (First-In First-Out).',
        'Pointers store memory addresses; dereference operator (*) accesses value at pointer.',
        'Arrays store homogeneous elements in contiguous memory locations.',
      ],
    ),
    CheatSheetUnit(
      title: 'Unit 5: Relational Databases & SQL Queries',
      bulletPoints: [
        'Primary Key uniquely identifies each row; Foreign Key links to Primary Key in another table.',
        '1NF eliminates repeating groups; 2NF eliminates partial dependencies; 3NF eliminates transitive dependencies.',
        'SQL SELECT syntax: SELECT column_list FROM table_name WHERE condition ORDER BY column;',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('1-Page Exam Night Cheat Sheet'),
        backgroundColor: const Color(0xFF004D26),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _units.length,
        itemBuilder: (context, index) {
          final unit = _units[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    unit.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF004D26)),
                  ),
                  const Divider(height: 16),
                  ...unit.bulletPoints.map((point) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF006633))),
                          Expanded(
                            child: Text(
                              point,
                              style: const TextStyle(fontSize: 13, height: 1.3, color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
