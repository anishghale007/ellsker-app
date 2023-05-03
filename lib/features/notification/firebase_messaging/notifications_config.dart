import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'my_channel', // id
  'My_Channel', // title
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Notifications {
  static Future init() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.getToken();

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mimap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      if (Platform.isAndroid) {
        // Notifications().
      }
    });
  }

  Future<void> showNotification(message) async {
    RemoteNotification remoteNotification = message.notification;
    flutterLocalNotificationsPlugin.show(
      remoteNotification.hashCode,
      remoteNotification.title,
      remoteNotification.body,
      _buildDetails(
        remoteNotification.title!,
        remoteNotification.body!,
      ),
    );
  }

  NotificationDetails _buildDetails(String title, String body) {
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: channel.importance,
      icon: "@mipmap/ic_launcher",
    );
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails();
    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    return notificationDetails;
  }
}
