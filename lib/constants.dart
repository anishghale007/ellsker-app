import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constant {
  static const String notificationUrl = 'https://fcm.googleapis.com/fcm/send';
  static const String tokenBaseUrl =
      'https://ellsker-token-generator.onrender.com';
  static const String serveyKey = "SERVER_KEY";
  static const String gifApiKey = "GIF_API_KEY";
  static const String agoraAppId = "AGORA_APP_ID";
  static String appId = dotenv.get(Constant.agoraAppId, fallback: 'Not found');
  static const String envFileName = ".env";
  static const String photoMessageContent = "Sent a Photo.";
  static const String videoMessageContent = "Sent a Video.";
  static const String locationMessageContent = "Sent a Location.";
  static const String gifMessageContent = "Sent a GIF.";
  static const String voiceMessageContent = "Sent a Voice Message.";
  static const String callMessageContent = "Called you.";
  static const String missedCallMessageContent = "Missed call.";
  static const String unsendMessageContent = "Unsent a Message.";
  static const String serverFailureMessage = "server failure";
  static const String networkFailureMessage =
      "No Internet Connection. Please connect your device to an Internet.";
  static const String conversationCollection = "conversation";
  static const String messageCollection = "message";
  static const String callCollection = "call";
  static const String callLogsCollection = "call logs";
  static const String userCollection = "users";
}
