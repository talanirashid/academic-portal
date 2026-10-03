import 'package:flutter/material.dart';

/// Interactive 2's Complement Subtraction Step-by-Step Solver for Class 11 CS.
class TwosComplementSolverWidget extends StatefulWidget {
  const TwosComplementSolverWidget({super.key});

  @override
  State<TwosComplementSolverWidget> createState() => _TwosComplementSolverWidgetState();
}

class _TwosComplementSolverWidgetState extends State<TwosComplementSolverWidget> {
  int _numA = 25;
  int _numB = 12;

  String _to8BitBinary(int val) {
    return val.toRadixString(2).padLeft(8, '0');
  }

  String _onesComplement(String bin) {
    return bin.split('').map((bit) => bit == '0' ? '1' : '0').join('');
  }

  @override
  Widget build(BuildContext context) {
    final binA = _to8BitBinary(_numA);
    final binB = _to8BitBinary(_numB);
    final onesB = _onesComplement(binB);

    final twosBVal = (int.parse(onesB, radix: 2) + 1);
    final twosB = twosBVal.toRadixString(2).padLeft(8, '0');

    final sumVal = int.parse(binA, radix: 2) + twosBVal;
    final rawSumBin = sumVal.toRadixString(2).padLeft(9, '0');
    final finalResult = _numA - _numB;

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
                Icon(Icons.exposure_minus_1, color: Color(0xFF006633)),
                SizedBox(width: 8),
                Text(
                  "2's Complement Subtraction Step-by-Step Solver",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Input two numbers A and B to calculate A - B via 2\'s Complement binary addition:',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Number A (e.g. 25)', border: OutlineInputBorder()),
                    controller: TextEditingController(text: '$_numA'),
                    onChanged: (val) {
                      final p = int.tryParse(val);
                      if (p != null && p >= 0 && p <= 127) setState(() => _numA = p);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Number B (e.g. 12)', border: OutlineInputBorder()),
                    controller: TextEditingController(text: '$_numB'),
                    onChanged: (val) {
                      final p = int.tryParse(val);
                      if (p != null && p >= 0 && p <= 127) setState(() => _numB = p);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Step Breakdown
            _buildStepTile('Step 1: 8-Bit Binary Conversion', 'A ($_numA) = $binA₂\nB ($_numB) = $binB₂'),
            _buildStepTile('Step 2: 1\'s Complement of B (Invert Bits)', '1\'s Complement of B = $onesB₂'),
            _buildStepTile('Step 3: 2\'s Complement of B (Add +1)', '$onesB + 1 = $twosB₂'),
            _buildStepTile('Step 4: Binary Addition A + 2\'s Comp(B)', '$binA + $twosB = $rawSumBin₂'),
            _buildStepTile(
              'Step 5: Discard Carry Bit & Final Result',
              'Discard 9th carry bit -> Result = ${_to8BitBinary(finalResult)}₂ = $finalResult (Decimal)',
              isResult: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepTile(String stepTitle, String detail, {bool isResult = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isResult ? const Color(0xFF006633).withValues(alpha: 0.1) : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isResult ? const Color(0xFF006633) : Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(isResult ? Icons.check_circle : Icons.arrow_right, color: isResult ? const Color(0xFF006633) : Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stepTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isResult ? const Color(0xFF004D26) : Colors.black87)),
                const SizedBox(height: 2),
                Text(detail, style: const TextStyle(fontSize: 12, fontFamily: 'Courier', fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
