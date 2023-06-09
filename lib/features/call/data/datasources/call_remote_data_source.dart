import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internship_practice/constants.dart';
import 'package:internship_practice/core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:internship_practice/features/call/data/models/call_model.dart';
import 'package:internship_practice/features/call/data/models/rtc_token_model.dart';
import 'package:internship_practice/features/call/domain/entities/call_entity.dart';
import 'package:internship_practice/features/call/domain/usecases/end_call_usecase.dart';
import 'package:internship_practice/features/call/domain/usecases/get_rtc_token_usecase.dart';
import 'package:internship_practice/features/call/domain/usecases/make_call_usecase.dart';
import 'package:uuid/uuid.dart';

abstract class CallRemoteDataSource {
  Future<RtcTokenModel> getRtcToken(GetRtcTokenParams params);
  Future<void> makeCall(MakeCallParams params);
  Future<void> endCall(EndCallParams params);
  // Stream<List<CallEntity>> getAllChatLogs(String userId);
  Future<List<CallEntity>> getAllChatLogs(String userId);
}

class CallRemoteDataSourceImpl implements CallRemoteDataSource {
  CollectionReference dbCall = FirebaseFirestore.instance.collection("call");
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
  Future<void> endCall(EndCallParams params) async {
    try {
      // QuerySnapshot<Map<String, dynamic>> snapshot =
      //     await FirebaseFirestore.instance.collection('call').get();
      Map<String, dynamic> updateCallerData = {
        "callEndTime": params.callEndTime,
        "hasDialled": true,
      };
      await dbCall.doc(params.callerId).set(updateCallerData);
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<CallEntity>> getAllChatLogs(String userId) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection("call history")
          .doc("$currentUser-$userId")
          .collection('call logs')
          .get();
      return snapshot.docs.map((e) => CallModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  // @override
  // Stream<List<CallEntity>> getAllChatLogs(String userId) {
  //   final currentUser = FirebaseAuth.instance.currentUser!.uid;

  //   return dbCallHistory
  //       .doc("$currentUser-$userId")
  //       .collection('call logs')
  //       .snapshots()
  //       .map((event) => event.docs
  //           .map((e) => CallModel.fromJson(e as Map<String, dynamic>))
  //           .toList());
  // }

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
    // call history / logs collection for a single conversation
    await dbCallHistory
        .doc("$callDocFirstId-$callDocSecondId")
        .collection('call logs')
        .doc()
        .set(callerData);
  }
}
