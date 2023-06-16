import 'package:equatable/equatable.dart';

class CallLogEntity extends Equatable {
  final String callerId;
  final String callerPhotoUrl;
  final String callerName;
  final String callStartTime;
  final String callEndTime;
  final bool didPickup;

  const CallLogEntity({
    required this.callerId,
    required this.callerPhotoUrl,
    required this.callerName,
    required this.callStartTime,
    required this.callEndTime,
    required this.didPickup,
  });

  @override
  List<Object?> get props => [
        callerId,
        callerPhotoUrl,
        callerName,
        callStartTime,
        callEndTime,
        didPickup,
      ];
}
