import 'package:internship_practice/features/call/domain/entities/call_entity.dart';

class CallModel extends CallEntity {
  const CallModel({
    required super.callId,
    required super.callerId,
    required super.callerName,
    required super.callerPhotoUrl,
    required super.receiverId,
    required super.receiverName,
    required super.receiverPhotoUrl,
    required super.callStartTime,
    required super.callEndTime,
    required super.hasDialled,
  });

  Map<String, dynamic> toJson() {
    return {
      'callId': callId,
      'callerId': callerId,
      'callerName': callerName,
      'callerPhotoUrl': callerPhotoUrl,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverPhotoUrl': receiverPhotoUrl,
      'callStartTime': callStartTime,
      'callEndTime': callEndTime,
      'hasDialled': hasDialled,
    };
  }

  factory CallModel.fromJson(Map<String, dynamic> json) {
    return CallModel(
      callId: json['callId'],
      callerId: json['callerId'],
      callerName: json['callerName'],
      callerPhotoUrl: json['callerPhotoUrl'],
      receiverId: json['receiverId'],
      receiverName: json['receiverName'],
      receiverPhotoUrl: json['receiverPhotoUrl'],
      callStartTime: json['callStartTime'],
      callEndTime: json['callEndTime'],
      hasDialled: json['hasDialled'],
    );
  }
}
