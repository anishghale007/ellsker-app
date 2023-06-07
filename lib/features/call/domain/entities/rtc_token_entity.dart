import 'package:equatable/equatable.dart';

class RtcTokenEntity extends Equatable {
  final String rtcToken;

  const RtcTokenEntity({
    required this.rtcToken,
  });

  @override
  List<Object?> get props => [rtcToken];
}
