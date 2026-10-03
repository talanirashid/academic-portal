import 'package:flutter/material.dart';

/// ER Diagram Cardinality & Normalization Step-by-Step Guide for FBISE Class 11 Unit 7.
class ErDiagramNormalizationWidget extends StatefulWidget {
  const ErDiagramNormalizationWidget({super.key});

  @override
  State<ErDiagramNormalizationWidget> createState() => _ErDiagramNormalizationWidgetState();
}

class _ErDiagramNormalizationWidgetState extends State<ErDiagramNormalizationWidget> {
  int _selectedTab = 0; // 0: Normalization Steps, 1: ER Diagram Cardinality

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.schema, color: Color(0xFF006633)),
                    SizedBox(width: 8),
                    Text(
                      'FBISE Unit 7: ER Diagram & Normalization Guide',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                    ),
                  ],
                ),
                ToggleButtons(
                  isSelected: [_selectedTab == 0, _selectedTab == 1],
                  borderRadius: BorderRadius.circular(8),
                  selectedColor: Colors.white,
                  fillColor: const Color(0xFF006633),
                  constraints: const BoxConstraints(minHeight: 32, minWidth: 100),
                  onPressed: (idx) => setState(() => _selectedTab = idx),
                  children: const [
                    Text('Normalization', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                    Text('ER Cardinality', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (_selectedTab == 0) ...[
              _buildNormStepTile('1NF (First Normal Form)', 'Eliminate repeating groups. Each attribute column must contain atomic (indivisible) values.'),
              _buildNormStepTile('2NF (Second Normal Form)', 'Must be in 1NF. Eliminate partial dependencies (non-key attribute depends on only part of Composite Primary Key).'),
              _buildNormStepTile('3NF (Third Normal Form)', 'Must be in 2NF. Eliminate transitive dependencies (non-key attribute depends on another non-key attribute).'),
            ] else ...[
              _buildCardinalityTile('1:1 (One-to-One)', 'Example: Citizen to CNIC Card. One citizen holds exactly one CNIC.'),
              _buildCardinalityTile('1:N (One-to-Many)', 'Example: Department to Students. One CS department contains many students.'),
              _buildCardinalityTile('M:N (Many-to-Many)', 'Example: Students to Courses. Many students enroll in many courses (requires junction bridge table).'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNormStepTile(String title, String rule) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF006633).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF006633).withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF006633), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF004D26))),
                const SizedBox(height: 2),
                Text(rule, style: const TextStyle(fontSize: 12, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardinalityTile(String title, String rule) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.swap_horiz, color: Color(0xFF006633), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF004D26))),
                const SizedBox(height: 2),
                Text(rule, style: const TextStyle(fontSize: 12, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
