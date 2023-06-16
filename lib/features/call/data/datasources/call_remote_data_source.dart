import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internship_practice/constants.dart';
import 'package:internship_practice/core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:internship_practice/features/call/data/models/call_log_model.dart';
import 'package:internship_practice/features/call/data/models/call_model.dart';
import 'package:internship_practice/features/call/data/models/rtc_token_model.dart';
import 'package:internship_practice/features/call/domain/entities/call_log_entity.dart';
import 'package:internship_practice/features/call/domain/usecases/end_call_usecase.dart';
import 'package:internship_practice/features/call/domain/usecases/get_rtc_token_usecase.dart';
import 'package:internship_practice/features/call/domain/usecases/make_call_usecase.dart';
import 'package:internship_practice/features/call/domain/usecases/pickup_call_usecase.dart';
import 'package:uuid/uuid.dart';

abstract class CallRemoteDataSource {
  Future<RtcTokenModel> getRtcToken(GetRtcTokenParams params);
  Future<void> makeCall(MakeCallParams params);
  Future<void> pickupCall(PickupCallParams params);
  Future<void> endCall(EndCallParams params);
  Future<List<CallLogEntity>> getAllCallLogs(String userId);
}

class CallRemoteDataSourceImpl implements CallRemoteDataSource {
  CollectionReference dbCall = FirebaseFirestore.instance.collection("call");
  CollectionReference dbUser = FirebaseFirestore.instance.collection("users");
  CollectionReference dbCallHistory =
      FirebaseFirestore.instance.collection("call history");
  late final http.Client client;

  CallRemoteDataSourceImpl({required this.client});

  @override
  Future<RtcTokenModel> getRtcToken(GetRtcTokenParams params) async {
    final response = await client.get(
      Uri.parse(
          '${Constant.tokenBaseUrl}/rtc/${params.channelName}/${params.role}/${params.tokenType}/${params.uid}'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      log(response.body);
      return RtcTokenModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> makeCall(MakeCallParams params) async {
    try {
      String callId = const Uuid().v1();
      // caller data
      _saveCallDataToCollection(
        callId: callId,
        callDocFirstId: params.callerId,
        callDocSecondId: params.receiverId,
        callerId: params.callerId,
        callerName: params.callerName,
        callerPhotoUrl: params.callerPhotoUrl,
        receiverId: params.receiverId,
        receiverName: params.receiverName,
        receiverPhotoUrl: params.receiverPhotoUrl,
        callStartTime: params.callStartTime,
        callEndTime: params.callEndTime,
        hasDialled: true,
      );
      // setting inCall to true in the caller user collection
      await dbUser.doc(params.callerId).set({
        "inCall": true,
      });
      // call receiver data
      _saveCallDataToCollection(
        callId: callId,
        callDocFirstId: params.receiverId,
        callDocSecondId: params.callerId,
        callerId: params.callerId,
        callerName: params.callerName,
        callerPhotoUrl: params.callerPhotoUrl,
        receiverId: params.receiverId,
        receiverName: params.receiverName,
        receiverPhotoUrl: params.receiverPhotoUrl,
        callStartTime: params.callStartTime,
        callEndTime: params.callEndTime,
        hasDialled: false,
      );
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> pickupCall(PickupCallParams params) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!.uid;
      Map<String, dynamic> updateCallData = {
        "hasDialled": true,
      };
      await dbCall.doc("$currentUser-${params.userId}").set(updateCallData);
      // setting inCall to true in the call receiver collection
      await dbUser.doc(currentUser).set({
        "inCall": true,
      });
      // add a new doc in the call logs collection
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> endCall(EndCallParams params) async {
    try {
      Map<String, dynamic> updateCallerData = {
        "callEndTime": params.callEndTime,
        "hasDialled": false,
      };
      Map<String, dynamic> updateCallerStatus = {
        "inCall": false,
      };
      final callLogData = CallLogModel(
        callerId: params.callerId,
        callerPhotoUrl: params.callerPhotoUrl,
        callerName: params.callerName,
        callStartTime: params.callStartTime,
        callEndTime: params.callEndTime,
        didPickup: params.didPickup,
      ).toJson();
      /* 
      CALLER DATA
       */
      // caller user call collection
      await dbCall
          .doc("${params.callerId}-${params.receiverId}")
          .set(updateCallerData);
      // caller user call log collection
      await dbCallHistory
          .doc("${params.callerId}-${params.receiverId}")
          .collection('call logs')
          .doc()
          .set(callLogData);
      await dbUser.doc(params.callerId).set(updateCallerStatus);
      /* 
      CALL RECEIVER DATA
       */
      // receiver user call collection
      await dbCall
          .doc("${params.receiverId}-${params.callerId}")
          .set(updateCallerData);
      // receiver user call log collection
      await dbCallHistory
          .doc("${params.receiverId}-${params.callerId}")
          .collection('call logs')
          .doc()
          .set(callLogData);
      await dbUser.doc(params.receiverId).set(updateCallerStatus);
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<CallLogEntity>> getAllCallLogs(String userId) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection("call history")
          .doc("$currentUser-$userId")
          .collection('call logs')
          .get();
      return snapshot.docs.map((e) => CallLogModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  void _saveCallDataToCollection({
    required String callDocFirstId,
    required String callDocSecondId,
    required String callId,
    required String callerId,
    required String callerName,
    required String callerPhotoUrl,
    required String receiverId,
    required String receiverName,
    required String receiverPhotoUrl,
    required String callStartTime,
    required String callEndTime,
    required bool hasDialled,
  }) async {
    // call data
    final callerData = CallModel(
      callId: callId,
      callerId: callerId,
      callerName: callerName,
      callerPhotoUrl: callerPhotoUrl,
      receiverId: receiverId,
      receiverName: receiverName,
      receiverPhotoUrl: receiverPhotoUrl,
      callStartTime: callStartTime,
      callEndTime: callEndTime,
      hasDialled: hasDialled,
    ).toJson();
    // call collection
    await dbCall.doc("$callDocFirstId-$callDocSecondId").set(callerData);
  }
}
