import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart';

class MLService {
  Interpreter? _interpreter;
  List<String>? _labels;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/leaf_model.tflite');
      final labelsData = await rootBundle.loadString('assets/models/labels.txt');
      _labels = labelsData.split('\n').where((s) => s.isNotEmpty).toList();
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  Future<Map<String, dynamic>> predict(Uint8List imageBytes) async {
    if (_interpreter == null) await loadModel();
    if (_interpreter == null) return {'label': 'Error', 'confidence': 0.0};

    // Preprocess image
    img.Image? decodedImage = img.decodeImage(imageBytes);
    if (decodedImage == null) return {'label': 'Invalid Image', 'confidence': 0.0};
    
    img.Image resizedImage = img.copyResize(decodedImage, width: 224, height: 224);
    
    // Normalize and convert to Float32List
    var input = Float32List(1 * 224 * 224 * 3);
    var buffer = 0;
    for (var y = 0; y < 224; y++) {
      for (var x = 0; x < 224; x++) {
        var pixel = resizedImage.getPixel(x, y);
        input[buffer++] = (pixel.r - 127.5) / 127.5;
        input[buffer++] = (pixel.g - 127.5) / 127.5;
        input[buffer++] = (pixel.b - 127.5) / 127.5;
      }
    }

    var output = List.filled(1 * (_labels?.length ?? 1), 0.0).reshape([1, _labels?.length ?? 1]);
    
    _interpreter!.run(input.buffer.asUint8List(), output);
    
    List<double> results = List<double>.from(output[0]);
    int maxIndex = 0;
    double maxScore = -1.0;
    for (int i = 0; i < results.length; i++) {
      if (results[i] > maxScore) {
        maxScore = results[i];
        maxIndex = i;
      }
    }

    return {
      'label': _labels![maxIndex],
      'confidence': maxScore,
    };
  }
}
