import 'package:flutter/material.dart';

class AcronymItem {
  final String acronym;
  final String fullForm;
  final String category;

  const AcronymItem({
    required this.acronym,
    required this.fullForm,
    required this.category,
  });
}

/// Expandable Computing Acronyms Glossary for board revision.
class AcronymGlossaryWidget extends StatelessWidget {
  const AcronymGlossaryWidget({super.key});

  final List<AcronymItem> _acronyms = const [
    AcronymItem(acronym: 'ALU', fullForm: 'Arithmetic Logic Unit', category: 'Architecture'),
    AcronymItem(acronym: 'BIOS', fullForm: 'Basic Input/Output System', category: 'Operating System'),
    AcronymItem(acronym: 'CMOS', fullForm: 'Complementary Metal-Oxide Semiconductor', category: 'Hardware'),
    AcronymItem(acronym: 'DRAM', fullForm: 'Dynamic Random Access Memory', category: 'Memory'),
    AcronymItem(acronym: 'EEPROM', fullForm: 'Electrically Erasable Programmable Read-Only Memory', category: 'Memory'),
    AcronymItem(acronym: 'FIFO', fullForm: 'First In, First Out', category: 'Data Structures'),
    AcronymItem(acronym: 'ISP', fullForm: 'Internet Service Provider', category: 'Networking'),
    AcronymItem(acronym: 'OSI', fullForm: 'Open Systems Interconnection', category: 'Networking'),
    AcronymItem(acronym: 'SQL', fullForm: 'Structured Query Language', category: 'Databases'),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: const Icon(Icons.spellcheck, color: Color(0xFF006633)),
        title: const Text(
          'Computing Acronyms & Glossary',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF004D26)),
        ),
        subtitle: const Text('Quick board exam acronym definitions'),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: _acronyms.map((item) {
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Chip(
                    backgroundColor: const Color(0xFF006633),
                    labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                    label: Text(item.acronym),
                  ),
                  title: Text(item.fullForm, style: const TextStyle(fontWeight: FontWeight.w600)),
                  trailing: Text(item.category, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
