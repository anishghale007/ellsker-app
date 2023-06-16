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

class PickupCallEvent extends CallEvent {
  final String userId;

  const PickupCallEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class EndCallEvent extends CallEvent {
  final String callerId;
  final String callerPhotoUrl;
  final String callerName;
  final String receiverId;
  final String callStartTime;
  final String callEndTime;
  final bool didPickup;

  const EndCallEvent({
    required this.callerId,
    required this.callerPhotoUrl,
    required this.callerName,
    required this.receiverId,
    required this.callStartTime,
    required this.callEndTime,
    required this.didPickup,
  });

  @override
  List<Object> get props => [
        callerId,
        callerPhotoUrl,
        callerName,
        receiverId,
        callStartTime,
        callEndTime,
        didPickup,
      ];
}

class GetAllCallLogsEvent extends CallEvent {
  final String userId;

  const GetAllCallLogsEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}
