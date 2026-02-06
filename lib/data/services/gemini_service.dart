import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late final GenerativeModel _model;
  ChatSession? _chat;

  GeminiService(String apiKey) {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
  }

  Future<String> sendMessage(String message, {String? locationContext}) async {
    _chat ??= _model.startChat(history: [
      Content.text("You are AgriAI Assistant, a smart farming expert for Indian farmers. "
          "Provide advice on crop diseases, fertilizers, and irrigation. "
          "User location: ${locationContext ?? 'Unknown, India'}. "
          "Always be helpful, precise, and use simple language. "
          "If the user asks in Tamil, reply in Tamil.")
    ]);

    try {
      final response = await _chat!.sendMessage(Content.text(message));
      return response.text ?? "I couldn't process that. Please try again.";
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }
}
