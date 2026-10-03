import 'package:flutter/material.dart';

/// Countdown timer widget displaying days remaining until Federal and Provincial board exams.
class ExamCountdownWidget extends StatelessWidget {
  const ExamCountdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final fbiseDate = DateTime(now.year, 5, 10); // Targeted FBISE Annual Exams
    final sindhDate = DateTime(now.year, 5, 20); // Targeted Sindh Board Annual Exams

    final fbiseDays = fbiseDate.difference(now).inDays;
    final sindhDays = sindhDate.difference(now).inDays;

    return Container(
      width: double.infinity,
      color: const Color(0xFF00381B),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.timer, color: Colors.amber, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '🎯 Annual Board Exam Countdown: FBISE (${fbiseDays > 0 ? "$fbiseDays Days" : "Exam Active"}) • Sindh Board (${sindhDays > 0 ? "$sindhDays Days" : "Exam Active"})',
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
