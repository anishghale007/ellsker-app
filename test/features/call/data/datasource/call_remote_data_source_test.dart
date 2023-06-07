import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:internship_practice/constants.dart';
import 'package:internship_practice/core/error/exceptions.dart';
import 'package:internship_practice/features/call/data/datasources/call_remote_data_source.dart';
import 'package:internship_practice/features/call/data/models/rtc_token_model.dart';
import 'package:internship_practice/features/call/domain/usecases/get_rtc_token_usecase.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import '../../../../fixtures/fixture_reader.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late CallRemoteDataSourceImpl callRemoteDataSourceImpl;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    callRemoteDataSourceImpl = CallRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('token.json'), 200));
  }

  void setUpMockHttpClientSuccess404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response("Something went wrong", 404));
  }

  group('get RTC Token', () {
    const tGetRtcTokenParams = GetRtcTokenParams(
      channelName: "test",
      role: "publisher",
      tokenType: "userAccount",
      uid: "10",
    );
    final tVideoCallModel =
        RtcTokenModel.fromJson(json.decode(fixture('token.json')));
    test('should perform a GET request on a URL', () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      callRemoteDataSourceImpl.getRtcToken(tGetRtcTokenParams);
      // assert
      verify(
        mockHttpClient.get(
          Uri.parse(
              '${Constant.tokenBaseUrl}/rtc/${tGetRtcTokenParams.channelName}/${tGetRtcTokenParams.role}/${tGetRtcTokenParams.tokenType}/${tGetRtcTokenParams.uid}'),
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
    });

    test('should return VideoCallModel when the response code is 200 (Success)',
        () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      final result =
          await callRemoteDataSourceImpl.getRtcToken(tGetRtcTokenParams);
      // assert
      expect(result, equals(tVideoCallModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      setUpMockHttpClientSuccess404();
      // act
      final result = callRemoteDataSourceImpl.getRtcToken;
      // assert
      expect(() => result(tGetRtcTokenParams), throwsA(isA<ServerException>()));
    });
  });
}
