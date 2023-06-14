import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:internship_practice/constants.dart';

final String agoraAppId = dotenv.get(
  Constant.agoraAppId,
  fallback: "Not Found",
);
final String agoraAppCertificate = dotenv.get(
  Constant.agoraAppCertificate,
  fallback: "Not Found",
);

class AgoraConfig {
  static String appId = agoraAppId;
  static String appCertificate = agoraAppCertificate;
  static String token = "";
}
