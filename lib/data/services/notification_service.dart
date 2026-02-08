import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import '../core/firebase_options.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission for web/iOS
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kIsWeb) {
        // Use the VAPID key for Web
        String? token = await _fcm.getToken(
          vapidKey: DefaultFirebaseOptions.vapidKey,
        );
        print('Registration Token: $token');
      }
    }
  }
}
