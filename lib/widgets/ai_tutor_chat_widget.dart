import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../features/packages/widgets/package_checkout_modal.dart';
import '../services/ai_tutor_service.dart';

/// Floating AI Study Assistant ("PCSA AI Tutor") connected to Gemini API.
class AiTutorChatWidget extends StatefulWidget {
  const AiTutorChatWidget({super.key});

  @override
  State<AiTutorChatWidget> createState() => _AiTutorChatWidgetState();
}

class _AiTutorChatWidgetState extends State<AiTutorChatWidget> {
  final AiTutorService _aiService = AiTutorService();
  bool _isOpen = false;
  int _freeQuestionsRemaining = 3;
  bool _isTyping = false;

  final TextEditingController _queryController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> _messages = [
    {
      'sender': 'ai',
      'text':
          'Assalam-o-Alaikum! I am your PCSA AI Tutor. Ask me anything about C++ pointers, K-Map reductions, 2\'s complement subtraction, or FBISE/STBB exercise solutions!'
    }
  ];

  @override
  void initState() {
    super.initState();
    _aiService.startChat();
  }

  @override
  void dispose() {
    _queryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendQuery() async {
    final query = _queryController.text.trim();
    if (query.isEmpty || _isTyping) return;

    if (_freeQuestionsRemaining <= 0) {
      showDialog(
        context: context,
        builder: (_) => const PackageCheckoutModal(
          packageId: 'pro_pass_annual',
          packageName: 'Pro Annual Pass (Unlimited AI Tutor)',
          amount: 999.0,
        ),
      );
      return;
    }

    setState(() {
      _messages.add({'sender': 'user', 'text': query});
      _messages.add({'sender': 'ai', 'text': ''}); // Placeholder for streaming response
      _freeQuestionsRemaining--;
      _isTyping = true;
      _queryController.clear();
    });
    _scrollToBottom();

    try {
      final stream = _aiService.sendMessageStream(query);
      await for (final chunk in stream) {
        if (!mounted) break;
        setState(() {
          // Append to the last AI message
          _messages.last['text'] = _messages.last['text']! + chunk;
        });
        _scrollToBottom();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTyping = false;
        });
        _scrollToBottom();
      }
    }
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
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
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
                        Text('PCSA AI Tutor', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
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
                    Text('Free Daily Questions: $_freeQuestionsRemaining/3',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF004D26))),
                    if (_freeQuestionsRemaining == 0)
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => const PackageCheckoutModal(
                              packageId: 'pro_pass_annual',
                              packageName: 'Pro Annual Pass (Unlimited AI)',
                              amount: 999.0,
                            ),
                          );
                        },
                        child: const Text('Upgrade Pro Pass',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF006633), decoration: TextDecoration.underline)),
                      ),
                  ],
                ),
              ),

              // Chat Messages List
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    final isUser = msg['sender'] == 'user';
                    
                    if (!isUser && msg['text']!.isEmpty && _isTyping) {
                       return const Align(
                         alignment: Alignment.centerLeft,
                         child: Padding(
                           padding: EdgeInsets.all(8.0),
                           child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF006633)),
                         ),
                       );
                    }

                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUser ? const Color(0xFF006633) : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: isUser ? null : Border.all(color: Colors.grey[300]!),
                        ),
                        // Use MarkdownBody for AI responses to render code snippets and bold text properly
                        child: isUser
                            ? Text(
                                msg['text']!,
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                              )
                            : MarkdownBody(
                                data: msg['text']!,
                                styleSheet: MarkdownStyleSheet(
                                  p: const TextStyle(color: Colors.black87, fontSize: 13),
                                  code: TextStyle(backgroundColor: Colors.grey[300], fontFamily: 'monospace', fontSize: 12),
                                  codeblockPadding: const EdgeInsets.all(8),
                                  codeblockDecoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),

              // Input Bar
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _queryController,
                        style: const TextStyle(fontSize: 13),
                        onSubmitted: (_) => _sendQuery(),
                        decoration: InputDecoration(
                          hintText: 'Ask C++, K-Map or exercise question...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FloatingActionButton(
                      mini: true,
                      backgroundColor: const Color(0xFF006633),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      onPressed: _isTyping ? null : _sendQuery,
                      child: const Icon(Icons.send, size: 18),
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
