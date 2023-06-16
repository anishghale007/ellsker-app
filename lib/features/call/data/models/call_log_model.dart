import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internship_practice/features/call/domain/entities/call_log_entity.dart';

class CallLogModel extends CallLogEntity {
  const CallLogModel({
    required super.callerId,
    required super.callerPhotoUrl,
    required super.callerName,
    required super.callStartTime,
    required super.callEndTime,
    required super.didPickup,
  });

  factory CallLogModel.fromSnapshot(QueryDocumentSnapshot snapshot) {
    return CallLogModel(
      callerId: snapshot['callerId'],
      callerPhotoUrl: snapshot['callerPhotoUrl'],
      callerName: snapshot['callerName'],
      callStartTime: snapshot['callStartTime'],
      callEndTime: snapshot['callEndTime'],
      didPickup: snapshot['didPickup'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "callerId": callerId,
      "callerPhotoUrl": callerPhotoUrl,
      "callerName": callerName,
      "callStartTime": callStartTime,
      "callEndTime": callEndTime,
      "didPickup": didPickup,
    };
  }
}
