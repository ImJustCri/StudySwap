import 'package:firebase_messaging/firebase_messaging.dart';

Future<String?> setupNotifications() async{
    await FirebaseMessaging.instance.requestPermission(alert: true, sound: true);
    return await FirebaseMessaging.instance.getToken();
}
