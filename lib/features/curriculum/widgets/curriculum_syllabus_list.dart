import 'package:flutter/material.dart';
import '../models/chapter_resource_model.dart';
import '../repositories/curriculum_repository.dart';
import '../screens/unit_detail_screen.dart';

/// Tabbed Syllabus Unit List switching between STBB and FBISE across Classes 9th-12th.
class CurriculumSyllabusList extends StatefulWidget {
  const CurriculumSyllabusList({super.key});

  @override
  State<CurriculumSyllabusList> createState() => _CurriculumSyllabusListState();
}

class _CurriculumSyllabusListState extends State<CurriculumSyllabusList> {
  final CurriculumRepository _repository = CurriculumRepository();

  String _selectedStream = 'stbb'; // 'stbb' or 'fbise'
  String _selectedClass = 'class_11'; // 'class_09', 'class_10', 'class_11', 'class_12'

  final List<Map<String, String>> _classList = [
    {'id': 'class_09', 'label': 'Class 9th (SSC-I)'},
    {'id': 'class_10', 'label': 'Class 10th (SSC-II)'},
    {'id': 'class_11', 'label': 'Class 11th (HSSC-I)'},
    {'id': 'class_12', 'label': 'Class 12th (HSSC-II)'},
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stream Segmented Choice
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.collections_bookmark, color: Color(0xFF006633)),
                    SizedBox(width: 8),
                    Text(
                      'Syllabus Units & DataCenter Vault',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF004D26)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text('STBB Sindh Board'),
                      selected: _selectedStream == 'stbb',
                      selectedColor: const Color(0xFF006633),
                      labelStyle: TextStyle(color: _selectedStream == 'stbb' ? Colors.white : Colors.black87, fontWeight: FontWeight.bold),
                      onSelected: (_) => setState(() => _selectedStream = 'stbb'),
                    ),
                    const SizedBox(width: 6),
                    ChoiceChip(
                      label: const Text('FBISE Federal Board'),
                      selected: _selectedStream == 'fbise',
                      selectedColor: const Color(0xFF006633),
                      labelStyle: TextStyle(color: _selectedStream == 'fbise' ? Colors.white : Colors.black87, fontWeight: FontWeight.bold),
                      onSelected: (_) => setState(() => _selectedStream = 'fbise'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Class Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _classList.map((c) {
                  final isSelected = _selectedClass == c['id'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(c['label']!),
                      selected: isSelected,
                      selectedColor: Colors.amber[700],
                      labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                      onSelected: (_) => setState(() => _selectedClass = c['id']!),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Unit Stream List
            StreamBuilder<List<ChapterResourceModel>>(
              stream: _repository.streamUnits(stream: _selectedStream, targetClass: _selectedClass),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator(color: Color(0xFF006633))));
                }

                final units = snapshot.data ?? [];

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: units.length,
                  itemBuilder: (context, index) {
                    final unit = units[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      color: Colors.grey[50],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey[300]!)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF006633),
                          child: Text('${unit.unitNumber}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        title: Text(unit.unitTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        subtitle: Text(unit.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Colors.black87)),
                        trailing: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF006633),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UnitDetailScreen(
                                  unit: unit,
                                  screenTitle: '${_selectedStream.toUpperCase()} Unit ${unit.unitNumber}',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_forward, size: 14),
                          label: const Text('Open Unit', style: TextStyle(fontSize: 11)),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
