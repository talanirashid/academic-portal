import 'package:flutter/material.dart';

class BadgeItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const BadgeItem(this.title, this.subtitle, this.icon, this.color);
}

/// Widget displaying student gamified subject mastery badges.
class StudentBadgesWidget extends StatelessWidget {
  const StudentBadgesWidget({super.key});

  final List<BadgeItem> _badges = const [
    BadgeItem('Logic Guru', 'Completed Logic Gates & K-Maps', Icons.memory, Color(0xFF006633)),
    BadgeItem('Binary Architect', 'Mastered Base Conversions & 2\'s Comp', Icons.numbers, Colors.amber),
    BadgeItem('C++ Master', 'Completed Pointers & Structs', Icons.code, Colors.blue),
    BadgeItem('SQL Wizard', 'Mastered DBMS Queries & Normalization', Icons.storage, Colors.purple),
    BadgeItem('Board Ready', 'Completed 5-Year Past Papers', Icons.military_tech, Colors.orange),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Subject Mastery Badges',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF004D26)),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _badges.map((b) {
              return Container(
                width: 130,
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: b.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: b.color.withValues(alpha: 0.4)),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: b.color,
                      radius: 18,
                      child: Icon(b.icon, color: Colors.white, size: 20),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      b.title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: b.color),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      b.subtitle,
                      style: const TextStyle(fontSize: 9, color: Colors.grey),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
