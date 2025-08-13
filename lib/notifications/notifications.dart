import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
Future<void> setupNotifications() async{
    await FirebaseMessaging.instance.requestPermission(alert: true, sound: true);
}
