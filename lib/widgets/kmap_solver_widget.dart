import 'package:flutter/material.dart';

/// Interactive 2-Variable Karnaugh Map (K-Map) solver widget.
class KMapSolverWidget extends StatefulWidget {
  const KMapSolverWidget({super.key});

  @override
  State<KMapSolverWidget> createState() => _KMapSolverWidgetState();
}

class _KMapSolverWidgetState extends State<KMapSolverWidget> {
  // 2x2 grid representing minterms m0, m1, m2, m3
  final List<bool> _cells = [false, false, false, false];

  String _solveSOP() {
    int count = _cells.where((c) => c).length;
    if (count == 0) return '0 (Always LOW)';
    if (count == 4) return '1 (Always HIGH)';

    // m0=A'B', m1=A'B, m2=AB', m3=AB
    bool m0 = _cells[0];
    bool m1 = _cells[1];
    bool m2 = _cells[2];
    bool m3 = _cells[3];

    // Groups of 2
    if (m0 && m1 && m2 && !m3) return "A' + B'";
    if (m0 && m1) return "A'";
    if (m2 && m3) return "A";
    if (m0 && m2) return "B'";
    if (m1 && m3) return "B";

    List<String> minterms = [];
    if (m0) minterms.add("A'B'");
    if (m1) minterms.add("A'B");
    if (m2) minterms.add("AB'");
    if (m3) minterms.add("AB");

    return minterms.join(" + ");
  }

  @override
  Widget build(BuildContext context) {
    final sop = _solveSOP();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.grid_4x4, color: Color(0xFF006633)),
                SizedBox(width: 8),
                Text(
                  'Karnaugh Map (K-Map) 2-Variable Solver',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Tap K-Map grid cells below to toggle 0 / 1 minterms and view live SOP boolean simplification:',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 12),

            // K-Map Grid
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 24),
                    const Text("A' (0) ", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 36),
                    const Text("A (1) ", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: [
                    const Row(
                      children: [
                        SizedBox(width: 20),
                        Text("B' (0)", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 45),
                        Text("B (1)", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildKMapCell(0, "m0 (0,0)"),
                        _buildKMapCell(1, "m1 (0,1)"),
                      ],
                    ),
                    Row(
                      children: [
                        _buildKMapCell(2, "m2 (1,0)"),
                        _buildKMapCell(3, "m3 (1,1)"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Simplified SOP Expression
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF006633).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF006633)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.functions, color: Color(0xFF006633)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Simplified SOP Output:  F = $sop',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
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

  Widget _buildKMapCell(int index, String label) {
    final val = _cells[index];
    return GestureDetector(
      onTap: () {
        setState(() {
          _cells[index] = !_cells[index];
        });
      },
      child: Container(
        width: 70,
        height: 55,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: val ? Colors.green[700] : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: val ? Colors.green[900]! : Colors.grey[400]!, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              val ? '1' : '0',
              style: TextStyle(
                color: val ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: val ? Colors.white70 : Colors.grey[600],
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
