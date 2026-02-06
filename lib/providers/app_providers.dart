import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/ml_service.dart';
import '../data/services/gemini_service.dart';
import '../data/models/app_models.dart';
import 'dart:typed_data';

final mlServiceProvider = Provider((ref) => MLService());

final mlInferenceProvider = StateNotifierProvider<MLInferenceNotifier, AsyncValue<CropDetectionResult?>>((ref) {
  return MLInferenceNotifier(ref.watch(mlServiceProvider));
});

class MLInferenceNotifier extends StateNotifier<AsyncValue<CropDetectionResult?>> {
  final MLService _mlService;
  MLInferenceNotifier(this._mlService) : super(const AsyncValue.data(null));

  Future<void> detectDisease(Uint8List imageBytes) async {
    state = const AsyncValue.loading();
    try {
      final result = await _mlService.predict(imageBytes);
      // Map result to models with remedy/prevention (normally from a DB/Knowledge base)
      final detection = CropDetectionResult(
        disease: result['label'],
        confidence: result['confidence'],
        remedy: "Apply 1% Bordeaux mixture on the leaves.", // Dummy remedy
        prevention: "Use certified disease-free seeds and ensure proper drainage.",
        timestamp: DateTime.now(),
      );
      state = AsyncValue.data(detection);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final chatServiceProvider = Provider((ref) => GeminiService("YOUR_API_KEY_HERE")); // User should replace this

final chatMessagesProvider = StateNotifierProvider<ChatNotifier, List<Map<String, String>>>((ref) {
  return ChatNotifier(ref.watch(chatServiceProvider));
});

class ChatNotifier extends StateNotifier<List<Map<String, String>>> {
  final GeminiService _gemini;
  ChatNotifier(this._gemini) : super([]);

  Future<void> sendMessage(String text) async {
    state = [...state, {'role': 'user', 'message': text}];
    final response = await _gemini.sendMessage(text, locationContext: "Karur, Tamil Nadu");
    state = [...state, {'role': 'assistant', 'message': response}];
  }
}
