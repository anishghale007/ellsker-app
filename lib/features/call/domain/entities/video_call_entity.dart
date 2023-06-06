import 'package:equatable/equatable.dart';

class VideoCallEntity extends Equatable {
  final String rtcToken;

  const VideoCallEntity({
    required this.rtcToken,
  });

  @override
  List<Object?> get props => [rtcToken];
}
