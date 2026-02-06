class WeatherData {
  final double temperature;
  final String condition;
  final String location;
  final double humidity;
  final double windSpeed;

  WeatherData({
    required this.temperature,
    required this.condition,
    required this.location,
    required this.humidity,
    required this.windSpeed,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: (json['main']['temp'] as num).toDouble(),
      condition: json['weather'][0]['main'],
      location: json['name'],
      humidity: (json['main']['humidity'] as num).toDouble(),
      windSpeed: (json['wind']['speed'] as num).toDouble(),
    );
  }
}

class CropDetectionResult {
  final String? id;
  final String userId;
  final String disease;
  final double confidence;
  final String remedy;
  final String prevention;
  final DateTime timestamp;
  final String? imageUrl;

  CropDetectionResult({
    this.id,
    required this.userId,
    required this.disease,
    required this.confidence,
    required this.remedy,
    required this.prevention,
    required this.timestamp,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'disease': disease,
      'confidence': confidence,
      'remedy': remedy,
      'prevention': prevention,
      'timestamp': timestamp.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }

  factory CropDetectionResult.fromMap(Map<String, dynamic> map, String id) {
    return CropDetectionResult(
      id: id,
      userId: map['userId'] ?? '',
      disease: map['disease'] ?? '',
      confidence: (map['confidence'] as num).toDouble(),
      remedy: map['remedy'] ?? '',
      prevention: map['prevention'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
      imageUrl: map['imageUrl'],
    );
  }
}
