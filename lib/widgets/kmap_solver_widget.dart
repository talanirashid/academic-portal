import 'package:flutter/material.dart';

class KMapSolverWidget extends StatefulWidget {
  const KMapSolverWidget({super.key});

  @override
  State<KMapSolverWidget> createState() => _KMapSolverWidgetState();
}

class _KMapSolverWidgetState extends State<KMapSolverWidget> {
  int _variables = 2; // 2 or 3
  
  // 2-Variable: A (rows 0-1), B (cols 0-1)
  final List<List<int>> _grid2 = [
    [0, 0],
    [0, 0]
  ];

  // 3-Variable: A (rows 0-1), BC (cols 00, 01, 11, 10)
  final List<List<int>> _grid3 = [
    [0, 0, 0, 0],
    [0, 0, 0, 0]
  ];

  void _toggleCell(int r, int c) {
    setState(() {
      if (_variables == 2) {
        _grid2[r][c] = _grid2[r][c] == 0 ? 1 : 0;
      } else {
        _grid3[r][c] = _grid3[r][c] == 0 ? 1 : 0;
      }
    });
  }

  String _getMinterms() {
    List<int> minterms = [];
    if (_variables == 2) {
      if (_grid2[0][0] == 1) minterms.add(0);
      if (_grid2[0][1] == 1) minterms.add(1);
      if (_grid2[1][0] == 1) minterms.add(2);
      if (_grid2[1][1] == 1) minterms.add(3);
    } else {
      if (_grid3[0][0] == 1) minterms.add(0);
      if (_grid3[0][1] == 1) minterms.add(1);
      if (_grid3[0][2] == 1) minterms.add(3);
      if (_grid3[0][3] == 1) minterms.add(2);
      if (_grid3[1][0] == 1) minterms.add(4);
      if (_grid3[1][1] == 1) minterms.add(5);
      if (_grid3[1][2] == 1) minterms.add(7);
      if (_grid3[1][3] == 1) minterms.add(6);
    }
    
    if (minterms.isEmpty) return 'Y = 0';
    if (minterms.length == (_variables == 2 ? 4 : 8)) return 'Y = 1';
    
    minterms.sort();
    return 'Σ m(${minterms.join(', ')})';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.grid_on, color: Colors.purple),
                SizedBox(width: 8),
                Text('Karnaugh Map (K-Map) Explorer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ChoiceChip(
                  label: const Text('2-Variable (A, B)'),
                  selected: _variables == 2,
                  onSelected: (val) { if (val) setState(() => _variables = 2); },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('3-Variable (A, B, C)'),
                  selected: _variables == 3,
                  onSelected: (val) { if (val) setState(() => _variables = 3); },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: _variables == 2 ? _build2VarMap() : _build3VarMap(),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  const Text('Active Minterms (SOP)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
                  const SizedBox(height: 8),
                  Text(_getMinterms(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _build2VarMap() {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 40),
            SizedBox(width: 60, child: Text('B\' (0)', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
            SizedBox(width: 60, child: Text('B (1)', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 40, child: Text('A\' (0)', style: TextStyle(fontWeight: FontWeight.bold))),
            _buildCell(0, 0, 'm0'),
            _buildCell(0, 1, 'm1'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 40, child: Text('A (1)', style: TextStyle(fontWeight: FontWeight.bold))),
            _buildCell(1, 0, 'm2'),
            _buildCell(1, 1, 'm3'),
          ],
        ),
      ],
    );
  }

  Widget _build3VarMap() {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 40),
            SizedBox(width: 60, child: Text('B\'C\' (00)', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
            SizedBox(width: 60, child: Text('B\'C (01)', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
            SizedBox(width: 60, child: Text('BC (11)', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
            SizedBox(width: 60, child: Text('BC\' (10)', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 40, child: Text('A\' (0)', style: TextStyle(fontWeight: FontWeight.bold))),
            _buildCell(0, 0, 'm0'),
            _buildCell(0, 1, 'm1'),
            _buildCell(0, 2, 'm3'),
            _buildCell(0, 3, 'm2'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 40, child: Text('A (1)', style: TextStyle(fontWeight: FontWeight.bold))),
            _buildCell(1, 0, 'm4'),
            _buildCell(1, 1, 'm5'),
            _buildCell(1, 2, 'm7'),
            _buildCell(1, 3, 'm6'),
          ],
        ),
      ],
    );
  }

  Widget _buildCell(int r, int c, String label) {
    final int val = _variables == 2 ? _grid2[r][c] : _grid3[r][c];
    return GestureDetector(
      onTap: () => _toggleCell(r, c),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          color: val == 1 ? Colors.purple.shade100 : Colors.white,
        ),
        child: Stack(
          children: [
            Positioned(top: 2, left: 2, child: Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey))),
            Center(child: Text('$val', style: TextStyle(fontSize: 24, fontWeight: val == 1 ? FontWeight.bold : FontWeight.normal, color: val == 1 ? Colors.purple : Colors.black26))),
          ],
        ),
      ),
    );
  }
}
