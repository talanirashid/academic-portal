import 'package:flutter/material.dart';

class LogicGateSimulatorWidget extends StatefulWidget {
  const LogicGateSimulatorWidget({super.key});

  @override
  State<LogicGateSimulatorWidget> createState() => _LogicGateSimulatorWidgetState();
}

class _LogicGateSimulatorWidgetState extends State<LogicGateSimulatorWidget> {
  String _selectedGate = 'AND';
  int _inputA = 0;
  int _inputB = 0;

  final List<String> _gates = ['AND', 'OR', 'NOT', 'NAND', 'NOR', 'XOR', 'XNOR'];

  int _calculateOutput() {
    switch (_selectedGate) {
      case 'AND': return (_inputA == 1 && _inputB == 1) ? 1 : 0;
      case 'OR': return (_inputA == 1 || _inputB == 1) ? 1 : 0;
      case 'NOT': return (_inputA == 0) ? 1 : 0; // NOT only uses Input A
      case 'NAND': return (_inputA == 1 && _inputB == 1) ? 0 : 1;
      case 'NOR': return (_inputA == 0 && _inputB == 0) ? 1 : 0;
      case 'XOR': return (_inputA != _inputB) ? 1 : 0;
      case 'XNOR': return (_inputA == _inputB) ? 1 : 0;
      default: return 0;
    }
  }

  Widget _buildTruthTable() {
    final bool isSingleInput = _selectedGate == 'NOT';
    final rows = isSingleInput
        ? [ [0, 0, _calculateOutputFor(0, 0)], [1, 0, _calculateOutputFor(1, 0)] ]
        : [
            [0, 0, _calculateOutputFor(0, 0)],
            [0, 1, _calculateOutputFor(0, 1)],
            [1, 0, _calculateOutputFor(1, 0)],
            [1, 1, _calculateOutputFor(1, 1)],
          ];

    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          children: [
            const Padding(padding: EdgeInsets.all(8.0), child: Text('Input A', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
            if (!isSingleInput) const Padding(padding: EdgeInsets.all(8.0), child: Text('Input B', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
            const Padding(padding: EdgeInsets.all(8.0), child: Text('Output Y', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        ...rows.map((row) {
          final bool isCurrentState = isSingleInput
              ? (row[0] == _inputA)
              : (row[0] == _inputA && row[1] == _inputB);

          return TableRow(
            decoration: BoxDecoration(color: isCurrentState ? Colors.amber.shade100 : Colors.white),
            children: [
              Padding(padding: const EdgeInsets.all(8.0), child: Text('${row[0]}', textAlign: TextAlign.center, style: TextStyle(fontWeight: isCurrentState ? FontWeight.bold : FontWeight.normal))),
              if (!isSingleInput) Padding(padding: const EdgeInsets.all(8.0), child: Text('${row[1]}', textAlign: TextAlign.center, style: TextStyle(fontWeight: isCurrentState ? FontWeight.bold : FontWeight.normal))),
              Padding(padding: const EdgeInsets.all(8.0), child: Text('${row[2]}', textAlign: TextAlign.center, style: TextStyle(fontWeight: isCurrentState ? FontWeight.bold : FontWeight.normal, color: row[2] == 1 ? const Color(0xFF006633) : Colors.red))),
            ],
          );
        }),
      ],
    );
  }

  int _calculateOutputFor(int a, int b) {
    switch (_selectedGate) {
      case 'AND': return (a == 1 && b == 1) ? 1 : 0;
      case 'OR': return (a == 1 || b == 1) ? 1 : 0;
      case 'NOT': return (a == 0) ? 1 : 0;
      case 'NAND': return (a == 1 && b == 1) ? 0 : 1;
      case 'NOR': return (a == 0 && b == 0) ? 1 : 0;
      case 'XOR': return (a != b) ? 1 : 0;
      case 'XNOR': return (a == b) ? 1 : 0;
      default: return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final outputY = _calculateOutput();
    final bool isSingleInput = _selectedGate == 'NOT';

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
                Icon(Icons.developer_board, color: Color(0xFF006633)),
                SizedBox(width: 8),
                Text('Interactive Logic Gate Simulator', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF004D26))),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Select Gate: ', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedGate,
                  items: _gates.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() { _selectedGate = val; });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Inputs
                Column(
                  children: [
                    _buildInputToggle('A', _inputA, (val) => setState(() => _inputA = val)),
                    if (!isSingleInput) const SizedBox(height: 16),
                    if (!isSingleInput) _buildInputToggle('B', _inputB, (val) => setState(() => _inputB = val)),
                  ],
                ),
                const SizedBox(width: 20),
                // Gate Box
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    border: Border.all(color: Colors.blue.shade300, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(_selectedGate, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
                  ),
                ),
                const SizedBox(width: 20),
                // Output
                Column(
                  children: [
                    const Text('Output Y', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: outputY == 1 ? const Color(0xFF006633) : Colors.red.shade100,
                      child: Text('$outputY', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: outputY == 1 ? Colors.white : Colors.red)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Truth Table Verification:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildTruthTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputToggle(String label, int currentValue, ValueChanged<int> onChanged) {
    return Row(
      children: [
        Text('Input $label:', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        ChoiceChip(
          label: const Text('0'),
          selected: currentValue == 0,
          selectedColor: Colors.red.shade100,
          onSelected: (selected) { if (selected) onChanged(0); },
        ),
        const SizedBox(width: 4),
        ChoiceChip(
          label: const Text('1'),
          selected: currentValue == 1,
          selectedColor: const Color(0xFF006633),
          labelStyle: TextStyle(color: currentValue == 1 ? Colors.white : Colors.black),
          onSelected: (selected) { if (selected) onChanged(1); },
        ),
      ],
    );
  }
}
