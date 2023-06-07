import 'package:internship_practice/features/call/domain/entities/rtc_token_entity.dart';

class RtcTokenModel extends RtcTokenEntity {
  const RtcTokenModel({
    required super.rtcToken,
  });

  factory RtcTokenModel.fromJson(Map<String, dynamic> json) {
    return RtcTokenModel(
      rtcToken: json["rtcToken"],
    );
  }
}
