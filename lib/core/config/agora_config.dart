import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:internship_practice/constants.dart';

final String agoraAppId =
    dotenv.get(Constant.agoraAppId, fallback: "Not Found");

class AgoraConfig {
  static String appId = agoraAppId;
  static String appCertificate = "3abe9b55b37643c1b73ddbc9a1d4fd19";
  static String token = "";
}
