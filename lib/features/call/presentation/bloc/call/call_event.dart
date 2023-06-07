part of 'call_bloc.dart';

abstract class CallEvent extends Equatable {
  const CallEvent();

  @override
  List<Object> get props => [];
}

class MakeCallEvent extends CallEvent {
  final String callerId;
  final String callerName;
  final String callerPhotoUrl;
  final String receiverId;
  final String receiverName;
  final String receiverPhotoUrl;
  final String callStartTime;
  final String callEndTime;

  const MakeCallEvent({
    required this.callerId,
    required this.callerName,
    required this.callerPhotoUrl,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPhotoUrl,
    required this.callStartTime,
    required this.callEndTime,
  });

  @override
  List<Object> get props => [
        callerId,
        callerName,
        callerPhotoUrl,
        receiverId,
        receiverName,
        receiverPhotoUrl,
        callStartTime,
        callEndTime,
      ];
}
