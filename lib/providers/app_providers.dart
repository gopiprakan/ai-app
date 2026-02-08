import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/services/ml_service.dart';
import '../data/services/gemini_service.dart';
import '../data/services/auth_service.dart';
import '../data/services/firestore_service.dart';
import '../data/services/notification_service.dart';
import '../data/models/app_models.dart';
import 'dart:typed_data';

final authServiceProvider = Provider((ref) => AuthService());
final firestoreServiceProvider = Provider((ref) => FirestoreService());
final notificationServiceProvider = Provider((ref) => NotificationService());

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

final scanHistoryProvider = StreamProvider<List<CropDetectionResult>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  return ref.watch(firestoreServiceProvider).getScanHistory(user.uid);
});

final mlServiceProvider = Provider((ref) => MLService());

final mlInferenceProvider = StateNotifierProvider<MLInferenceNotifier, AsyncValue<CropDetectionResult?>>((ref) {
  return MLInferenceNotifier(
    ref.watch(mlServiceProvider),
    ref.watch(firestoreServiceProvider),
    ref.watch(authServiceProvider),
  );
});

class MLInferenceNotifier extends StateNotifier<AsyncValue<CropDetectionResult?>> {
  final MLService _mlService;
  final FirestoreService _firestoreService;
  final AuthService _authService;

  MLInferenceNotifier(this._mlService, this._firestoreService, this._authService) : super(const AsyncValue.data(null));

  Future<void> detectDisease(Uint8List imageBytes) async {
    state = const AsyncValue.loading();
    try {
      final user = _authService.currentUser;
      if (user == null) throw Exception("User not logged in");

      final result = await _mlService.predict(imageBytes);
      
      final detection = CropDetectionResult(
        userId: user.uid,
        disease: result['label'],
        confidence: result['confidence'],
        remedy: "Apply 1% Bordeaux mixture on the leaves.", // Dummy remedy
        prevention: "Use certified disease-free seeds and ensure proper drainage.",
        timestamp: DateTime.now(),
      );

      await _firestoreService.saveScanResult(detection);
      state = AsyncValue.data(detection);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final chatServiceProvider = Provider((ref) => GeminiService("YOUR_API_KEY_HERE")); 

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
