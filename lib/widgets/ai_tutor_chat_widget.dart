import 'package:flutter/material.dart';
import 'pricing_modal.dart';

/// Floating AI Study Assistant ("PCSA AI Tutor") tailored for FBISE & STBB Computer Science Students.
class AiTutorChatWidget extends StatefulWidget {
  const AiTutorChatWidget({super.key});

  @override
  State<AiTutorChatWidget> createState() => _AiTutorChatWidgetState();
}

class _AiTutorChatWidgetState extends State<AiTutorChatWidget> {
  bool _isOpen = false;
  int _freeQuestionsRemaining = 3;
  final TextEditingController _queryController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      'sender': 'ai',
      'text': 'Assalam-o-Alaikum! I am your PCSA AI Tutor. Ask me anything about C++ pointers, K-Map reductions, 2\'s complement subtraction, or FBISE/STBB exercise solutions!'
    }
  ];

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _sendQuery() {
    final query = _queryController.text.trim();
    if (query.isEmpty) return;

    if (_freeQuestionsRemaining <= 0) {
      showDialog(
        context: context,
        builder: (_) => const PricingModal(),
      );
      return;
    }

    setState(() {
      _messages.add({'sender': 'user', 'text': query});
      _freeQuestionsRemaining--;
      _queryController.clear();
    });

    // Simulate AI Board Rubric Response
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'sender': 'ai',
            'text': 'According to 2026 FBISE/STBB Board Rubrics:\n\n1. Concept Step: Identify given parameters.\n2. Formula/Rule: Apply textbook standard logic.\n3. Final Answer: Step-by-step solution format for maximum board marks.'
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isOpen) {
      return Positioned(
        bottom: 20,
        right: 20,
        child: FloatingActionButton.extended(
          backgroundColor: const Color(0xFF006633),
          foregroundColor: Colors.white,
          onPressed: () => setState(() => _isOpen = true),
          icon: const Icon(Icons.auto_awesome, color: Colors.amber),
          label: const Text('PCSA AI Tutor', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      );
    }

    return Positioned(
      bottom: 20,
      right: 20,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380, maxHeight: 520),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFF004D26),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.auto_awesome, color: Colors.amber, size: 20),
                        SizedBox(width: 8),
                        Text('PCSA AI Tutor (2026 Board Rubrics)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 18),
                      onPressed: () => setState(() => _isOpen = false),
                    ),
                  ],
                ),
              ),

              // Remaining Free Questions Counter
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                color: Colors.amber[100],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Free Daily Questions: $_freeQuestionsRemaining/3', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF004D26))),
                    if (_freeQuestionsRemaining == 0)
                      InkWell(
                        onTap: () {
                          showDialog(context: context, builder: (_) => const PricingModal());
                        },
                        child: const Text('Upgrade Pro Pass', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF006633), decoration: TextDecoration.underline)),
                      ),
                  ],
                ),
              ),

              // Chat Messages List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    final isUser = msg['sender'] == 'user';
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isUser ? const Color(0xFF006633) : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          msg['text']!,
                          style: TextStyle(color: isUser ? Colors.white : Colors.black87, fontSize: 12),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Input Bar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _queryController,
                        style: const TextStyle(fontSize: 12),
                        decoration: const InputDecoration(
                          hintText: 'Ask C++, K-Map or exercise question...',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      icon: const Icon(Icons.send, color: Color(0xFF006633)),
                      onPressed: _sendQuery,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
