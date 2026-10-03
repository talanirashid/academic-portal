import 'package:flutter/material.dart';

/// Interactive calculator showing step-by-step long-division remainder table for Decimal to Binary/Octal/Hex.
class NumberSystemScratchpadWidget extends StatefulWidget {
  const NumberSystemScratchpadWidget({super.key});

  @override
  State<NumberSystemScratchpadWidget> createState() => _NumberSystemScratchpadWidgetState();
}

class _NumberSystemScratchpadWidgetState extends State<NumberSystemScratchpadWidget> {
  final TextEditingController _inputController = TextEditingController(text: '25');
  int _decimalValue = 25;

  void _onInputChanged(String val) {
    final parsed = int.tryParse(val.trim());
    if (parsed != null && parsed >= 0 && parsed <= 100000) {
      setState(() {
        _decimalValue = parsed;
      });
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _generateDivisionSteps(int dec, int base) {
    List<Map<String, dynamic>> steps = [];
    int current = dec;
    if (current == 0) {
      steps.add({'num': 0, 'quotient': 0, 'remainder': 0, 'hexRem': '0'});
      return steps;
    }
    while (current > 0) {
      int q = current ~/ base;
      int r = current % base;
      String hexRem = r.toRadixString(16).toUpperCase();
      steps.add({'num': current, 'quotient': q, 'remainder': r, 'hexRem': hexRem});
      current = q;
    }
    return steps;
  }

  @override
  Widget build(BuildContext context) {
    final binaryStr = _decimalValue.toRadixString(2);
    final octalStr = _decimalValue.toRadixString(8);
    final hexStr = _decimalValue.toRadixString(16).toUpperCase();

    final binarySteps = _generateDivisionSteps(_decimalValue, 2);

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
                Icon(Icons.calculate, color: Color(0xFF006633)),
                SizedBox(width: 8),
                Text(
                  'Number System Conversion Scratchpad',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Enter a decimal integer to see instant Base-2, Base-8, and Base-16 step-by-step remainder divisions:',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 12),

            // Decimal Input Field
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              onChanged: _onInputChanged,
              decoration: InputDecoration(
                labelText: 'Decimal Integer Value',
                prefixIcon: const Icon(Icons.numbers, color: Color(0xFF006633)),
                filled: true,
                fillColor: Colors.grey[50],
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Conversion Summary Badges
            Row(
              children: [
                _buildBaseBadge('Binary (Base-2)', binaryStr, Colors.blue[800]!),
                const SizedBox(width: 8),
                _buildBaseBadge('Octal (Base-8)', octalStr, Colors.amber[900]!),
                const SizedBox(width: 8),
                _buildBaseBadge('Hex (Base-16)', hexStr, Colors.purple[800]!),
              ],
            ),
            const SizedBox(height: 16),

            // Division Steps Table for Binary
            const Text(
              'Step-by-Step Division-by-2 Remainder Table (Decimal → Binary):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 6),
            Table(
              border: TableBorder.all(color: Colors.grey[300]!),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[100]),
                  children: const [
                    Padding(padding: EdgeInsets.all(6), child: Text('Number', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(6), child: Text('÷ 2', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(6), child: Text('Quotient', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(6), child: Text('Remainder (Bit)', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF006633)))),
                  ],
                ),
                ...binarySteps.map((s) {
                  return TableRow(
                    children: [
                      Padding(padding: const EdgeInsets.all(6), child: Text('${s['num']}', textAlign: TextAlign.center)),
                      const Padding(padding: EdgeInsets.all(6), child: Text('÷ 2', textAlign: TextAlign.center)),
                      Padding(padding: const EdgeInsets.all(6), child: Text('${s['quotient']}', textAlign: TextAlign.center)),
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text(
                          '${s['remainder']}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF006633)),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Read Remainders Bottom-to-Top: $binaryStr₂',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF006633), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBaseBadge(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
