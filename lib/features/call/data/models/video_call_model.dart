import 'package:internship_practice/features/call/domain/entities/video_call_entity.dart';

class VideoCallModel extends VideoCallEntity {
  const VideoCallModel({
    required super.rtcToken,
  });

  factory VideoCallModel.fromJson(Map<String, dynamic> json) {
    return VideoCallModel(
      rtcToken: json["rtcToken"],
    );
  }
}
