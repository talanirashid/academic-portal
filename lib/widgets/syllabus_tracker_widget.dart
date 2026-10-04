import 'package:flutter/material.dart';

/// Interactive Syllabus Preparation Tracker Widget.
class SyllabusTrackerWidget extends StatefulWidget {
  final String courseTitle;

  const SyllabusTrackerWidget({super.key, this.courseTitle = 'Class 11 Computer Science (FBISE)'});

  @override
  State<SyllabusTrackerWidget> createState() => _SyllabusTrackerWidgetState();
}

class _SyllabusTrackerWidgetState extends State<SyllabusTrackerWidget> {
  final Map<String, bool> _checklist = {
    'Unit 1: Computer Systems & Logic': true,
    'Unit 2: Computer Memory Mechanisms': true,
    'Unit 3: CPU Architecture & Registers': true,
    'Unit 4: Inside Bus Architecture': false,
    'Unit 5: Data Communication & Networks': true,
    'Unit 6: Wireless Communications': false,
    'Unit 7: Database Fundamentals & DBMS': false,
    'Unit 8: Security & Ethics': false,
  };

  @override
  Widget build(BuildContext context) {
    int total = _checklist.length;
    int completed = _checklist.values.where((v) => v).length;
    double percent = (completed / total);

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
                Row(
                  children: [
                    const Icon(Icons.analytics, color: Color(0xFF006633)),
                    const SizedBox(width: 8),
                    Text(
                      'Syllabus Preparation Tracker',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF004D26)),
                    ),
                  ],
                ),
                Chip(
                  backgroundColor: const Color(0xFF006633).withValues(alpha: 0.1),
                  label: Text(
                    '${(percent * 100).toInt()}% Prepared',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF006633)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.grey[200],
              color: const Color(0xFF006633),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 12),

            // Unit Topic Checklist
            ..._checklist.entries.map((entry) {
              return CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                activeColor: const Color(0xFF006633),
                title: Text(entry.key, style: TextStyle(fontSize: 13, decoration: entry.value ? TextDecoration.lineThrough : null)),
                value: entry.value,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _checklist[entry.key] = val);
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
