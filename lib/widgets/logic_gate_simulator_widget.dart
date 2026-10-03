import 'package:flutter/material.dart';

/// Interactive logic gate playground allowing students to toggle inputs and evaluate gate outputs.
class LogicGateSimulatorWidget extends StatefulWidget {
  const LogicGateSimulatorWidget({super.key});

  @override
  State<LogicGateSimulatorWidget> createState() => _LogicGateSimulatorWidgetState();
}

class _LogicGateSimulatorWidgetState extends State<LogicGateSimulatorWidget> {
  String _selectedGate = 'AND';
  bool _inputA = false;
  bool _inputB = false;

  final List<String> _gates = ['AND', 'OR', 'NOT', 'NAND', 'NOR', 'XOR', 'XNOR'];

  bool _evaluateGate(String gate, bool a, bool b) {
    switch (gate) {
      case 'AND':
        return a && b;
      case 'OR':
        return a || b;
      case 'NOT':
        return !a;
      case 'NAND':
        return !(a && b);
      case 'NOR':
        return !(a || b);
      case 'XOR':
        return a != b;
      case 'XNOR':
        return a == b;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final output = _evaluateGate(_selectedGate, _inputA, _inputB);

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
                    Icon(Icons.memory, color: Color(0xFF006633)),
                    SizedBox(width: 8),
                    Text(
                      'Interactive Logic Gate Simulator',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                    ),
                  ],
                ),
                DropdownButton<String>(
                  value: _selectedGate,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF006633)),
                  underline: const SizedBox(),
                  items: _gates
                      .map((g) => DropdownMenuItem(value: g, child: Text('$g Gate')))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedGate = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Interactive Circuit Board View
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF00381B),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Inputs Column
                  Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _inputA ? Colors.green : Colors.grey[800],
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => setState(() => _inputA = !_inputA),
                        child: Text('Input A: ${_inputA ? "1 (HIGH)" : "0 (LOW)"}'),
                      ),
                      if (_selectedGate != 'NOT') ...[
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _inputB ? Colors.green : Colors.grey[800],
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => setState(() => _inputB = !_inputB),
                          child: Text('Input B: ${_inputB ? "1 (HIGH)" : "0 (LOW)"}'),
                        ),
                      ],
                    ],
                  ),

                  // Gate Symbol Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.amber, width: 2),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black26,
                    ),
                    child: Text(
                      _selectedGate,
                      style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),

                  // Output Badge
                  Column(
                    children: [
                      const Text('Output (Y)', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: output ? Colors.green : Colors.red[900],
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          output ? '1' : '0',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Generated Truth Table
            const Text(
              'Truth Table Matrix:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 6),
            Table(
              border: TableBorder.all(color: Colors.grey[300]!),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[100]),
                  children: [
                    const Padding(padding: EdgeInsets.all(6), child: Text('A', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                    if (_selectedGate != 'NOT')
                      const Padding(padding: EdgeInsets.all(6), child: Text('B', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: const EdgeInsets.all(6), child: Text('Output ($_selectedGate)', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
                ..._generateTruthTableRows(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<TableRow> _generateTruthTableRows() {
    final combinations = _selectedGate == 'NOT'
        ? [
            [false, false],
            [true, false],
          ]
        : [
            [false, false],
            [false, true],
            [true, false],
            [true, true],
          ];

    return combinations.map((pair) {
      final a = pair[0];
      final b = pair[1];
      final res = _evaluateGate(_selectedGate, a, b);
      final isActiveRow = (_selectedGate == 'NOT')
          ? (_inputA == a)
          : (_inputA == a && _inputB == b);

      return TableRow(
        decoration: isActiveRow ? BoxDecoration(color: Colors.green[100]) : null,
        children: [
          Padding(padding: const EdgeInsets.all(6), child: Text(a ? '1' : '0', textAlign: TextAlign.center)),
          if (_selectedGate != 'NOT')
            Padding(padding: const EdgeInsets.all(6), child: Text(b ? '1' : '0', textAlign: TextAlign.center)),
          Padding(
            padding: const EdgeInsets.all(6),
            child: Text(
              res ? '1' : '0',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: isActiveRow ? FontWeight.bold : FontWeight.normal),
            ),
          ),
        ],
      );
    }).toList();
  }
}
