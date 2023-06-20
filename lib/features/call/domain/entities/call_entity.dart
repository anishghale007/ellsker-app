import 'package:equatable/equatable.dart';

class CallEntity extends Equatable {
  final String callId;
  final String callerId;
  final String callerName;
  final String callerPhotoUrl;
  final String receiverId;
  final String receiverName;
  final String receiverPhotoUrl;
  final String callStartTime;
  final String callEndTime;
  final bool hasDialled;
  final bool didRejectCall;

  const CallEntity({
    required this.callId,
    required this.callerId,
    required this.callerName,
    required this.callerPhotoUrl,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPhotoUrl,
    required this.callStartTime,
    required this.callEndTime,
    required this.hasDialled,
    required this.didRejectCall,
  });

  @override
  List<Object?> get props => [
        callId,
        callerId,
        callerName,
        callerPhotoUrl,
        receiverId,
        receiverName,
        receiverPhotoUrl,
        callStartTime,
        callEndTime,
        hasDialled,
        didRejectCall,
      ];
}
