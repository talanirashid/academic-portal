import 'package:flutter/material.dart';

class BilingualTerm {
  final String englishTerm;
  final String urduTerm;
  final String definition;

  const BilingualTerm({
    required this.englishTerm,
    required this.urduTerm,
    required this.definition,
  });
}

/// Interactive widget providing tap-to-reveal Urdu translations for technical terms.
class BilingualTooltipWidget extends StatefulWidget {
  const BilingualTooltipWidget({super.key});

  @override
  State<BilingualTooltipWidget> createState() => _BilingualTooltipWidgetState();
}

class _BilingualTooltipWidgetState extends State<BilingualTooltipWidget> {
  final List<BilingualTerm> _terms = const [
    BilingualTerm(
      englishTerm: 'Bus Arbitration',
      urduTerm: 'بس ثالثی',
      definition: 'Process by which the CPU or bus controller allocates system bus control to requesting devices.',
    ),
    BilingualTerm(
      englishTerm: 'Paging & Virtual Memory',
      urduTerm: 'صفحات سازی اور ورچوئل میموری',
      definition: 'Memory management scheme where secondary storage acts as extension of main RAM in fixed-size blocks.',
    ),
    BilingualTerm(
      englishTerm: 'Interrupt Handling',
      urduTerm: 'مداخلت کا انتظام',
      definition: 'Mechanism by which CPU pauses current execution to handle urgent hardware or software signals.',
    ),
    BilingualTerm(
      englishTerm: 'Register Transfer Level',
      urduTerm: 'رجسٹر کی منتقلی کی سطح',
      definition: 'Design abstraction modeling sequential digital circuits in terms of data flow between registers.',
    ),
  ];

  final Set<String> _revealedTerms = {};

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
            const Row(
              children: [
                Icon(Icons.g_translate, color: Color(0xFF006633)),
                SizedBox(width: 8),
                Text(
                  'Bilingual Technical Glossary (Urdu / English)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Tap any key technical term below to reveal its Urdu board examination translation and definition:',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _terms.map((term) {
                final isRevealed = _revealedTerms.contains(term.englishTerm);
                return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    setState(() {
                      if (isRevealed) {
                        _revealedTerms.remove(term.englishTerm);
                      } else {
                        _revealedTerms.add(term.englishTerm);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isRevealed
                          ? const Color(0xFF006633).withValues(alpha: 0.12)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isRevealed ? const Color(0xFF006633) : Colors.grey[300]!,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          term.englishTerm,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        if (isRevealed) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF006633),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              term.urduTerm,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ] else ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.touch_app, size: 14, color: Colors.grey),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
