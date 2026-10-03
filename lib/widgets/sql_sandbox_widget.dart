import 'package:flutter/material.dart';

class StudentRow {
  final int id;
  final String name;
  final int marks;
  final String city;

  const StudentRow(this.id, this.name, this.marks, this.city);
}

/// Interactive SQL Query Sandbox for Class 12 DBMS Chapters.
class SqlSandboxWidget extends StatefulWidget {
  const SqlSandboxWidget({super.key});

  @override
  State<SqlSandboxWidget> createState() => _SqlSandboxWidgetState();
}

class _SqlSandboxWidgetState extends State<SqlSandboxWidget> {
  String _selectedQuery = 'SELECT * FROM Students WHERE marks >= 75';

  final List<StudentRow> _allStudents = const [
    StudentRow(101, 'Ali Raza', 88, 'Karachi'),
    StudentRow(102, 'Fatima Khan', 92, 'Islamabad'),
    StudentRow(103, 'Usman Tariq', 64, 'Lahore'),
    StudentRow(104, 'Zainab Ahmed', 78, 'Peshawar'),
    StudentRow(105, 'Hamza Malik', 85, 'Rawalpindi'),
  ];

  final List<String> _queries = const [
    'SELECT * FROM Students WHERE marks >= 75',
    'SELECT * FROM Students WHERE marks < 75',
    'SELECT * FROM Students ORDER BY marks DESC',
  ];

  @override
  Widget build(BuildContext context) {
    List<StudentRow> filtered = List.from(_allStudents);

    if (_selectedQuery.contains('>= 75')) {
      filtered = filtered.where((s) => s.marks >= 75).toList();
    } else if (_selectedQuery.contains('< 75')) {
      filtered = filtered.where((s) => s.marks < 75).toList();
    } else if (_selectedQuery.contains('ORDER BY marks DESC')) {
      filtered.sort((a, b) => b.marks.compareTo(a.marks));
    }

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
                    Icon(Icons.storage, color: Color(0xFF006633)),
                    SizedBox(width: 8),
                    Text(
                      'DBMS SQL Query Sandbox',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                    ),
                  ],
                ),
                DropdownButton<String>(
                  value: _selectedQuery,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF006633)),
                  underline: const SizedBox(),
                  items: _queries.map((q) => DropdownMenuItem(value: q, child: Text(q))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedQuery = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Table Result
            Table(
              border: TableBorder.all(color: Colors.grey[300]!),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[100]),
                  children: const [
                    Padding(padding: EdgeInsets.all(6), child: Text('ID', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(6), child: Text('Name', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(6), child: Text('Marks', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(6), child: Text('City', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
                ...filtered.map((s) {
                  return TableRow(
                    children: [
                      Padding(padding: const EdgeInsets.all(6), child: Text('${s.id}', textAlign: TextAlign.center)),
                      Padding(padding: const EdgeInsets.all(6), child: Text(s.name, textAlign: TextAlign.center)),
                      Padding(padding: const EdgeInsets.all(6), child: Text('${s.marks}', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF006633)))),
                      Padding(padding: const EdgeInsets.all(6), child: Text(s.city, textAlign: TextAlign.center)),
                    ],
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
