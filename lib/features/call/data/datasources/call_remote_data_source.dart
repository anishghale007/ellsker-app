import 'dart:convert';
import 'dart:developer';

import 'package:internship_practice/constants.dart';
import 'package:internship_practice/core/error/exceptions.dart';
import 'package:internship_practice/features/call/data/models/video_call_model.dart';
import 'package:http/http.dart' as http;
import 'package:internship_practice/features/call/domain/usecases/get_rtc_token_usecase.dart';

abstract class CallRemoteDataSource {
  Future<VideoCallModel> getRtcToken(GetRtcTokenParams params);
}

class CallRemoteDataSourceImpl implements CallRemoteDataSource {
  late final http.Client client;

  CallRemoteDataSourceImpl({required this.client});

  @override
  Future<VideoCallModel> getRtcToken(GetRtcTokenParams params) async {
    final response = await client.get(
      Uri.parse(
          '${Constant.renderBaseUrl}/rtc/${params.channelName}/${params.role}/${params.tokenType}/${params.uid}'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      log(response.body);
      return VideoCallModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
