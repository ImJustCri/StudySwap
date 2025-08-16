import 'package:firebase_messaging/firebase_messaging.dart';

// Call to request permission
Future<void> setupNotifications() async{
    await FirebaseMessaging.instance.requestPermission(alert: true, sound: true);
}
