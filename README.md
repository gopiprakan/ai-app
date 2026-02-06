# AgriAI Assistant 🌱

AgriAI Assistant is a production-ready Flutter application designed for Indian farmers. It leverages on-device Machine Learning for crop disease detection and Generative AI (Gemini) for smart farming assistance.

## ✨ Features
- **Smart Leaf Scan**: Detects 10+ diseases in Rice, Tomato, Chili, and Cotton using TensorFlow Lite (works offline).
- **AI Farming Expert**: Gemini-powered chatbot for contextual advice (Tamil & English support).
- **Weather Insights**: Real-time updates for Karur, Tamil Nadu (integrated with OpenWeatherMap).
- **Glassmorphism UI**: Modern frosted glass design with smooth animations.
- **Firebase Integration**: Secure Auth, Cloud Firestore for scan history, and Push Notifications.

## 🛠️ Tech Stack
- **Framework**: Flutter 3.x
- **State Management**: Riverpod
- **Machine Learning**: TensorFlow Lite (`tflite_flutter`)
- **Backend**: Firebase (Auth, Firestore, Messaging)
- **AI**: Google Generative AI (Gemini 1.5 Flash)
- **UI**: Custom Glassmorphism, Google Fonts, Lottie

## 🚀 Setup Instructions

### 1. Prerequisites
- Flutter SDK installed (`flutter doctor` should be green).
- A Firebase project created at [console.firebase.google.com](https://console.firebase.google.com).
- A Gemini API key from [aistudio.google.com](https://aistudio.google.com).

### 2. Configure Firebase
1. Install FlutterFire CLI: `dart pub global activate flutterfire_cli`.
2. Run `flutterfire configure` in the project root.
3. Replace the placeholders in `lib/core/firebase_options.dart` if necessary.

### 3. Add ML Model
Place your trained `.tflite` model in `assets/models/leaf_model.tflite` and labels in `assets/models/labels.txt`.

### 4. Configure Gemini
Update `lib/providers/app_providers.dart` with your Gemini API Key:
```dart
final chatServiceProvider = Provider((ref) => GeminiService("YOUR_API_KEY_HERE"));
```

### 5. Run the App
```bash
flutter pub get
flutter run
```

## 📦 Deployment

### Android (Generate APK)
```bash
flutter build apk --release
```
The APK will be located at `build/app/outputs/flutter-apk/app-release.apk`.

### Web (Firebase Hosting)
1. Build the web version: `flutter build web`.
2. Initialize Firebase Hosting: `firebase init hosting`.
3. Deploy: `firebase deploy --only hosting`.

## 📂 Project Structure
- `lib/core`: Theme, Constants, Firebase Config.
- `lib/data`: Models, Services (ML, Gemini, Firebase).
- `lib/providers`: Riverpod state management.
- `lib/screens`: UI Screens (Home, Camera, Chat).
- `lib/widgets`: Shared Glassmorphism components.

## 📝 License
MIT License. Developed for Smart Farming in India.
