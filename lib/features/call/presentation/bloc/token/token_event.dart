part of 'token_bloc.dart';

abstract class TokenEvent extends Equatable {
  const TokenEvent();

  @override
  List<Object> get props => [];
}

class GetRtcTokenEvent extends TokenEvent {
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
