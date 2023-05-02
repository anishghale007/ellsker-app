import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:internship_practice/constants.dart';
import 'package:internship_practice/features/notification/domain/entities/notification_entity.dart';
import 'package:http/http.dart' as http;

abstract class NotificationRemoteDataSource {
  Future<String> sendNotification(NotificationEntity notificationEntity);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  @override
  Future<String> sendNotification(NotificationEntity notificationEntity) async {
    try {
      final String serverKey = dotenv.get('SERVER_KEY', fallback: 'Not found');
      await http.post(
        Uri.parse(Constant.notificationUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click-action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': notificationEntity.body,
              'title': notificationEntity.title,
              'conversationId': notificationEntity.conversationId,
              'token': notificationEntity.token,
              'photoUrl': notificationEntity.photoUrl,
              'username': notificationEntity.username,
            },
            "notification": <String, dynamic>{
              "title": notificationEntity.title,
              "body": notificationEntity.body,
              "android_channel_id": "ellsker_app",
            },
            "to": notificationEntity.token,
          },
        ),
      );
      return Future.value("Success");
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }
}