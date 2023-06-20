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

// class NotificationConfig {
//   static initInfo(
//     BuildContext context,
//     checkRoute, {
//     required String senderToken,
//   }) {
//     var androidInitialize =
//         const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iOSInitialize = const DarwinInitializationSettings();
//     var initializationSettings = InitializationSettings(
//       android: androidInitialize,
//       iOS: iOSInitialize,
//     );
//     flutterLocalNotificationsPlugin.initialize(initializationSettings);

//     FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) async {
//       if (remoteMessage.notification != null) {
//         if (remoteMessage.data['notificationType'] ==
//             "missed call notification") {
//           AwesomeNotifications().dismiss(1);
//         } else if (remoteMessage.data['notificationType'] ==
//             "call notification") {
//           AwesomeNotifications().createNotification(
//             content: NotificationContent(
//               id: 1,
//               channelKey: "ellsker_app",
//               color: Colors.white,
//               title: remoteMessage.notification!.title,
//               body: remoteMessage.notification!.body,
//               category: NotificationCategory.Call,
//               wakeUpScreen: true,
//               fullScreenIntent: true,
//               autoDismissible: false,
//               backgroundColor: Colors.orange,
//             ),
//             actionButtons: [
//               NotificationActionButton(
//                 key: "ACCEPT",
//                 label: "Accept Call",
//                 color: Colors.green,
//                 autoDismissible: true,
//               ),
//               NotificationActionButton(
//                 key: "REJECT",
//                 label: "Reject Call",
//                 color: Colors.red,
//                 autoDismissible: true,
//               ),
//             ],
//           );
//           AwesomeNotifications().setListeners(
//             onActionReceivedMethod: (receivedAction) =>
//                 NotificationController.onActionReceivedMethod(
//               receivedAction,
//               context: context,
//               userId: remoteMessage.data['conversationId'],
//               photoUrl: remoteMessage.data['photoUrl'],
//               username: remoteMessage.data['username'],
//               token: remoteMessage.data['token'],
//               senderToken: senderToken,
//             ),
//           );
//         }
//       }
//       // checkRoute(remoteMessage);
//     });

//     // If the app is open in background (Not termainated)
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       checkRoute(message);
//     });
//   }
// }
