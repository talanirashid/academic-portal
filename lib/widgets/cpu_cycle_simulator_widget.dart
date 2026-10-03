import 'package:flutter/material.dart';

/// CPU Instruction Cycle & Register Inspector Simulator for FBISE Class 11 Unit 3.
class CpuCycleSimulatorWidget extends StatefulWidget {
  const CpuCycleSimulatorWidget({super.key});

  @override
  State<CpuCycleSimulatorWidget> createState() => _CpuCycleSimulatorWidgetState();
}

class _CpuCycleSimulatorWidgetState extends State<CpuCycleSimulatorWidget> {
  int _currentStep = 0; // 0: Fetch, 1: Decode, 2: Execute, 3: Store

  final List<Map<String, String>> _stepDetails = const [
    {
      'title': 'Phase 1: FETCH',
      'action': 'PC (100) -> MAR. Instruction "ADD 25" fetched from RAM address 0x100 into MDR and loaded into IR. PC increments to 101.',
      'pc': '101',
      'mar': '0x100',
      'mdr': 'ADD 25',
      'ir': 'ADD 25',
      'acc': '50',
    },
    {
      'title': 'Phase 2: DECODE',
      'action': 'Control Unit (CU) decodes opcode "ADD" in IR and signals ALU to prepare addition with value 25.',
      'pc': '101',
      'mar': '0x100',
      'mdr': '25',
      'ir': 'ADD 25',
      'acc': '50',
    },
    {
      'title': 'Phase 3: EXECUTE',
      'action': 'ALU adds operand 25 to current Accumulator value (50 + 25 = 75).',
      'pc': '101',
      'mar': '0x100',
      'mdr': '25',
      'ir': 'ADD 25',
      'acc': '75',
    },
    {
      'title': 'Phase 4: STORE',
      'action': 'Result 75 is stored in Accumulator (ACC). CPU is ready for next cycle.',
      'pc': '101',
      'mar': '0x100',
      'mdr': '75',
      'ir': 'ADD 25',
      'acc': '75',
    },
  ];

  void _nextStep() {
    setState(() {
      _currentStep = (_currentStep + 1) % _stepDetails.length;
    });
  }

  void _reset() {
    setState(() {
      _currentStep = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final info = _stepDetails[_currentStep];

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
                    Icon(Icons.developer_board, color: Color(0xFF006633)),
                    SizedBox(width: 8),
                    Text(
                      'FBISE Unit 3: CPU Instruction Cycle Simulator',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: _reset,
                      child: const Text('Reset'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006633),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _nextStep,
                      icon: const Icon(Icons.play_arrow, size: 18),
                      label: const Text('Next Phase'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              info['title']!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF006633)),
            ),
            const SizedBox(height: 4),
            Text(
              info['action']!,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 14),

            // Live CPU Registers Display Grid
            Row(
              children: [
                Expanded(child: _buildRegisterBox('PC (Program Counter)', info['pc']!)),
                const SizedBox(width: 6),
                Expanded(child: _buildRegisterBox('MAR (Address Reg)', info['mar']!)),
                const SizedBox(width: 6),
                Expanded(child: _buildRegisterBox('MDR (Data Reg)', info['mdr']!)),
                const SizedBox(width: 6),
                Expanded(child: _buildRegisterBox('IR (Instruction Reg)', info['ir']!)),
                const SizedBox(width: 6),
                Expanded(child: _buildRegisterBox('ACC (Accumulator)', info['acc']!)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterBox(String name, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF004D26),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber),
      ),
      child: Column(
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 9, color: Colors.white70, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.amber, fontFamily: 'Courier'),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
