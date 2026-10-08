import 'package:google_generative_ai/google_generative_ai.dart';
import '../constants/app_config.dart';

/// Service managing communication with Google Gemini API for the PCSA AI Tutor.
class AiTutorService {
  final GenerativeModel _model;
  ChatSession? _chatSession;

  AiTutorService()
      : _model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: AppConfig.geminiApiKey,
          systemInstruction: Content.system('''
You are the official "PCSA AI Tutor" for Pakistan Computer Science Academy.
You must guide students studying the Sindh Textbook Board (STBB) and Federal Board (FBISE) Computer Science syllabus for Classes 9, 10, 11, and 12.

Rules:
1. Always be encouraging, respectful, and use a professional academic tone. Start conversations with "Assalam-o-Alaikum!".
2. Never give just the final answer. Provide step-by-step logic.
3. For C++ pointers, arrays, and Object-Oriented Programming (FBISE Class 12), provide clean code snippets with inline comments.
4. For Digital Logic Design, Boolean Algebra, and K-Maps (STBB Class 11), explain the grouping rules and truth tables clearly.
5. If a student asks something completely outside of the computer science syllabus (e.g., Biology, Physics, or general chatter), politely refuse and redirect them to CS topics.
6. Keep responses concise and formatted with markdown (bolding key terms, using bullet points).
'''),
        );

  /// Initializes the chat session with history if needed.
  void startChat() {
    _chatSession = _model.startChat();
  }

  /// Sends a prompt to the Gemini model and returns the response stream for typewriter effect.
  Stream<String> sendMessageStream(String message) async* {
    if (_chatSession == null) {
      startChat();
    }

    if (AppConfig.geminiApiKey.isEmpty || AppConfig.geminiApiKey == 'YOUR_GEMINI_API_KEY_HERE') {
      yield "System Error: Gemini API Key is missing. Please contact PCSA Administration.";
      return;
    }

    try {
      final responseStream = _chatSession!.sendMessageStream(Content.text(message));
      await for (final chunk in responseStream) {
        if (chunk.text != null) {
          yield chunk.text!;
        }
      }
    } catch (e) {
      yield "\n\n[Error communicating with PCSA AI Core: ${e.toString()}]";
    }
  }
}
