import 'dart:typed_data';

abstract class MLServiceInterface {
  Future<void> loadModel();
  Future<Map<String, dynamic>> predict(Uint8List imageBytes);
}

class MLService implements MLServiceInterface {
  @override
  Future<void> loadModel() async {
    // Mock load
  }

  @override
  Future<Map<String, dynamic>> predict(Uint8List imageBytes) async {
    // Mock prediction for web
    return {
      'label': 'Tomato Healthy (Web Mock)',
      'confidence': 0.98,
    };
  }
}
