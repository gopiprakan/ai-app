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
  final String disease;
  final double confidence;
  final String remedy;
  final String prevention;
  final DateTime timestamp;

  CropDetectionResult({
    required this.disease,
    required this.confidence,
    required this.remedy,
    required this.prevention,
    required this.timestamp,
  });
}
