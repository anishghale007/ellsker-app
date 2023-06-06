part of 'call_bloc.dart';

abstract class CallEvent extends Equatable {
  const CallEvent();

  @override
  List<Object> get props => [];
}

class GetRtcTokenEvent extends CallEvent {
  final String channelName;
  final String role;
  final String tokenType;
  final String uid;

  const GetRtcTokenEvent({
    required this.channelName,
    required this.role,
    required this.tokenType,
    required this.uid,
  });

  @override
  List<Object> get props => [
        channelName,
        role,
        tokenType,
        uid,
      ];
}
