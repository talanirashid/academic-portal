import 'package:flutter/material.dart';

class BadgeItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const BadgeItem(this.title, this.subtitle, this.icon, this.color);
}

/// Widget displaying student gamified subject mastery badges & 🔥 5-Day Study Streak.
class StudentBadgesWidget extends StatelessWidget {
  const StudentBadgesWidget({super.key});

  final List<BadgeItem> _badges = const [
    BadgeItem('Logic Guru', 'Completed Logic Gates & K-Maps', Icons.memory, Color(0xFF006633)),
    BadgeItem('Binary Architect', 'Mastered Base Conversions & 2\'s Comp', Icons.numbers, Colors.amber),
    BadgeItem('C++ Master', 'Completed Pointers & Structs', Icons.code, Colors.blue),
    BadgeItem('SQL Wizard', 'Mastered DBMS Queries & Normalization', Icons.storage, Colors.purple),
    BadgeItem('Board Ready', 'Completed 5-Year Past Papers', Icons.military_tech, Colors.orange),
  ];

  void _showLeaderboardModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.leaderboard, color: Color(0xFF006633)),
              SizedBox(width: 8),
              Text('PCSA Regional Board Leaderboard'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const CircleAvatar(backgroundColor: Colors.amber, child: Text('1', style: TextStyle(fontWeight: FontWeight.bold))),
                title: const Text('Muhammad Ali (Class 11)'),
                subtitle: const Text('FBISE Federal Board • 98% Score'),
                trailing: const Icon(Icons.stars, color: Colors.amber),
              ),
              ListTile(
                leading: CircleAvatar(backgroundColor: Colors.grey[300], child: const Text('2', style: TextStyle(fontWeight: FontWeight.bold))),
                title: const Text('Syeda Fatima (Class 12)'),
                subtitle: const Text('BIEK Karachi • 95% Score'),
              ),
              ListTile(
                leading: CircleAvatar(backgroundColor: Colors.amber[900], child: const Text('3', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                title: const Text('Zaid Khan (Class 11)'),
                subtitle: const Text('BISE Sukkur • 92% Score'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: Color(0xFF006633), fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Subject Mastery Badges',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF004D26)),
            ),
            InkWell(
              onTap: () => _showLeaderboardModal(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber[800]!),
                ),
                child: const Row(
                  children: [
                    Text('🔥 5-Day Streak', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF004D26))),
                    SizedBox(width: 4),
                    Icon(Icons.leaderboard, size: 14, color: Color(0xFF004D26)),
                  ],
                ),
              ),
            ),
          ],
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
